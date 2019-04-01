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
