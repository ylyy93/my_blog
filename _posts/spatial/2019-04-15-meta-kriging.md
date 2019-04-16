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

###### When will work?
- Full likelihood $\approx$ composite likelihood
    * depends on how we partition the data.

#### Pooled bayesian inference for spatial models

$$
y(s) = x^\top (s) + \omega(s) + \varepsilon(s)
$$   

- covariance of $\omega(s)$: $C_\theta(s,s')$.

$$
y = X\beta + \omega + \varepsilon, ~~~~~~~~ (4)
$$

- $\varepsilon \sim N(0,D(\theta))$
- $\omega \sim N(0,C(\theta))$
- prior $p(\theta)$

Sample $$\Omega = \{\beta,\theta \}$$ from (4) using MCMC.

###### Subset Posterior (posterior densities $p_k \equiv p(\Omega \| y_k)$)

- Get $M$ posterior samples from $p(\Omega \| y_k)$.

$$
\Omega_k = \{\Omega_k^{(1)},\Omega_k^{(2)},\ldots,\Omega_k^{(M)}\}
$$

###### Meta-Posterior
Geometric Median (GM) $\pi^*(\cdot\|y)$  of posterior distributions

$$
\pi^*(\cdot|y) = \arg\min_{\pi\in \mathcal{H}}\sum_{k=1}^K\|p_k-\pi\|_{\rho}
$$

For two posterior densities $\pi_1(\cdot)$ and $\pi_2(\cdot)$,

$$
\|\pi_1-\pi_2\|_{\rho} = \left\|\int \rho(\Omega,\cdot)d(\pi_1-\pi_2)(\Omega)\right\|
$$

- $\rho(\cdot)$ is a positive definite kernel function.
- assume $\rho(z_1,z_2) = \exp(-\|z_1-z_2\|^2)$.

1.Properties of GM
- unique and lies in the convex hull of the individual posteriors.
- $\int_{\Omega}\pi^{*}(\Omega\|y)d\Omega =1$

2.Form of GM

$$
\pi^*(\Omega|y) = \sum_{k=1}^K \alpha_{\rho,k}p_k, ~ \sum_{k=1}^K\alpha_{\rho,k} = 1
$$

3.Algorithm to compute GM
- use Weiszfeld's iterative algorithm

![Weiszfeld](https://ylyy93.github.io/my_blog/assets/posts/spatial/img/weiszfeld.jpeg)

# References
- [Meta-Kriging: Scalable Bayesian Modeling and Inference for Massive Spatial Datasets](https://www.tandfonline.com/doi/abs/10.1080/00401706.2018.1437474?journalCode=utch20)
