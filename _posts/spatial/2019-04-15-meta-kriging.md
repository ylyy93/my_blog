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

where $a^\* = a+N/2$, $b^\*=b+c/2$, $m=V_\beta^{-1}\mu_\beta + X^{\top} D^{-1}y$, $M^{-1}=V_\beta^{-1} + X^{\top} D^{-1}X$ and $c=\mu_\beta^{\top} V_\beta^{-1}\mu_\beta + y^{\top} D^{-1}y -m^{\top} Mm$.


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

## Simulation Setting

Objectives:
1. parameters
2. interpolation
3. prediction

Focus:
1. GP based geostatistics
2. GP with compactly supported correlation functions

Simulation 1:
1. moderately large (n=3,500)
2. allows
  - full Bayesian impletation of the full Gaussian process model (w.o. approximation).
  - GP model with compactly supported correlation (CSC)
  - SMK approximations to the full GP (SMK-GP)

Simulation 2:
1. 41,000 locations.

Data generation:
- datasets from both simulations are from a standard GP model with the `RandomFields` package.

Competitors:
1. `laGP`:
2. `LatticeKrig`:
3. BISP (Block independent pooled spatial models)
  - step 1: fits a spatial model independently on K exhaustive and mutually exclusive subsets of data.
  - step 2: weighted inference is drawn based upon subset posteriors and weight 1/K corresponding to each subset posterior.

Subset partitioning scheme????
- Scheme 1: random partitioning scheme:
  - Draw $S_1$, the first subset, randomly from the full data.
  - For k = 2,...,K, draw $S_k$, the kth subset, randomly from $S-(\cup_{i=1}^{k-1}S_i)$.
- Scheme 2: k-means scheme:
  - clustering into K different clusters
  - inferior than random partitioning scheme.
- Scheme 3: random-block partitioning (RBP)
  - 跟Scheme 1相差无几。

How many clusters?
- K = 3,6,10 => n = 1000, 500, 300


Parallel Implementation:
  - `doParallel`
  - `foreach`
  - Unix workstation with 64 cores.

Surface interpolation:
  - `MBA`

All predictive inferences are based upon 25 simulated datasets.



# References
- [Meta-Kriging: Scalable Bayesian Modeling and Inference for Massive Spatial Datasets](https://www.tandfonline.com/doi/abs/10.1080/00401706.2018.1437474?journalCode=utch20)
