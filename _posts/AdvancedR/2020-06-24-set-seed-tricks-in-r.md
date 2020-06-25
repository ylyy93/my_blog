---
layout: post
title: Set seed tricks in R
date: 2020-06-24 21:44 -0700
categories: Tech
tags: [R]
---

```R
fn <- function(seed=123){
 old <- .Random.seed
 on.exit( { .Random.seed <<- old } )
 set.seed(seed)
 X <- rnorm(10)
 return(X)
}
```
