---
layout: post
title: Compliance bias
date: 2019-03-31 18:50 -0600
categories: Tech
tags: [analytics]
---

这篇的问题是，假如给用户assign了treatment， 但是用户不服从，或者需要很长时间去服从。我们又不想等那么久，直到大部分人都更新了再得出结论。

比如说游戏更新，如果一个人很少上线，那么即使他在treatment group，他也很难upgrade。所以这一类人群在treatment group中是underrepresented。

核心方法总结：
1. 只考虑treatment(assignment) group, 进行propensity score
$P(U=1|X)$ 建模.
2. 基于propensity score进行bucketize.
3. 在每个bucket上算difference of (Inverse Probability Weighted Estimator) of Y(1,1) and Y(0,0).

## Math
观测值：$(X_i, Y_i)$.
- $X_i$:
  * country,
  * device quality,
  * a bucketed measure of how often the user has played the game in a predefined period prior to the experiment.
- $Y_i$: number of times a user opens the game each day.

Assumption: the impact of the treatment is **instantaneous** and does not further evolve over time.

- Q: assignment
- U: experience

||Q=0|Q=1||
|---|---|---|---|
|U=0|control complier|defier|never-taker|
|U=1|defier(sideloading behavior)|treatment complier|Always-taker|


### Issue 1: treatment group中真正服从了treatment 的用户数目随着时间增加（not immediate compliance）。

![](https://1.bp.blogspot.com/-6Bq_8ZA0jrQ/WrM_7ptvmdI/AAAAAAAAc1g/FNF2RORH7LsfssHTQX4EnIZLQcs5ElRWgCEwYBhgL/s1600/F1__ramp_up.png)
### Issue 2: Not SRS
哪些用户会更新呢？
- better connectivity
- hardware quality
- core operating system software
- country
- frequency of use of the product

这个问题的根本是generalization。因为不是SRS所以sample data 的结构跟population并不一样。
![](https://2.bp.blogspot.com/-nV-i__zg3ag/WrM_7httUzI/AAAAAAAAc2A/6Y5f4AHzd08gzlotk54zKpHbmkkbrEa1wCEwYBhgL/s1600/F2__user_properties.png)
### Issue 3: timely decision


**[side notes: total compliance]**
- 每个用户在被assign treatment的瞬间完成更新。
- allows us to make strong inferences about the impact of the treatment condition.

模型基于两个时间点：
- $T_{measure}$ a time point at an early stage.
- $T_{final}$ benchmark. 可能upgrade的用户到此时都更新了。

#### Intent to treat analysis
不管users是否服从，按照treatment assignment来。

$$
\theta = E(Y|U=1) - E(Y|U=0)
$$

$$
\theta_{\text{ITT}} = E(Y|Q=1) - E(Y|Q=0)
$$

$$
\hat{\theta}_{\text{ITT}} = \frac{1}{N_{Q=1}}\sum_i Y_i[Q_i=1] - \frac{1}{N_{Q=0}}\sum_j Y_j[Q_j=0]
$$

###### 缺点：
- 本该受到treatment影响的人因为refuse to upgrade，导致treatment effect被shrink。

#### Treatment on the Treated analysis
用treatment group中真正experience treatment的人跟control group中的所有人进行比较。

$$
\hat{\theta}_{\text{TOT}} = \frac{1}{N_{Q=1,U=1}}\sum_i Y_i[Q_i=1\cap U_i=1] - \frac{1}{N_{Q=0}}\sum_j Y_j[Q_j=0]
$$

![](https://3.bp.blogspot.com/-YrYPb7iBrzQ/WrM_8qQNyWI/AAAAAAAAc2M/KB9KMwyGLcI1DoQ8akTZOTw_mxB9aXu1gCEwYBhgL/s1600/F4__ITT_TOT_first_last.png)

用户行为分析。

|(Q,U),(Q',U')|User Type|Description
|---|---|---|
|(0,0);(1,0)|**Never-taker**|Never upgrade|
|(0,0);(1,1)|**Compiler**|upgrade if offered|
|(0,1);(1,0)|Defier|唱反调|
|(0,1);(1,1)|Always-taker|sideloading|

前两者比较普遍，后两者占比非常少。


## Propensity score within the Treatment

首先分析treatment。 也就是说我们关注treatment group (Q=1)，对是否experience treatment建模(observational study)。

#### Propensity modeling


$$
\text{logit}(\text{Pr}(U|X,Q=1)) = X\beta
$$

#### Estimation: Stratification/Bucketing methods
对estimated propensity score $\text{Pr}(U=1|X)$ 进行bucket。
- perform analysis within each bucket
- collect the within-bucket estimates to form an overall estimate.
因为我们的propensity model是对covariates进行建模，所以本质上是基于covariates进行bucketize。

$$
\hat{\theta}_{p-weight,k} = \frac{\sum_i \frac{Y_i}{\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=1\cap U_i=1]}{\sum_i \frac{1}{\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=1\cap U_i=1]} -
\frac{\sum_i \frac{Y_i}{1-\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=1\cap U_i=0]}{\sum_i \frac{1}{1-\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=1\cap U_i=0]}
$$

$$
\hat{\theta}_{p-weight} = \frac{\sum_k N_k\hat{\theta}_{p-weight,k}}{\sum_k N_k}
$$

![](https://2.bp.blogspot.com/-gk-mG5BOWBA/WrM_8okGWaI/AAAAAAAAc2E/cXiAqN9isuQXuqaamN7qJYM7cq-jXv7cQCEwYBhgL/s1600/F6__weighting_bucket_plot.png)

## Propensity score matching to the control

在treatment group中，随着propensity score变大，$Y(1,0)$越来越少。 也就是说当propensity score大的时候，control(experience) group data不够，导致很大偏差。但是在control group中， control(experience) data， 即$Y(0,0)$足够多。

If propensity score model w.r.t X generalize well to the control group, i.e., we assume $\text{Pr}(U=1|X,Q=0) = \text{Pr}(U=1|X,Q=0)$ and $Y(0,0) = Y(1,0)$.

目标： estimate $E(Y(1,1)-Y(1,0))$,


$$
\hat{\theta}_{p-match,k} = \frac{\sum_i \frac{Y_i}{\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=1\cap U_i=1]}{\sum_i \frac{1}{\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=1\cap U_i=1]} -
\frac{\sum_i \frac{Y_i}{1-\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=0\cap U_i=0]}{\sum_i \frac{1}{1-\hat{p}_i}[\hat{p}_i\in S_k\cap Q_i=0\cap U_i=0]}
$$


![](https://3.bp.blogspot.com/-dH2Wdhxxqdg/WrM_9HOlDbI/AAAAAAAAc2I/ThiZeliVaEMGNjzTfj4-Zxr_GKULkXvoACEwYBhgL/s1600/F7__matching_bucket_plot.png)

![](https://2.bp.blogspot.com/-uKSkyqB_97w/WrM_9VMPdkI/AAAAAAAAc2A/z4z8NP38pi0MvtN88j2tms_wbWKZ5P-TwCEwYBhgL/s1600/F8__propensity_first_last.png)
