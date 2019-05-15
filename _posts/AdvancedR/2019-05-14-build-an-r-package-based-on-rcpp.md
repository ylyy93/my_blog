---
layout: post
title: Build An R Package Based on Rcpp
date: 2019-05-14 20:08 -0600
categories: Tech
tags: [R]
---

Suppose we want to build a package named `myPackage`.

The following script will create a folder of the package.  
```
library(Rcpp)
Rcpp.package.skeleton("myPackage")
```

The following script will generate wrapper code if you stated `Rcpp::export` in front of your C++ functions.
```
compileAttributes(verbose=TRUE)
```

You can add R functions in the `R` folder. After that, you can update your package using the following code.
```
library("devtools")
#devtools::install_github("klutometis/roxygen")
library(roxygen2)
setwd("/path/to/myPackage")
build()
install()
```
