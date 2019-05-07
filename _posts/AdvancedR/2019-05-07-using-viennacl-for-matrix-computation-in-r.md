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

## Some Benchmark Results for References

Results:
```
------- CG solver (no preconditioner) using ublas ----------
Exec. time: 6.9826
Est. GFLOPs: 0.012077
Relative residual: 0.0161896
Estimated rel. residual: 0.0161896
Iterations: 100
Relative deviation from result: 0.62264

------- CG solver (no preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 0.468442
Est. GFLOPs: 0.18002
Relative residual: 0.0161927
Estimated rel. residual: 0.0161927
Iterations: 100
Relative deviation from result: 0.622612

------- CG solver (no preconditioner) via ViennaCL, coordinate_matrix ----------
Exec. time: 0.660478
Est. GFLOPs: 0.127678
Relative residual: 0.0161927
Estimated rel. residual: 0.0161927
Iterations: 100
Relative deviation from result: 0.622612

------- CG solver (no preconditioner) via ViennaCL, ell_matrix ----------
Exec. time: 2.11874
Est. GFLOPs: 0.0398014
Relative residual: 0.0161927
Estimated rel. residual: 0.0161927
Iterations: 100
Relative deviation from result: 0.622612

------- CG solver (no preconditioner) via ViennaCL, sliced_ell_matrix ----------
Exec. time: 1.13299
Est. GFLOPs: 0.0744304
Relative residual: 0.0161927
Estimated rel. residual: 0.0161927
Iterations: 100
Relative deviation from result: 0.622612

------- CG solver (no preconditioner) via ViennaCL, hyb_matrix ----------
Exec. time: 1.68694
Est. GFLOPs: 0.0499891
Relative residual: 0.0161927
Estimated rel. residual: 0.0161927
Iterations: 100
Relative deviation from result: 0.622612

------- CG solver (ICHOL0 preconditioner) using ublas ----------
Exec. time: 8.12473
Est. GFLOPs: 0.0103793
Relative residual: 0.00120945
Estimated rel. residual: 0.00107115
Iterations: 100
Relative deviation from result: 0.00614862

------- CG solver (ICHOL0 preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 1.70851
Est. GFLOPs: 0.0493581
Relative residual: 0.00120945
Estimated rel. residual: 0.00107115
Iterations: 100
Relative deviation from result: 0.00614862

------- CG solver (Chow-Patel ICHOL0 preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 2.13223
Est. GFLOPs: 0.0395495
Relative residual: 0.00228402
Estimated rel. residual: 0.00207444
Iterations: 100
Relative deviation from result: 0.0128673

------- CG solver (ILU0 preconditioner) using ublas ----------
Exec. time: 7.04806
Est. GFLOPs: 0.0119648
Relative residual: 0.00120951
Estimated rel. residual: 0.00107117
Iterations: 100
Relative deviation from result: 0.00614765

------- CG solver (ILU0 preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 1.01926
Est. GFLOPs: 0.0827354
Relative residual: 0.00120951
Estimated rel. residual: 0.00107117
Iterations: 100
Relative deviation from result: 0.00614765

------- CG solver (Block-ILU0 preconditioner) using ublas ----------
Exec. time: 7.6122
Est. GFLOPs: 0.0110781
Relative residual: 0.0133717
Estimated rel. residual: 0.0117481
Iterations: 100
Relative deviation from result: 0.524609

------- CG solver (Block-ILU0 preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 0.869006
Est. GFLOPs: 0.0970404
Relative residual: 0.0133731
Estimated rel. residual: 0.0117493
Iterations: 100
Relative deviation from result: 0.524605

------- CG solver (ILUT preconditioner) using ublas ----------
Exec. time: 9.01391
Est. GFLOPs: 0.00935539
Relative residual: 8.03897e-06
Estimated rel. residual: 1.13623e-06
Iterations: 100
Relative deviation from result: 6.69228e-05

------- CG solver (ILUT preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 1.6026
Est. GFLOPs: 0.0526199
Relative residual: 8.03897e-06
Estimated rel. residual: 1.13623e-06
Iterations: 100
Relative deviation from result: 6.69228e-05

------- CG solver (ILUT preconditioner) via ViennaCL, coordinate_matrix ----------
Exec. time: 1.83585
Est. GFLOPs: 0.0459344
Relative residual: 8.04569e-06
Estimated rel. residual: 1.13623e-06
Iterations: 100
Relative deviation from result: 6.69228e-05

------- CG solver (Block-ILUT preconditioner) using ublas ----------
Exec. time: 6.8766
Est. GFLOPs: 0.0122631
Relative residual: 0.013528
Estimated rel. residual: 0.0118599
Iterations: 100
Relative deviation from result: 0.521434

------- CG solver (Block-ILUT preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 1.05033
Est. GFLOPs: 0.0802881
Relative residual: 0.0135289
Estimated rel. residual: 0.0118607
Iterations: 100
Relative deviation from result: 0.521432

------- CG solver (Jacobi preconditioner) using ublas ----------
Exec. time: 6.07676
Est. GFLOPs: 0.0138773
Relative residual: 0.0161892
Estimated rel. residual: 0.0161893
Iterations: 100
Relative deviation from result: 0.622641

------- CG solver (Jacobi preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 0.676198
Est. GFLOPs: 0.12471
Relative residual: 0.0161892
Estimated rel. residual: 0.0161893
Iterations: 100
Relative deviation from result: 0.622641

------- CG solver (Jacobi preconditioner) via ViennaCL, coordinate_matrix ----------
Exec. time: 1.06275
Est. GFLOPs: 0.0793497
Relative residual: 0.0161892
Estimated rel. residual: 0.0161893
Iterations: 100
Relative deviation from result: 0.622641

------- CG solver (Jacobi preconditioner) via ViennaCL, coordinate_matrix ----------
Exec. time: 1.06275
Est. GFLOPs: 0.0793497
Relative residual: 0.0161892
Estimated rel. residual: 0.0161893
Iterations: 100
Relative deviation from result: 0.622641

------- CG solver (row scaling preconditioner) using ublas ----------
Exec. time: 6.04748
Est. GFLOPs: 0.0139444
Relative residual: 0.0163928
Estimated rel. residual: 0.0153166
Iterations: 100

Relative deviation from result: 0.624062
------- CG solver (row scaling preconditioner) via ViennaCL, compressed_matrix ----------
Exec. time: 0.67356
Est. GFLOPs: 0.125198
Relative residual: 0.0163928
Estimated rel. residual: 0.0153166
Iterations: 100
Relative deviation from result: 0.624062

------- CG solver (row scaling preconditioner) via ViennaCL, coordinate_matrix ----------
Exec. time: 1.02963
Est. GFLOPs: 0.0819021
Relative residual: 0.0163928
Estimated rel. residual: 0.0153166
Iterations: 100
Relative deviation from result: 0.624062
```

## References
- [Free open-source GPU-accelerated linear algebra and solver library.](http://viennacl.sourceforge.net/doc/manual-installation.html)
- [Download ViennaCL](http://viennacl.sourceforge.net/viennacl-download.html)
- [Using RViennaCL for matrix multiplication](https://stackoverflow.com/questions/49457018/using-rviennacl-for-matrix-multiplication/)
- [setting library include paths in c++](https://stackoverflow.com/questions/2496950/setting-library-include-paths-in-c)
- [A Performance Comparison of Linear Algebra Libraries for Sparse Matrix-Vector Product](file:///Users/lolofter/Documents/Projects/krylov_ref/spam/475-961-1-SM.pdf)
- [gpuR](https://github.com/cdeterman/gpuR/blob/master/src/solve.cpp)
