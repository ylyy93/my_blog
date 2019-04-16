---
layout: post
title: Meta-Kriging
date: 2019-04-15 21:04 -0600
categories: Research
tags: [spatial]
---

### divide-and-conquer strategy
![meta_kriging](https://ylyy93.github.io/my_blog/assets/posts/spatial/img/meta_kriging.jpeg)

### Conjugate non-spatial linear model
- work with posterior samples from such models

#### Conjugate Bayesian Linear Model

$$
y = X\beta + \varepsilon; ~~ \varepsilon \sim N(0,\sigma^2D)
$$

###### Prior distributions

$$
\beta|\sigma^2 \sim N(\mu_\beta,\sigma^2V_\beta)
$$

$$
\sigma^2 \sim IG(a,b)
$$

###### Posterior distributions

$$
p(\beta,\sigma^2|y) = p(\sigma^2|y)\times p(\beta|\sigma^2,y)
$$

$$
p(\sigma^2|y)= IG(a^*,b^*)
$$

$$
p(\beta|\sigma^2,y) = N(\beta|Mm,\sigma^2M),
$$

where $a^* = a+N/2$, $b^*=b+c/2$, $m=V_\beta^{-1}\mu_\beta + X^{\top} D^{-1}y$, $M^{-1}=V_\beta^{-1} + X^{\top} D^{-1}X$ and $c=\mu_\beta^{\top} V_\beta^{-1}\mu_\beta + y^{\top} D^{-1}y -m^{\top} Mm$.


#### Sampling strategy: sample from $p(\beta,\sigma^2|y)$
1. Sample $\sigma^2$ from $$IG(a^*,b^*)$$.
2. Sample $\beta$ from $N(Mm,\sigma^2M)$ for each sampled value of $\sigma^2$.

###### Computation requirements: m,M,c


### Block-independent composite likelihood
![meta_kriging](https://ylyy93.github.io/my_blog/assets/posts/spatial/img/meta_math.jpeg)
