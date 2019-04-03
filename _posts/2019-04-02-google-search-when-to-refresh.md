---
layout: post
title: 'Google Search: when to refresh'
date: 2019-04-02 11:19 -0600
categories: Tech
tags: [analytics]
---

Google search 的核心：爬取网页。（snapshot of the internet）

几个术语：
- fresh: snapshot = real-world counterpart
- stale: snapshot is not acceptable

###### Object 1: optimize an overall freshness metric. (Hard to Implement)
Metric:
- a weighted average of the freshness metric for each snapshot.
- weight(web page) (akin to PageRank)

Crawl policy:
- estimate maximum crawl rate for each host
- constraint of compute and network resources (overall limit)

Math:
- static (no change over a brief period of time)
- model arrivals of changes at each web page as a possion process.

Possion rate for Page j on Host i: $\delta_{ij}$ is constant over the life of a solution.

Parameters:
- value of page j on host i: $w_{ij}$
- maximum crawl rate on Host i: $k_i$
- maximum global crawl rate: (k_0)

Optimization problem:
- At a period of time $\tau$ since the last time Page $j$ on host $i$ is crawled, the probability that it will be fresh will be $e^{-\delta_{ij}\tau}$
- If page j is recrawled every $\Delta){ij}$ time units, its probability beinf fresh at a time chosen unifromly over this period will be $\frac{1}{\Delta_{ij}}\int_{0}^{\Delta_{ij}}e^{-\delta_{ij}\tau}d\tau$ or $\frac{1}{\delta_{ij}\Delta_{ij}}(1-e^{-\delta_{ij}\Delta_{ij}})$.

$\sum \text{Pr(page j on host i being fresh)}\times \text{importance(page j on host i)}$.

###### Object 2: decide which next few web pages to crawl.

- crawl rate:
$$
\rho_{ij} = \frac{1}{\Delta_{ij}}
$$
