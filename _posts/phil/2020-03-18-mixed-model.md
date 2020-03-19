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
* assume (for now), $Cov(u) = \sigma^2_{\beta}I_{b\times b}$, $Cov(\varepsilon) = \sigma^2I_{n\times n}$.
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
* $\tau_j \sim N(0,\sigma^2_{\tau})$
* $(\alpha\tau)_{ij}\sim N(0,\sigma^2_{\alpha\tau})$
* $\varepsilon_{ijk} \sim N(0,\sigma^2)$
* $\tau_j, (\alpha\tau)_{ij}, \varepsilon_{ijk}$ are all independent.

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
* $\mu, \alpha_i, \beta_k, (\alpha\beta)_{ik}, \gamma_l, (\alpha\gamma)_{il}, (\beta\gamma)_{kl}, (\alpha\beta\gamma)_{ikl}$ are fixed effects
* $\tau_j \sim N(0,\sigma^2_{\tau})$
* $(\alpha\tau)_{ij}\sim N(0,\sigma^2_{\alpha\tau})$
* $(\alpha\beta\tau)_{ijk}\sim N(0,\sigma^2_{\alpha\beta\tau})$
* $\varepsilon_{ijkl} \sim N(0,\sigma^2)$
* $\tau_j, (\alpha\tau)_{ij},(\alpha\beta\tau)_{ijk}, \varepsilon_{ijkl}$ are all independent.
