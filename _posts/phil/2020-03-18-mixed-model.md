---
layout: post
title: Mixed Model
date: 2020-03-18 23:24 -0700
categories: Statistics
tags: [sas]
---

# L1: Intro to Mixed Models
$$
Y_{n\times 1} = X_{n\times p}\beta_{p\times 1} + Z_{n\times b}u_{b\times 1} + \varepsilon_{n\times 1}
$$

In general,
* $Cov(u) = G_{b\times b}$, $Cov(\varepsilon) = R$.
* assume (for now), $Cov(u) = \sigma_{\beta}^2 I_{b\times b}$, $Cov(\varepsilon) = \sigma^2I_{n\times n}$.
* $Cov(Y) = \Sigma = \sigma^2_{\beta}ZZ^{\top} + \sigma^2I$.

### Split-plot model
Yield of oats from four Seed lots (Factor A) treated with four chemical seed treatments (Factor B).

* **Two-stage randomization**: In each of four blocks, Seed lots were randomly assigned to large whole plots. Whole plots were subdivided, then chemical seed treatments were randomly assigned to subplots.
* **Two-factor design**: Lots (A) is the “whole plot” factor. Treatments (B) is the “sub- plot” factor.

$$
y_{ijk} = \mu + \alpha_i + \tau_j + (\alpha\tau)_{ij} + \beta_k + (\alpha\beta)_{ik} + \varepsilon_{ijk}
$$
* $i=1,\ldots,a=4$ (lot), $j=1,\ldots,r=4$ (block), $k=1,\ldots,b=4$ (seed trt)
* $\mu, \alpha_i, \beta_k$ and $(\alpha\beta)_{ik}$ are fixed effects
* $$\tau_j \sim N(0,\sigma^2_{\tau})$$
* $$(\alpha\tau)_{ij} \sim N(0,\sigma_{\alpha\tau}^2)$$
* $$\varepsilon_{ijk} \sim N(0,\sigma^2)$$
* $\tau_j$, $(\alpha\tau)_{ij}$, $\varepsilon_{ijk}$ are all independent.


##### Primary interests:
seed trt effects, lot effects and ther interactions. (We are not interested in σ2, σ2 and σ2, except
as they relate to precission of fixed effect estimates.)

### The split-split plot design
Yield of rice grown with five Nitrogen rates (Factor A), three Management practices (Factor B) and three Varieties (Factor C).

* **Three-stage randomization:**
1. In each of three blocks, Nrates were randomly assigned to whole plots.
2. Within each whole plot, management practices were assigned to sub-plots.
3. Within each subplot varieties were randomly assigned to sub-sub-plots.

$$
y_{ijkl} = \mu + \alpha_i + \tau_j + (\alpha\tau)_{ij} + \beta_k + (\alpha\beta)_{ik} + (\alpha\tau\beta)_{ijk} + \gamma_l + (\alpha\gamma)_{il} + (\beta\gamma)_{kl} + (\alpha\beta\gamma)_{ikl} + \varepsilon_{ijkl}
$$
* $i=1,\ldots,a$ (level of A), $j=1,\ldots,r$ (block), $k=1,\ldots,b$ (level of B), $l=1,\ldots,c$ (level of C).
* $\mu$, $\alpha_i$, $\beta_k$, $(\alpha\beta)_{ik}$, $\gamma_l$, $(\alpha\gamma)_{il}$, $(\beta\gamma)_{kl}$, $(\alpha\beta\gamma)_{ikl}$ are fixed effects.
* $$\tau_j \sim N(0,\sigma^2_{\tau})$$
* $$(\alpha\tau)_{ij} \sim N(0,\sigma^2_{\alpha\tau})$$
* $$(\alpha\beta\tau)_{ijk} \sim N(0,\sigma^2_{\alpha\beta\tau})$$
* $$\varepsilon_{ijkl} \sim N(0,\sigma^2)$$
* $\tau_j$, $(\alpha\tau)_{ij}$, $(\alpha\beta\tau)_{ijk}$, $\varepsilon_{ijkl}$ are all independent.


### The "Random Coefficients" Model
Grain yields for $t=10$ varieties of winter wheat planted in 60 field plots (r=6/var.).
Key predictor of yield $(Y_{ij})$ is pre-plant moisture in top 36 inches of soil $(x_{ij})$.

