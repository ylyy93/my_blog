---
layout: post
title: 'Using Viennacl for Matrix Computation in R '
date: 2019-05-07 15:49 -0600
categories: Tech
tags: [R]
---
According to a performance comparison paper [here](file:///Users/lolofter/Documents/Projects/krylov_ref/spam/475-961-1-SM.pdf), Viennacl is even more efficient than mkl for sparse matrix calculations.


## Install Viennacl on MacOS

Prerequisites:
1. CMake
2. Boost
3. optional: Eigen, Armadillo, OpenMP, MTL 4,

I already have Cmake installed. The installation guide for Boost can be found in my [post](https://ylyy93.github.io/my_blog/tech/2019/05/07/boost-on-mac/).

## Install Viennacl

Since ViennaCL is a header-only library, it is sufficient to copy the folder `viennacl/` to `/usr/local/include/viennacl`.

Download latest [ViennaCl](http://sourceforge.net/projects/viennacl/files/1.7.x/ViennaCL-1.7.1.tar.gz/download).

In terminal:
```
sudo cp -r /path/to/folder/viennacl/ /usr/local/include/viennacl/
```

## An Example

Save the following script to `mm_viennacl.cpp`:

```
#define VIENNACL_HAVE_EIGEN
#include <RcppEigen.h>
#include <viennacl/ocl/backend.hpp>
#include <viennacl/matrix.hpp>


//' viennacl matrix crossprod
//'
//' @export
// [[Rcpp::export]]
Eigen::MatrixXd vclCrossprod(const Eigen::MatrixXd &in_densematrix){
  int rows = in_densematrix.rows();
  int cols = in_densematrix.cols();

  viennacl::matrix<double>  viennacl_densematrix(rows, cols);
  viennacl::copy(in_densematrix,  viennacl_densematrix);
  viennacl::matrix<double> viennacl_result = viennacl::linalg::prod(
    viennacl::trans(viennacl_densematrix),
    viennacl_densematrix);

  Eigen::MatrixXd eigen_result(cols, cols);
  viennacl::copy(viennacl_result,  eigen_result);
  return eigen_result;
}
```
In R:
```
R>library(Rcpp)
R>sourceCpp("/path/to/mm_viennacl.cpp")
R>n = 1000
R>A = matrix(rnorm(n^2),n,n)
R>system.time(vcl_result <- vclCrossprod(A))
R>system.time(result <- crossprod(A))
```

## References
- [Free open-source GPU-accelerated linear algebra and solver library.](http://viennacl.sourceforge.net/doc/manual-installation.html)
- [Download ViennaCL](http://viennacl.sourceforge.net/viennacl-download.html)
- [Using RViennaCL for matrix multiplication](https://stackoverflow.com/questions/49457018/using-rviennacl-for-matrix-multiplication/)
- [setting library include paths in c++](https://stackoverflow.com/questions/2496950/setting-library-include-paths-in-c)
- [A Performance Comparison of Linear Algebra Libraries for Sparse Matrix-Vector Product](file:///Users/lolofter/Documents/Projects/krylov_ref/spam/475-961-1-SM.pdf)
