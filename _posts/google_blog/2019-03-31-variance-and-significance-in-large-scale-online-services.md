---
layout: post
title: Variance in LSOS
date: 2019-03-31 21:24 -0600
categories: Tech
tags: [analytics]
---

讲了一个large-scale online experiment中的常见现象，CV很大而effect fraction很小，从而需要很大的sample size。这跟很多在线服务的运作模式有关。比如说大部分用户都free， 公司主要通过rare events赚钱。


根本目的是了解哪个feature更好地服务于顾客的需要。

- Causal inference 的 gold standard是什么？
  * randomized experiments

 **[side notes: Important user engagement metrics]**
 - bounce rate,
 - time to first reaction,
 - number of experiences deemed positive.

 **[side notes: “traffic”]**
 - pageviews,
 - user sessions,
 - requests,
 - the like.

 **[side notes: metrics to determine which experimental change is worth launching]**

 - click-through rates on content,
 - watch times on video,
 - likes on a social networking site.

 **[side notes: experimental unit]**

- **stable unit treatment value assumption**
被treated的个体以及其response于作用于其他个体的treatment独立。
- experimental units 相互之间要保持独立。 一个例子是page views。 通常不把pageview当成experimental unit是因为我们很难说一个session上的一个用户在一个页面上收到的treatment不会影响另一个页面上的行为。

**[side notes: launch experiment的必要条件]**
- both **statistically signif icant** ( ensures that the results of the experiment are unlikely to be due to chance) and practically significant (whether the effect itself is large enough to be worthwhile.)

不包括零固然重要，比零大多少才是真正关心的。

## Effect size

$Y_i$: $i$th experimental unit.
- $Y_i \sim N(\mu,\sigma^2)$ (control)
- $Y_i \sim N(\mu+\delta,\sigma^2)$ (trt)

$\sigma^2$ 已知且相等。

###### Statistical effect size (Cohen's d)
$$
e = \frac{\delta}{\sigma}
$$

###### Why we care about effect size?

因为statistical **power** of a classical test for $\delta \not= 0$ depends on $\frac{e}{\sqrt{\widetilde{n}}}$

W: sample average differences between groups

$$
W \sim N(\delta, (\frac{1}{n_1} + \frac{1}{n_2})\sigma^2)
$$

define
$$
\frac{2}{\widetilde{n}} = \frac{1}{n_t}  + \frac{1}{n_c}
$$

then
$$
W \sim N(\delta, 2\sigma^2/\widetilde{n})
$$

 A two-sided classical hypothesis test with Type I and Type II errors no greater than $\alpha$ and $\beta$ respectively requires that
$$
\frac{\delta}{\sqrt{2\sigma^2/\widetilde{n}}} > \Phi^{-1}(1-\frac{\alpha}{2}) + \Phi^{-1}(1-\beta)
$$

$$
e\sqrt{\widetilde{n}} > \sqrt{2}(\Phi^{-1}(1-\frac{\alpha}{2}) + \Phi^{-1}(1-\beta))
$$

$$
\widetilde{m} > \frac{K(\alpha,\beta)}{e^2}
$$

$K(\alpha,\beta) = 2 (\Phi^{-1}(1-\frac{\alpha}{2}) + \Phi^{-1}(1-\beta))^2$

## Effect fraction
$$
f = \frac{\delta}{\mu}
$$
effect fractions of 1% or 2% can have practical signiVcance to an LSOS.

## Coefficient of Variation

$$
\frac{f}{e} = \frac{\delta/\mu}{\delta/\sigma} = \frac{\sigma}{\mu} := c
$$

CV for a binary Bernoulli(p) is
$$
\sqrt{(1-p)/p}
$$

If a metric is based on the average rate of rare occurrences, its underlying observations
will have high CV.

$$
n > K(\alpha,\beta)\frac{c^2}{f^2}
$$
