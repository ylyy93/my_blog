---
layout: post
title: random effects models in prediction
date: 2019-03-31 21:27 -0600
categories: Tech
tags: [analytics]
---

- Problem: Prediction
- Model: Random Effects model
- Fitting: Matrix factorization

**[side notes: Random Effects Model]**
1. summarize the variation in the response.
2. produce an adaptive regularization through the learned prior.
3. considered as an application of empirical Bayes.
4. produce an estimate of prediction uncertainty (predictive posterior)

**[side notes: Implementation in `R`]**
- [`lme4`](https://cran.r-project.org/web/packages/lme4/index.html) `R` package

### Comparison
- **Random effects model** v.s.
- Penalized GLM
  * Elastic Net regularization

![](http://2.bp.blogspot.com/-5Z-sCWwu2TU/Vv7NXfEUr7I/AAAAAAAAa9c/O1fOiR5dxlIm8YuNkpgGWLsfy0lfQmY3w/s1600/per_segment_acc_20160401.png)

Random effects model is better.

### Scalability studies

- [A Scalable Blocked Gibbs Sampling Algorithm
For Gaussian And Poisson Regression Models](https://arxiv.org/pdf/1602.00047.pdf)

- Gibbs sampler method is not so severely affected by the random effect model matrix structure.
![](http://4.bp.blogspot.com/-Ej4soocavso/Vv8Lj-3baJI/AAAAAAAAa9w/AHwu7IliFkY0xcd5UJErFd_GsGPejAp9g/s1600/vs_lme4_timing_20160401_v2.png)
