---
layout: post
title: LAPACK Fortran Routines
date: 2019-05-02 12:19 -0600
categories: Tech
tags: [R]
---

### `daxpy`

$$
y := \alpha x + y
$$
```
int inc = 1;
int dim = n;
F77_NAME(daxpy)(&dim,   \\ size of x,y
                &alpha, \\ int alpha;
                x,      \\ double *x; (dim 1+(N-1)*abs(incx))
                &inc,   \\ increment integer (x)
                y,      \\ double *y; (dim 1+(N-1)*abs(incy))
                &inc    \\ increment integer (y)
                )
```

### `dtrmv`
Triangular Matrix-vector multiplication:
$$
x := Ax
$$
Or
$$
x := A^{\top}x
$$


```
int dim = n;
double *A;
double *x;
int inc = 1;

F77_NAME(dtrmv)("L",  \\ "U","u" (Upper triangular A) "L","l" (Lower triangular A)
                "N",  \\ "N","n" (Ax), "T","t","C","c" (A'x)
                "N",  \\ "N","n" (not unit triangular), "U","u" (unit triangular)
                &dim, \\ ncol of A (>=0)
                A,    \\ matrix of dimension (LDA, N)
                &dim, \\ nrow of A (>=max(1,n))
                x,    \\ vector (dim >= 1 + (n-1)*INCX)
                &inc);\\ increment for elements of x, (!= 0)
```
这个例子是一个下三角矩阵`A`与`x`相乘。

### `dpotrf`

Cholesky分解。A是一个实对称正定矩阵。

$$
A = U^{\top}U
$$
Or

$$
A = LL^{\top}
$$
```
char lower = 'L';
int dim = n;
double *A;
int info = 0;

F77_NAME(dpotrf)(&lower,  \\ Upper ("U","u"), Lower ("L","l")
                 &dim,    \\ order of A
                 A,       \\ double precision array
                 &dim,    \\ leading dimension of A
                 &info    \\ =0: success; <0(-i): ith argument invalid; >0(i): the leading minor of order i is not positive definite
                 )
```

### `dpotri`

基于Chol求实对称正定矩阵A的逆。假如A的cholesky分解如下：
$$
A = U^{\top}U
$$
Or
$$
A = LL^{\top}
$$

后面的arguments跟上面`dpotrf`一致，直接复制粘贴改掉函数名即可。
```
F77_NAME(dpotri)(&lower,  \\ Upper ("U","u"), Lower ("L","l")
                 &dim,    \\ order of A
                 A,       \\ double precision array
                 &dim,    \\ leading dimension of A
                 &info    \\ =0: success; <0(-i): ith argument invalid; >0(i): the leading minor of order i is not positive definite
                 )
```

### `dsymv`
$$
y := \alpha Ax + \beta y
$$

```
F77_NAME(dsymv)(&lower,  \\ Upper ("U","u"), Lower ("L","l")
                &dim,    \\ order of A
                &alpha,  \\ alpha
                A,       \\ double precision array
                &dim,    \\ leading dimension of A
                x,       \\ double *x;
                &inc,    \\ increment for x
                &beta,   \\ beta
                y,       \\ double *y;
                &inc,    \\ increment for y
                )
```
