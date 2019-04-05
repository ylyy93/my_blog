---
layout: post
title: Bayesian structural time series
date: 2019-04-04 14:18 -0600
categories: Tech
tags: [analytics]
---

- **1. [Facebook `Prophet` system for time series forecasting]**
- **2. [Google `bsts` `R` package]**

Goal: forecasting daily data into the distance future.
Method:
 * Facebook: regularized regression
 * averaging ensemble of forecast
 * both work with daily data with careful treatment of holidays.

## Bayesian structural time series model (State space model/Kalman Filter Model/Dynamic Linear models)

- observed data $y_t$
- latent variables $\alpha_t$ (state)

$$
y_t = Z_t^{\top} \alpha_t + \epsilon_t
$$

state transition:

$$
\alpha_{t+1} = T_t\alpha_t + R_t \eta_t
$$

- both $\epsilon_t$ and $\alpha_t$ are Gaussian and independent of each other.
- $Z_t$, $T_t$ and $R_t$ are structural parameters.
- the structure of $\alpha_t$ based on
  * short v.s. long term
  * seasonal effects
  * whether and how regressors are to be included.

### Local level model: random walk observed in noise

$$
y_t = \mu_t + \epsilon_t
$$

$$
\mu_{t+1} = \mu_t + \eta_t
$$

**[Side Notes: exponential smoothing]**

Past data are forgotten at an exponential rate.


#### Example 1: Nowcasting
- 官方数据公布有延迟和改动。
- 短期数据。（已经发生但是没有发布）

### Local Linear Model

$$
y_t = \mu_t + \tau_t + \beta^{\top}x_t + \epsilon_t
$$

$$
\mu_{t} = \mu_{t-1} + \delta_{t-1} + \eta_{0t}
$$

$$
\delta_{t} = \delta_{t-1} + \eta_{1t}
$$

$$
\tau_{t} = -\sum_{s=1}^{S-1}\tau_{t-s} + \eta_{2t}
$$

- $\mu_t$ trend
- $\tau_t$ seasonal pattern
- 博客上面的式子错了， 还是参考以下paper里的
- Scott, S. L. and Varian, H. R. (2014). [Predicting the present with Bayesian structural time series.](http://people.ischool.berkeley.edu/~hal/Papers/2013/pred-present-with-bsts.pdf) International Journal of Mathematical Modelling and Numerical Optimisation 5, 4–23.


**[如何处理high dimension]**
- Bayesian的思想是，通过一个prior distribution that induces sparsity。
- A **spike and slab prior** is a natural way to express a prior belief that most of the regression coefficients are exactly zero.

**spike and slab prior:**
- assigns a positive probability of being zero.
- When sampling from the posterior distribution of a regression model under a spike and slab prior, many of the simulated regression coefficients will be exactly zero. (本身simulation就是零)
- This is unlike the "lasso" prior (the Laplace, or double-exponential distribution), which yields MAP estimates at zero but where posterior simulations will be all nonzero. （simulation不是零，但是估计是零）

### Semilocal linear trend model
- replace the random walk with a stationary AR process. 因为random walk时间越长variance越大。

$$
\mu_{t+1} = \mu_{t} + \delta_t + \eta_{0t}
$$

$$
\delta_{t+1} = D + \rho(\delta_t - D) + \eta_{1t}
$$

### Recessing modeling （NON-GAUSSIAN)
- Kalman Filter需要Gaussian assumption。

- dynamic logistic regression model to model serial dependence.
$$
\text{logit}(p_t) = \mu_t + \beta^{\top} x_t
$$

$$
\mu_{t+1} = \mu_t + \eta_t
$$
