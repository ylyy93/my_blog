---
layout: post
title: Rmpi on mac
date: 2019-05-06 14:23 -0600
categories: Tech
tags: [HPC,R]
---

### Install Command Line Tools through XCode

In your terminal, type
```
xcode-select --install
```


### Install gcc
```
brew install gcc
```

### Install Open MPI
```
brew install open-mpi
```
optional:
```
brew link --overwrite open-mpi
```

### Install Rmpi
```
install.packages("Rmpi", type="source")
```

### Test Rmpi
```
library(Rmpi)
mpi.spawn.Rslaves(nslaves=mpi.universe.size() - 1)
mpi.parReplicate(100, mean(rnorm(1000000)))
mpi.close.Rslaves()
mpi.quit()
```

# References
- [Rmpi for Mac OS X](http://fisher.stats.uwo.ca/faculty/yu/Rmpi/)
