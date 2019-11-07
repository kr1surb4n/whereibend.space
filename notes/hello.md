Hello there world.

Finaly I've finished whole thing with publishing pipeline.
Now I can write whatever I want in markdown file (or in Orgmode
file, but I have to export it to markdown) and have that
published to page simply with `make publish` from within
a repository. Basically I've build a CMS using markdown files,
gnu make, a small processing script I've wrote called `publishing_boy`,
pelican static site generator, git and github. All is running 
on nginx that serves static files(why need cache when you can have
static files?), which are updated every hour by pulling stuff
from github repository. I could have skipped the publishing_boy
by writing stuff directly in markdown template file and
filling stuff by hand to make it even more simpler.

But, the publishing_boy's duty is to do stuff for me. For know
it's simple, so this post will have some errors for sure.
This is not a problem, cause when I make it better, this
note will be also better. I want to make some spell checking
and maybe even make something like gramarly. Who knows.
Important stuff is that I've learned a lot doing this.

Yay! I've started my fight in the great meme war! :D
