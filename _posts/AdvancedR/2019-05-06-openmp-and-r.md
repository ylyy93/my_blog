---
layout: post
title: OpenMP and R
date: 2019-05-06 12:28 -0600
categories: Tech
tags: [HPC,R]
---


```
PKG_CXXFLAGS="$(echo 'Rcpp:::CxxFlags()'| R --vanilla --slave) -fopenmp" R CMD SHLIB loglikMP.cpp
```

# References
- [R and openMP: boosting compiled code on multi-core cpu-s](http://www.parallelr.com/r-and-openmp-boosting-compiled-code-on-multi-core-cpu-s/)
