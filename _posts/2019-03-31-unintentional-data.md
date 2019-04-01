---
layout: post
title: Unintentional data
date: 2019-03-31 20:18 -0600
categories: Tech
tags: [analytics]
---

###### Observation Data: We formulate and test hypotheses after we have observed the outcomes.

这样有什么问题呢？

1. correlation 推不出 causation。
2. selection bias (members are not randomly assigned)
3. multiple hypothesis tests (correction)
4. data dredging.

**[side notes: post hoc hypotheses]**
发现A比B好之后，将data按照covariates切分，从而了解为什么会这样。这种情况下，我们没有事先的猜想和提出的causal mechanism。

具体实现。
- 我们在切分出来的subpopulation上，计算metrics of interest. 然后计算差值。

因为现在data那么多那么杂，数据科学家的主要任务概括为如下几种。
1. 跟我们的目标相关吗？
2. 如果显著，可操作性强吗？
3. 观察到的effect是causal的还是random variation

###### Observation Data 的特点以及处理Observation Data 中的困难

1. Selection bias
2. Multiple hypothesis testing

###### 方法论

1. 跟上个月(变化未开始)比较。
  * 问题：seasonality， year-to-year variation。
2. differences-in-differences approach。
  * Compare
  $$\text{diff}_{\text{treatment}}$$ to
  $\text{diff}_{\text{control}}$ .
  * 比的不是metric， 而是metric difference。
  * assumption： parallel trend。 （the groups must have similar additive trends prior to the intervention.）
3. Synthetic control (Bayesian structural time series model).  (weighted combination of climbing time series data from different mountains.) 把别的地方的time series当作covariates。
  * 可以看作是更加rigorous的differences-in-differences model。
4. Retrospective (prospective) cohort study, or a case-control study.
  * tracking an identified population of individuals longitudinally
  * idea: group similar users and tracking their outomes.
  * propensity matching 也可以看作一种grouping method。
  * although we only have observational data, if we take care in what we observe and compare we may still be able to make causal claims

###### Four causality guideline related to unintentional DATA

1. Strength of effect.
  * A larger association is more likely causal.
2. Consistency.
  * Can we observe the effect in different places, under different circumstances or at different times?
3. Biological gradient.
  * Subjects in slices that see greater exposure to the proposed causal mechanism should (probably) exhibit a greater response.
4. Temporality.
  * The effect must follow the cause. 先因后果。