Responses for $j$th plot of the $i$th variety:
$$
Y_{ij} = \alpha + \beta x_{ij} + a_i + b_ix_{ij} + \varepsilon_{ij}
$$

$$
\left(\begin{array}{c}
a_i \\
b_i
\end{array}\right) \sim N
\left(\left(\begin{array}{c}
0 \\
0
\end{array}\right),G\right),
$$
where
$$ G =
\left(\begin{array}{cc}
\sigma^2_a & \sigma_{ab}\\
\sigma_{ab} & \sigma^2_{b}
\end{array}\right)
$$
$$
\left(\begin{array}{c}
a_i \\
b_i
\end{array}\right)
$$ independent across varieties
$\varepsilon_{ij}\sim N(0,\sigma^2)$ i.i.d.

Each variety has its own random regression line, which centers around the average regression line.

### The two-factor "Repeated Measures" model
Assume 2r subjects are randomly split between a=2 treatment groups, r=3
subjects per group. Each subject is measured sequentially over b=6 time periods.

* $y_{ijk}$: $i=1,2$ (trt), $j=1,\ldots,r$ (subject within trt), $k=1,\ldots,6$ (period)

$$
y_{ijk} = \mu + \alpha_i + \beta_{j(i)} + \tau_k + (\alpha\tau)_{ik} + \varepsilon_{ijk}
$$
* $\mu$, $\alpha_i$, $\tau_k$, $(\alpha\tau)_{ik}$ are fixed effects.
* $\beta_{j(i)} \sim N(0,\sigma^2_{\beta(\alpha)})$
* $\beta_{j(i)}$ independent of the $\varepsilon_{ijk}$, but $\varepsilon_{ijk}$ are not independent of each other.

##### AR(1)

$$ Cov
\left(\begin{array}{c}
\varepsilon_{ij1} \\
\varepsilon_{ij2} \\
\varepsilon_{ij3} \\
\varepsilon_{ij4} \\
\varepsilon_{ij5} \\
\varepsilon_{ij6}
\end{array}\right) =
\left(\begin{array}{c}
      \sigma^2 & \rho^1\sigma^2 & \rho^2\sigma^2 & \rho^3\sigma^2 & \rho^4\sigma^2 & \rho^5\sigma^2 \\
\rho^1\sigma^2 &       \sigma^2 & \rho^1\sigma^2 & \rho^2\sigma^2 & \rho^3\sigma^2 & \rho^4\sigma^2 \\
\rho^2\sigma^2 & \rho^1\sigma^2 &       \sigma^2 & \rho^1\sigma^2 & \rho^2\sigma^2 & \rho^3\sigma^2 \\
\rho^3\sigma^2 & \rho^2\sigma^2 & \rho^1\sigma^2 &       \sigma^2 & \rho^1\sigma^2 & \rho^2\sigma^2 \\
\rho^4\sigma^2 & \rho^3\sigma^2 & \rho^2\sigma^2 & \rho^1\sigma^2 &       \sigma^2 & \rho^1\sigma^2 \\
\rho^5\sigma^2 & \rho^4\sigma^2 & \rho^3\sigma^2 & \rho^2\sigma^2 & \rho^1\sigma^2 &       \sigma^2  
\end{array}\right)
$$

1. This model does assume homogeneity of variance.
2. The correlation between two measurements on the same subject decreases
exponentially with the number of time periods separating the two measurements.


# L2: Incomplete Block Designs and Random Blocks
$$
Y_{ij} = \mu + \tau_i + \beta_j + \varepsilon_{ij}
$$
What these models have in common is that comparison of treatment means does not eliminate block effects, as it does in the randomized complete block design.

Basic problem: What to do if there are more treatments than the “natural” number of EU’s in a block.

Example: Trts are: A, B, C We want to use “lab day” as a block, but the lab can do only 2 runs per day. The “natural” block size is 2.

This design is “balanced” in the sense that each treatment occurs in a block
with each other treatment the same number of times ($\lambda$). In our example $\lambda=1$.

It is not “balanced” in the sense of the RCB, in which block effects can that each combination of trt and block occurs the same number of times.

In the fixed block analysis, to test trt effects use Type III SS $\noteq$ Type I SS.