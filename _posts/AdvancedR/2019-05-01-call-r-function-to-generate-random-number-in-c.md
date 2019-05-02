---
layout: post
title: Call R function to Generate Random Number in C
date: 2019-05-01 16:31 -0600
categories: Tech
tags: [R]
---

下面函数可用：
```
double unif_rand();
double norm_rand();
double exp_rand();
```
为了确保程序的可重复性，我们在用到这些rand函数的前后分别用`GetRNGstate()`和`PutRNGstate()`来读取和写入`.Random.seed`。

在`Rmath.h`头函数中，我们可用：
```
double rnorm(double mu, double sigma);
double rgamma(double a, double scale);
```


# Refenreces
- [C programming III](http://www.biostat.jhsph.edu/~bcaffo/statcomp/files/cprog3_ho.pdf)
