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
