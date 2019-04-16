---
layout: post
title: Methods for Analyzing Large Spatial Data
date: 2019-04-16 09:49 -0600
categories: Research
tags: [spatial]
---

# Gaussian Process (GP)

$
Y(s),~~~s\in\mathcal{D}\subset \mathbb{R}^2
$
is said to follow a GP if any realization
$
Y = (Y(s_1),\ldots,Y(s_N))
$
at the finite number of locations
$
s_1,\ldots,s_N
$
follows an N-variate Gaussian distribution.

If $Y(s)$ follows a spatial Gaussian process, $Y$ has the density function,

$$
f_Y(y) = \left(\frac{1}{\sqrt{2\pi}}\right)^N|\Sigma|^{-1/2}\exp\left\{-\frac{1}{2}(y-\mu)^{\top}\Sigma^{-1}(y-\mu)\right\}
$$

## Methods for Large Spatial Datasets

1.Conditional distributions.
- [Vecchia, A. V. (1988), “Estimation and model identification for continuous spatial processes,” Journal of the Royal
Statistical Society. Series B (Methodological), 297–312.](https://www.jstor.org/stable/pdf/2345768.pdf?refreqid=excelsior%3Af5f2590b67317e44f5f3eb1596e49860)
- [Stein, M. L., Chi, Z., and Welty, L. J. (2004), “Approximating likelihoods for large spatial data sets,” Journal of the Royal Statistical Society: Series B (Statistical Methodology), 66, 275–296.](https://pdfs.semanticscholar.org/9e41/c6830b6ade32885c442eb273ef970e85997d.pdf)

2.Pseudo-likelihoods
- [Varin, C., Reid, N., and Firth, D. (2011), “An overview of composite likelihood methods,” Statistica Sinica, 5–42.](http://www3.stat.sinica.edu.tw/sstest/oldpdf/A21n11.pdf)
- [Eidsvik, J., Shaby, B. A., Reich, B. J., Wheeler, M., and Niemi, J. (2014), “Estimation and prediction in spatial models with block composite likelihoods,” Journal of Computational and Graphical Statistics, 23, 295–315.](https://www4.stat.ncsu.edu/~reich/pubs/Composite.pdf)

3.Spectral methods
- [Fuentes, M. (2007), “Approximate likelihood for large irregularly spaced spatial data,” Journal of the American
Statistical Association, 102, 321–331.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2601654/pdf/nihms75906.pdf)

4.Tapered covariance functions
- [Furrer, R., Genton, M. G., and Nychka, D. (2006), “Covariance tapering for interpolation of large spatial datasets,”
Journal of Computational and Graphical Statistics, 15, 502–523.](https://stsda.kaust.edu.sa/Documents/2006.FGN.JCGS.pdf)
- [Kaufman, C. G., Schervish, M. J., and Nychka, D. W. (2008), “Covariance tapering for likelihood-based estimation
in large spatial data sets,” Journal of the American Statistical Association, 103, 1545–1555.](https://amstat.tandfonline.com/doi/pdf/10.1198/016214508000000959?needAccess=true)
- [Stein (2013), “Statistical properties of covariance tapers,” Journal of Computational and Graphical Statistics, 22,
866–885.](http://www.stat.tamu.edu/~mjun/paper/Stein_JCGS13.pdf)

5.Low rank (Problem: oversmoothing, limit of size of dataset)
  - discrete process convolution
    - [Higdon, D. (2002), “Space and space-time modeling using process convolutions,” in Quantitative methods for current environmental issues, Springer, pp. 37–56.](https://pdfs.semanticscholar.org/6309/21bec30214d3850bc8ef885b17dce78f35b4.pdf)
    - [Lemos, R. T. and Sansó, B. (2009), “A spatio-temporal model for mean, anomaly, and trend fields of North Atlantic
    sea surface temperature,” Journal of the American Statistical Association, 104, 5–18.](https://www.jstor.org/stable/pdf/40591896.pdf?refreqid=excelsior%3Ae3cdb537f98498e6bdcd86f4f1155b60)
  - Fixed rank kriging
    - [Cressie, N. and Johannesson, G. (2008), “Fixed rank kriging for very large spatial data sets,” Journal of the Royal Statistical Society: Series B (Statistical Methodology), 70, 209–226.](http://www.stat.ucla.edu/~nchristo/statistics_c173_c273/cressie_FRK.pdf)
    - [Kang, E. L. and Cressie, N. (2011), “Bayesian inference for the spatial random effects model,” Journal of the American Statistical Association, 106, 972–983.](https://www.tandfonline.com/doi/pdf/10.1198/jasa.2011.tm09680?casa_token=l0aTkcxaoPkAAAAA:wt4Zi4efZdZejBqT8cW79PQG9gi6dh_8vWFemMx_2DQjIXfp_uxxpCMO-ErLOvzx8pC4jY3OCJSX)
    - [Katzfuss, M. and Cressie, N. (2011), “Spatio-temporal smoothing and EM estimation for massive remote-sensing data sets,” Journal of Time Series Analysis, 32, 430–446.](https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1467-9892.2011.00732.x)
  - Predictive processes
    - [Banerjee, S., Gelfand, A. E., Finley, A. O., and Sang, H. (2008), “Gaussian predictive process models for large spatial data sets,” Journal of the Royal Statistical Society: Series B (Statistical Methodology), 70, 825–848.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2741335/pdf/nihms127612.pdf)
    - [Finley, A. O., Sang, H., Banerjee, S., and Gelfand, A. E. (2009), “Improving the performance of predictive process modeling for large datasets,” Computational statistics & data analysis, 53, 2873–2884.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2743161/pdf/nihms128321.pdf)
  - Lattice kriging
    - [Nychka, D., Bandyopadhyay, S., Hammerling, D., Lindgren, F., and Sain, S. (2015), “A multiresolution Gaussian process model for the analysis of large spatial datasets,” Journal of Computational and Graphical Statistics, 24, 579–599.](https://jrfaulkner.github.io/files/LatticeKrigPres.pdf)
  - Spatial PDE
    - [Lindgren, F., Rue, H., and Lindström, J. (2011), “An explicit link between Gaussian fields and Gaussian Markov random fields: the stochastic partial differential equation approach,” Journal of the Royal Statistical Society:Series B (Statistical Methodology), 73, 423–498.](https://rss.onlinelibrary.wiley.com/doi/epdf/10.1111/j.1467-9868.2011.00777.x)

6.Parallelizable methods
- Direct Method
  - [Paciorek, C. J., Lipshitz, B., Zhuo, W., Kaufman, C. G., Thomas, R. C., et al. (2015), “Parallelizing Gaussian Process Calculations In R,” Journal of Statistical Software, 63, 1–23.](https://www.stat.berkeley.edu/~cgk/papers/assets/paciorek2013.pdf)
- Basis function based method
  - [Katzfuss, M. (2017), “A multi-resolution approximation for massive spatial datasets,” Journal of the American Statistical Association, 112, 201–214.](https://arxiv.org/pdf/1507.04789.pdf)
  - [Katzfuss, M. and Hammerling, D. (2017), “Parallel inference for massive distributed spatial data using low-rank models,” Statistics and Computing, 27, 363–375.](https://arxiv.org/pdf/1402.1472.pdf)
- Divide and conquer
  - [Barbian, M. H. and Assunção, R. M. (2017), “Spatial subsemble estimator for large geostatistical data,” Spatial Statistics, 22, 68–88.](https://www.sciencedirect.com/science/article/pii/S2211675316300999)
  - [Guhaniyogi, R. and Banerjee, S. (2018), “Meta-kriging: Scalable Bayesian modeling and inference for massive spatial datasets,” Technometrics.](https://www.tandfonline.com/doi/pdf/10.1080/00401706.2018.1437474?needAccess=true)
- Conditional distributions
  - [Datta, A., Banerjee, S., Finley, A. O., and Gelfand, A. E. (2016a), “Hierarchical nearest-neighbor Gaussian process models for large geostatistical datasets,” Journal of the American Statistical Association, 111, 800–812.](https://amstat.tandfonline.com/doi/pdf/10.1080/01621459.2015.1044091?needAccess=true)
  - [Datta, A., Banerjee, S., Finley, A. O., Hamm, N. A., Schaap, M., et al. (2016c), “Nonseparable dynamic nearest neighbor Gaussian process models for large spatio-temporal data with an application to particulate matter analysis,” The Annals of Applied Statistics, 10, 1286–1316.](https://arxiv.org/pdf/1510.07130.pdf)
