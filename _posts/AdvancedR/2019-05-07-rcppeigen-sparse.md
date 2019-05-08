---
layout: post
title: RcppEigen Sparse
date: 2019-05-07 20:41 -0600
categories: Tech
tags: [R]
---

```
// [[Rcpp::depends(RcppEigen)]]
#include <RcppEigen.h>
#include <Eigen/SparseLU>

using namespace Eigen;

// [[Rcpp::export]]
MatrixXd SparseSolve(const SparseMatrix<double>& A, const MatrixXd& b) {
  SparseLU<SparseMatrix<double> > solver;
  solver.compute(A);
  if(solver.info()!=Success) {
    Rcpp::stop("decomposition failed");
  }
  MatrixXd x = solver.solve(b);
  if(solver.info()!=Success) {
    Rcpp::stop("solving failed");
  }
  return x;
}

/*** R
set.seed(42)
n <- 10000
A <- Matrix::rsparsematrix(n, n, density = 0.2)
b <- matrix(rnorm(n), nrow = n, ncol = 1)
system.time(f <- SparseSolve(A,b))
f[1:4]
*/
```

## Suppress Warnings

creating the file `~/.R/Makevars` and adding
```
CXXFLAGS+=-Wno-ignored-attributes
CXX11FLAGS+=-Wno-ignored-attributes
CXX14FLAGS+=-Wno-ignored-attributes
```


# References
- [RcppEigen LLT resulted in a vector of NaN](https://stackoverflow.com/questions/51832832/rcppeigen-llt-resulted-in-a-vector-of-nan)
- [](https://stackoverflow.com/questions/50544379/warning-in-rcppnumerical-and-rcppeigen-on-ubuntu-18-04)
