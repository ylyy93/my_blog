---
layout: post
title: Nearest Neighbor Gaussian Process
date: 2019-04-16 09:44 -0600
categories: Research
tags: [spatial]
---

Notations:
- $n$: sample size
- A spatial linear mixed model

$$
y(s_i) = x(s_i)^{\top} \beta + \omega(s_i) + \varepsilon(s_i)
$$

###### Bayesian Hierarchical Models

$$
p(\beta,\theta,\tau^2) \times N(w|0,C) \times N(y|X\beta+w,\tau^2I) ~~~~ (2)
$$

###### Joint distribution of $w$

$$
p(w) = p(w_1)\prod_{i=2}^np(w_i|Pa[i])
$$

- $w_i\equiv w(s_i)$
- Parents: $$Pa[i]=\{w_1,w_2,\ldots,w_{i-1}\}$$

####### Density $N(w|0,C)$ as a linear model

$$
w_1 = 0 + \eta_1
$$

$$
w_i = a_{i1}w_1 + a_{i2}w_2 + \cdots + a_{i,i-1}w_{i-1} + \eta_i, ~~~ \text{for}~~~ i = 2,\ldots,n
$$

$$
w = Aw + \eta
$$
