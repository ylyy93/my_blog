---
layout: post
title: Designing A/B tests in a collaboration network
date: 2019-03-31 21:20 -0600
categories: Tech
tags: [analytics]
---

- 有点类似于overleaf的合作项目。说的是google cloud 上的collaboration。 在同一个项目下的users会相互影响。所以我们想要给同一个project下的users分配同样的treatment。所以experimental unit不再是users本身，而是一个个由project联系在一起的component。
- 当component中的用户数不同时，treatment effect会变化很大。所以SRS会有很大的variability。为了减少这种variability，我们采用分层抽样的办法。
![](blog_collaborate.png)

## Network effects
- **Homophily (Similarity)**:
users collaborating in network tend to behave similarly. For example, developers working on a specific mobile app show similar behavior in usage. We use **hierarchical models** for this effect.
- **Spillover (Contamination)**: direct treatment effects can spill over through network connections. We conservatively limit the degree of spillover effects to immediate neighbors.

## Math
###### hierarchical structure: component $\to$ account $\to$ project.

$$
y_{i,j,k} \sim c_i + a_{i,j} + p_{i,j,k}
$$

- $c_i$: reponse from component $i$
- $a_{i,j}$ from account $j$ in component $i$
- $p_{i,j,k}$ from project k in account j in component i.

这三者都是random effects。
- $c_i \sim N(0,\sigma_c^2)$
- $a_{i,j} \sim N(0,\sigma_a^2)$
- $p_{i,j,k} \sim N(0,\sigma_p^2)$

###### Q: How random effects model model potential correlation among accounts and projects within a component?

###### Spillover effects
$$
y_k \sim \mu + \tau z_k + \gamma\tau a_k^{\top}\cdot Z
$$
- Z: vector (trt assignment)
- a_k: the kth column of adjacency matrix A. $m^{th}$ element of $a_k$ is 1 if the $k^{th}$ user and $m^{th}$ user are connected.

$$
y_{i,j,k} \sim \mu + \tau z_k + \gamma\tau a_k^{\top}\cdot Z +(c_i + a_{i,j} + p_{i,j,k})
$$

## Dynamic evolution.
- create
- split
- remove
- merge

前三者问题不大，就是增加或者去掉一个（多个）arm(s) 。最后比较复杂， 因为consistency不再。 处理方法此篇没有讲，但是这种情况相对来说比较少。
