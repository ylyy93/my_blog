---
layout: post
title: Poisson bootstrap
date: 2019-03-31 21:23 -0600
categories: Tech
tags: [analytics]
---

# An introduction to the Poisson bootstrap
方法论，怎么做bootstrap。 根本目的还是研究distribution性质，比如variation/uncertainty。

Keywords: resampling, distribution, memory, parallel

Idea:
1. 所有的观测值不能fit into a single machine.
2. 用independent sampling 的思想，尽管multinomial distribution有总数固定为n的限定，但是先斩后奏。
3. 因为对于每个观测值来说，都服从binomial(n,$\frac{1}{n}$)分布，而当n趋于无穷的时候，极限为Possion(1)分布。所以事实上我们采用Possion来进行sample。
4. 对于每个观测值，我们得到B个realization from Possion(1)
5. But the basic idea is that we formally define the Poisson bootstrap procedure to include the rejection and redoing of any resample if its size is “too far” from n.

- Why bootstrap?
    * No parametric assumptions

## Math behind bootstrap

- 每个观测值可能出现的次数（count）服从 Binomial(n,$\frac{1}{n}$)    
- 这些**counts** are jointly Multinomial(n,$\frac{1}{n},\ldots,\frac{1}{n}$)

## Big DATA

- The observations cannot fits on one machine.
- The sum of counts in the multinomial distribution are fixed, thereby negatively correlating with one another.
- independent sampling and correct afterwards.

### Method

- sample each observation from iid Binomial(n,$\frac{1}{n}$)

$$
\lim_{n\to \infty} \text{Binomial}(n,\frac{1}{n}) = \text{Poisson}(1)
$$

- generate B realizations from Possion(1) for each observation independently.

### example

每个国家下，广告每产生一次点击广告商需要支付的费用。

```
# Raw data with header
  query_id, impression_id, country_code, clicks, cost_usd
  0x23be2341, 0x701a6301, JP, 2, 1.2201
  0x57fcb234, 0x48af7063, AE, 1, 0.8234
  ...
```

```
# Aggregated data with header
  country_code, clicks, cost_usd
  0, AE, 1345, 2368.621
  0, AR, 13894, 7197.968
  ...
```

当进行bootstrap时，我们use weighted aggregate。 这些weights are drawn from independ Possion(n)

```
# Bootstrapped aggregate data with header
 resample_id, country_code, clicks, cost_usd
 0, AE, 1345, 2368.621
 1, AE, 1411, 2039.838
 2, AE, 1359, 1916.304
 ...
 0, AR, 13894, 7197.968
 1, AR, 14076, 8858.110
 2, AR, 14066, 12131.114
 ...
```

By convention, the 0th resample is the unperturbed sum, i.e. each observation appears exactly once. We can use this data to compute standard intervals for the average CPC by country using any of the standard methods for **bootstrap interval** (e.g. normal, t, quantile).

## 加强版

- 我们假定数据的每个观测值是可交换的。 如果这个假设不成立，我们可能会underestimate the variabilities of our estimator.
