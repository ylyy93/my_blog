---
layout: post
title: locally stationary spatial process
date: 2019-04-01 20:09 -0600
categories: Research
tags: [spatial, reading notes]
---
## Paper: [On a Time Deformation Reducing Nonstationary Stochastic Processes to Local Stationarity][@genton2004]

Summary: A stochastic process is locally stationary if its covariance function can be expressed as the product of a positive function multiplied by a stationary covariance.

**[Notes 1:]**
Notice that local stationarity is a general concept for which different definitions exist. Berman (1974) defined it in terms of Hölder conditions. [Priestley (1965)][@Priestley1965], and further [Dahlhaus (1997)][@Dahlhaus1997], considered a process with continuously time-changing spectral representation. Recently, a different and less restrictive notion of local stationarity has been introduced by means of orthogonal wavelets (see e.g. [Mallat et al. (1998)][@mallat1998]). However, we restrict ourselves to the definition of [Silverman (1957)][@Silverman1957], which is more tractable in the context of continuous-time deformation. With additional smoothness assumptions on R1 and R2, Silverman’s definition of local stationarity can be viewed as a particular case of the later versions.

1. For regularly timed data, locally stationary process was introduced by [Priestley (1965)][@Priestley1965] and developed by [Dahlhaus (1997)][@Dahlhaus1997], following by its descendant in the field of time series, such as [Vogt (2012)][@vogt2012].
2. For continuous time
2. For regularly spaced data,
### Sampson and Guttorp (1992)'s Nonstationary Covariance Function

$$
\rho(x,y) = R(f(x)- f(y)),
$$

where R is a stationary covariance function.

### Locally stationary (LS) processes
- First introduced by [Silverman (1957)][@Silverman1957]

$$
c(x,y) = R_1(\frac{x+y}{2})R_2(x-y),
$$

where $R_2$ is a stationary covariance function and $R_1$ is nonnegative.

- The variable (x + y)/2 has been chosen because of its suggestive meaning of the average or centroid of the time points x and y.
- Indeed, when $R_1$ is smooth enough, $c(x,y) \approx R_2(x-y)$ when $y\in [x-\varepsilon_x/2,x+\varepsilon_x/2]$ for $\varepsilon_x$ small enough.
- Stationarity as a special case (consider $R_1$ as a positive constant).

### Pseudo-locally stationary (PLS).
- when $R_2$ is not a stationary covariance function.

### Locally stationary reducible (LSR) processes.

$$
Z(x) = Y(g(x)),
$$
where $Y$ is an LS process.

$$
r(x,y) = R_1(\frac{g(x)+g(y)}{2}) R_2(g(x)-g(y)),
$$
where $R_1$ is a nonnegative function and $R_2$ is a stationary covariance function.



[@Silverman1957]: https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=1057413 "Locally Stationary Random Processes"

[@genton2004]: https://www.jstor.org/stable/pdf/3215828.pdf?refreqid=excelsior%3Aa1f0143c0f4160cd59d4a6d146ebb7f7 "On a Time Deformation Reducing Nonstationary Stochastic Processes to Local Stationarity"

[@Priestley1965]: https://www.jstor.org/stable/pdf/2984191.pdf?refreqid=excelsior%3Afcb1ea950684d83f9726b8023e0765e9 "Evolutionary Spectra and Non-Stationary Processes"

[@Dahlhaus1997]: https://projecteuclid.org/download/pdf_1/euclid.aos/1034276620 "Fitting time series models to nonstationary processes"

[@vogt2012]: https://projecteuclid.org/download/pdfview_1/euclid.aos/1359987532 "Nonparametric regression for locally stationary time series"

[@mallat1998]: https://projecteuclid.org/download/pdf_1/euclid.aos/1030563977 "Adaptive covariance estimation of locally stationary processes"
