---
layout: post
title: sparse matrix manipulation in R
date: 2019-05-06 16:12 -0600
categories: Tech
tags: [R]
---

## `spam` Features
- FORTRAN routines. (SPARSKIT)
- faster Cholesky decomposition.
- Fortran does not feature dynamic memory allocation.

## Non-zero elements storage: "old Yale sparse format"

###### CSR (compressed sparse row) format
Suppose we have $z$ nonzero values in the matrix.

Use four vectors:
1. nonzero values row by row. (z)
2. ordered column indices of  nonzero values. (z)
3. the position in the previous two vectors corresponding to new rows.  (n+1)
4. the column dimension of the matrix. (2)

## Methods in `spam`
- `plot`
- `dim`
- `backsolve/forwardsolve`
- `determinant`

### Covariance matrix 的构建

上限：delta，用在距离
下限：eps，用在cov

```
options(spam.nearestdistnnz=c(63210027, 400))
xobs <- train[,1:2]
delta <- 0.2 # 	only distances smaller than delta are recorded.
hobs <- nearest.dist( xobs, miles=FALSE,upper=NULL, delta=delta) # Euclidean distances
Cobsobs <- cov.exp( hobs, theta=c( res$par[1:3])) * cov.wend1( hobs, theta=c( delta,1,0))
cholCobsobs <- chol( Cobsobs, memory=list(nnzR=379374314))

options(spam.nearestdistnnz=c(22072781, 400))
hpredobs <- nearest.dist( xpred, xobs, miles=FALSE, delta=delta)
Cpredobs <-  cov.exp( hpredobs, theta=c( res$par[1:3])) * cov.wend1( hpredobs, theta=c( delta,1,0))
Ypred <- c( Cpredobs %*% solve.spam( cholCobsobs, drift$resid) +  mupred[ isNA])

```


# References
- [spam: A Sparse Matrix R Package with Emphasis on MCMC Methods for Gaussian Markov Random Fields](https://www.jstatsoft.org/article/view/v036i10)
- [Illustrations and Examples](https://www.math.uzh.ch/pages/spam/articles/spam.html)
- [A Sparse Matrix Library in C++ for High Performance Architectures](http://www.netlib.org/lapack/lawnspdf/lawn74.pdf)
- [SparseLib++](https://math.nist.gov/sparselib++/)
