---
layout: post
title: 'RandomFields: Compactly Supported Covariances'
date: 2019-05-19 20:35 -0600
categories: Research
tags: [spatial]
---


## `RMgengneiting`
In the documentation of `RandomFields`, they stated that, for $\kappa=1$ the Gneiting model is given by
$$
C(r) = (1+\beta r)(1-r)^{\beta}1_{[0,1]}(4), ~~~ \beta = \mu + 2\kappa + 1/2.
$$

###### `wendland1`:

$$
\left(1-\frac{h}{\theta}\right)^4_+\left(1+4\frac{h}{\theta}\right)
$$

```
library(RandomFields)
plot(RMgengneiting(kappa=1, mu=1.5),type=c("l"), pch=20)
x = seq(0,1,length=100)
y = cov.wend1(x,theta=1)
lines(x,y,col="green")
```

###### `wendland2`:

# References
- [RMgengneiting](https://www.rdocumentation.org/packages/RandomFields/versions/3.1.36/topics/RMgengneiting)
- [Covariance Tapering for Interpolation of Large Spatial Datasets](https://stsda.kaust.edu.sa/Documents/2006.FGN.JCGS.pdf)
