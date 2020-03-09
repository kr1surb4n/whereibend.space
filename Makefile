.PHONY: help clean clean-build clean-pyc clean-test coverage check_code dist dist-upload docs document docker format_code install lint requirements servedocs test test-all virtualenv html help clean regenerate serve serve-global devserver stopserver pelican-publish

.DEFAULT_GOAL := help

AUTHOR="Kris Urbanski"
APP_NAME=publishing
WORKING_BRANCH=page_`date +%Y%m%d`
ORIGIN=git@github.com:przor3n/whereibend.space.git

a:
	echo $(AUTHOR)
	echo $(WORKING_BRANCH)

clean: clean-pyc ## remove all build, test, coverage and Python artifacts

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

build:
	export  BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	git checkout -b $(WORKING_BRANCH)
	## make prepare-content
	make generate-page
	## I would add here some tests
	git add -A
	git commit -m "New page update `date +%Y-%m-%d`"

docker: clean
	docker build -t $(APP_NAME):latest .

generate-page:
	rm -fr output/*
	pelican content -t themes/svbtle -s pelicanconf.py

prepare-content:
	# export PB_AUTHOR=$(AUTHOR)
	# rm -fr content/*
	# publishing_boy notes content

publish: build
	git checkout master
	git merge -s resolve $(WORKING_BRANCH)
	git push $(ORIGIN) master
	git branch -D $(WORKING_BRANCH)


requirements:
	.venv/bin/pip freeze --local > requirements.txt

virtualenv:
	virtualenv --prompt '|> $(APP_NAME) <| ' .venv
	.venv/bin/pip install -r requirements_dev.txt
	pelican-themes --install themes/cebong
	@echo
	@echo "VirtualENV Setup Complete. Now run: source .venv/bin/activate"
	@echo


PY?=python
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py


DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
endif

serve-global:
ifdef SERVER
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b $(SERVER)
else
	$(PELICAN) -l $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT) -b 0.0.0.0
endif


devserver:
ifdef PORT
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -p $(PORT)
else
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
endif

pelican-publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
