---
layout: post
title: R - use glmnet for ridge regression - some points
date: 2020-03-25 18:50 -0700
categories: Statistics
tags: [Machine Learning, R]
---

# Webclips
- [How does glmnet's standardize argument handle dummy variables?](https://stackoverflow.com/questions/17887747/how-does-glmnets-standardize-argument-handle-dummy-variables)

Now statistically speaking, one does not generally standardize categorical variables to retain the interpretability of the estimated regressors. However, as pointed out by Tibshirani here, "The lasso method requires initial standardization of the regressors, so that the penalization scheme is fair to all regressors. For categorical regressors, one codes the regressor with dummy variables and then standardizes the dummy variables" - so while this causes arbitrary scaling between continuous and categorical variables, it's done for equal penalization treatment.

- [Can ridge regression be used in the presence of categorical predictors?](https://stats.stackexchange.com/questions/186031/can-ridge-regression-be-used-in-the-presence-of-categorical-predictors)

- [On coding effects in regularized categorical regression](https://www6.inrae.fr/mia-paris/content/download/4230/40438/version/1/file/Chiquet_catreg.pdf)
