## Put common variables in `global.r`
If a large dataset or object is meant to be shared across multiple sessions (instead of reloaded for each user),
putting it in `global.r` will reduce the memory usage of your Shiny server.

### Example: App involving two ggplots, a map of the United States, and a data table
On Ubuntu, to check out how much memory each addition session uses, load your app on another computer (e.g. a smartphone)
and type in `free -m` on the server side. Before placing shared variables inside `global.r`, each new session
increased memory usage by 20 MB. This was not ideal for a server that only had 1GB of RAM. On the other hand, 
after placing the majority of the data in `global.r`, each additional session did not increase memory usage.

'''Before using `global.r`, multiple sessions'''
~~~~
              total        used        free      shared  buff/cache   available
Mem:            992         535         162          14         294         287
Swap:           511          89         422
~~~~

'''After using `global.r`, multiple sessions`'''
~~~~
              total        used        free      shared  buff/cache   available
Mem:            992         433         238          14         320         388
Swap:           511          89         422
~~~~

### See More
https://shiny.rstudio.com/articles/scoping.html