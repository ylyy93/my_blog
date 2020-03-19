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
* i (trt), j (block)

What these models have in common is that comparison of treatment means does not eliminate block effects, as it does in the randomized complete block design.

Basic problem: What to do if there are more treatments than the “natural” number of EU’s in a block.

Example: Trts are: A, B, C We want to use “lab day” as a block, but the lab can do only 2 runs per day. The “natural” block size is 2.

This design is “balanced” in the sense that each treatment occurs in a block
with each other treatment the same number of times ($\lambda$). In our example $\lambda=1$.

It is not “balanced” in the sense of the RCB, in which block effects can that each combination of trt and block occurs the same number of times.

In the fixed block analysis, to test trt effects use Type III SS $\neq$ Type I SS.

###### Example: The Pillow Data
Eight experimental pillows and a standard control pillow (A, B, C, D, E, F, G, H, I) are tested by potential customers (t=9). Because it was believed that more accurate results would be obtained if individuals were asked to test only three pillows at a time, pillows were tested in groups of three (k=3). Each individual tested all twelve (b=12) groups of pillows. The assignment of pillows to groups was a BIBD. The response is total firmness score for all testers.

```
proc mixed method=type1;
class blk pillow;
model firmness=pillow;
random blk;
*lsmeans pillow /pdiff adjust=tukey;
run;
```
* `method`: type1, type3, MIVQUE0, REML(default), ML
*  REML is the default method in SAS `Proc Mixed` and SAS `Proc GLIMMIX`, `lmer` (lme4 package in R), and `lme` (nlme package in R).
* For balanced (RCB, not BIBD) factorial models it produces the same variance estimates as the ANOVA method, as long as no variance estimate from the ANOVA method is negative.
* If during the REML optimization an estimated variance parameter becomes zero, the program fixes its estimate at zero and proceeds to optimize w.r.t. the other variance parameters (except if you use the `parms/nobound;` statement in SAS).
* SAS allows you to start the optimization with a grid search:
```
parms (0 to 3.0 by 0.1) (25 to 40 by 1);
```
(The option: `/noiter;` tells it to stop at the grid search).
* REML estimators have the same asymptotic properties as ML.
* REML estimators are commonly used for unbalanced models.
* Remember, you are assuming **normality** when you use REML.
* Model selection for the variance parameters ($\theta$) can be done based on AIC, AICC, BIC, etc. if you are comparing models that have **the same fixed effects** (i.e. the same C(X)). (It is a common mistake to compare AIC’s in models with different X’s.)

```r
blk <- factor(blk)
install.packages("lme4")
library(lme4)
h <- lmer(firmness ~ pillow + (1|blk))
summary(h)
anova(h)
# simulation based Tukey comparisons of lsmeans
install.packages("multcomp")
library(multcomp)
dhh <- glht(h, linfct = mcp(pillow = "Tukey"))
summary(dhh)  # Gives the adjusted p-values

install.packages("lsmeans")
library(lsmeans)
lsmeans(h,pairwise~pillow) # Default d.f. is Satterthwaite with Tukey adjusted p-values

# The Kenward-Roger method is preferred, but takes more time. Again the default is Tukey adjusted p- values
lsmeans(h,pairwise~pillow, mode="kenward-roger")

# To compare models with different fixed effects using the Kenward-Roger adjusted F-test, use the KRmodcomp function in the pbkrtest package. It automatically changes both models to REML=TRUE, if they are not already fitting using REML=TRUE.
install.packages("pbkrtest")
library(pbkrtest)
k <- lmer(firmness ~ (1|blk)) # k is the “small” or “reduced” model
KRmodcomp(h,k)

# To compare models using the Parametric Bootstrap of the likelihood ratio test statistic, use the KRmodcomp function in the pbkrtest package. It automatically changes both models to REML=FALSE, if they are not already fitting using ML. (REML likelihoods are not comparable between models with different fixed effects.)
PBmodcomp(h,k)

# The number of Bootstrap resamples can be changed (note the time).
PBmodcomp(h,k, nsim=10000)
```

* Use lm to analyze fixed block models in R. **Make sure “treatment” is added last**, so that treatments will be adjusted for blocks.
* For fixed or random block models, don’t use TukeyHSD, or any of the “tables” commands to compare treatments.
* For random block models use the `lmer` function in the `lme4` package. This package does not do t-tests or F-tests, because is does not estimate df error.
4. Follow the `lmer` function with functions in `multcomp`, `lsmeans`, and `lmerTest` packages to test effects and compare treatments. `lmerTest` and `lsmeans` have options to call the `pbkrtest` package to do the `Kenward-Roger` approximation, which is recommended.
5. I use the `KRmodcomp` in the `pbkrtest` package to compare models.
6. The `lme` funtion in the old `nlme` package fits mixed models, but it is very awkward for blocked designs. However, it has “containment” method F-tests. Also, `lme4` does not allow correlated errors, which become important later in the “repeated measures” designs.
