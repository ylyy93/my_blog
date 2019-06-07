---
layout: post
title: Useful scripts in R
date: 2019-06-07 12:40 -0600
categories: Tech
tags: [R]
---

### Detach R packages

```
detach_package <- function(pkg, character.only = FALSE)
{
  if(!character.only)
  {
    pkg <- deparse(substitute(pkg))
  }
  search_item <- paste("package", pkg, sep = ":")
  while(search_item %in% search())
  {
    detach(search_item, unload = TRUE, character.only = TRUE)
  }
}
```

```
detach_package(vegan)
```

# References
- [How to unload a package without restarting R](https://stackoverflow.com/questions/6979917/how-to-unload-a-package-without-restarting-r)

### Install R packages if not installed

```
install.and.load.libraries <- function(packages){
  new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  suppressMessages(
    invisible(lapply(packages, require, character.only = TRUE))
  )
}

install.and.load.libraries(c("spatstat","RandomFields"))
```
