---
layout: post
title: OpenMP R C++ Integration on Mac Mojave
date: 2019-05-04 12:40 -0600
categories: Tech
tags: [R]
---

## Safe Multithreading using Rcpp
This section is trying to protect your users!
> By default, the macOS operating environment lacks the ability to parallelize sections of code using the
[OpenMP](http://openmp.org/wp/) standard. Within R 3.4.\*, the default developer environment was changed to allow for OpenMP to be used on macOS by using a non-default toolchain provided by R Core Team maintainers for macOS. Having said this, it is still important to protect any reference to OpenMP as some users may
not yet have the ability to use OpenMP.

MacOS自身的clang支持openMP的语法不一样，需要很多特别的操作。一种解决办法是用非Apple自带的`llvm`。详情见[Enable OpenMP support in clang in Mac OSX Mojave](https://ylyy93.github.io/my_blog/tech/2019/04/25/r-cpp-compile-notes/)。

关于R版本>=3.4.0的一些更新说明：
1. R binary for macOS is compiled using a compiler and gfortran libraries that are not included with Xcode.
2. This version do provide support for OpenMP

Two-fold process:

- Step 1. protect the inclusion of headers with
```
#ifdef _OPENMP
#include <omp.h>
#endif
```

- Step 2: using multithreaded OpenMP version v.s. single-threaded version of code
```
#ifdef _OPENMP
// multithreaded OpenMP version of code
#else
// single-threaded version of code
#endif
```

Under this approach, the code will be safely parallelized when
support exists for OpenMP on Windows, macOS, and Linux.

## R packages using openMP in R

#### Flags (`-I`)

|   Flags        |   Compilers  |
|----------------|-----|
| `PKG_CFLAGS`   | C  |
| `PKG_CXXFLAGS` | C++|
| `PKG_FFLAGS`   | FORTRAN 77|
| `PKG_FCFLAGS`  | Fortran 9x|
| `PKG_OBJCFLAGS`| Objective C|

#### LIBS `PKG_LIBS` (`-L`)
Supplying linker commands as arguments to R CMD SHLIB will take precedence over PKG_LIBS in `Makevars`.
`R CMD SHLIB` 中的arguments有更高的优先级。

Flags which are already set (for example in file `etcR_ARCH/Makeconf`) can be overridden by the environment variable MAKEFLAGS (at least for systems using a POSIX-compliant make), as in (Bourne shell syntax)
```
MAKEFLAGS="CFLAGS=-O3" R CMD SHLIB *.c
```

It is also possible to set such variables in personal `Makevars` files, which are read after the local `Makevars` and the system makefiles or in a site-wide `Makevars.site` file.

If the `src` subdirectory of an add-on package contains source code with one of the extensions listed above or a file `Makevars` but not a file Makefile, R CMD INSTALL creates a shared object (for loading into R through useDynlib() in the `NAMESPACE`, or in the .onLoad function of the package) using the R CMD SHLIB mechanism. If file `Makevars` exists it is read first, then the system makefile and then any personal `Makevars` files.

If the `src` subdirectory of package contains a file `Makefile`, this is used by R CMD INSTALL in place of the R CMD SHLIB mechanism. make is called with makefiles `R_HOME/etcR_ARCH/Makeconf`, `src/Makefile` and any personal `Makevars` files (in that order). The first target found in `src/Makefile` is used.

It is better to make use of a Makevars file rather than a Makefile: the latter should be needed only exceptionally.

### `GPvecchia`

```
PKG_CFLAGS = $(SHLIB_OPENMP_CFLAGS)
PKG_LIBS = $(SHLIB_OPENMP_CFLAGS)
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS)
PKG_LIBS = $(SHLIB_OPENMP_CFLAGS) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)
```

### `spNNGP`

程序用cpp写的，支持openMP。C程序中调用了LAPACK，BLAS，F77。

```
PKG_LIBS = $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS) $(SHLIB_OPENMP_CXXFLAGS)
PKG_CXXFLAGS = $(SHLIB_OPENMP_CXXFLAGS)
```

### `bdmiso`

程序用c写的，支持openMP。

```
#PKG_CFLAGS=$(SHLIB_OPENMP_CFLAGS) -I/usr/local/Cellar/libiomp/20150701/include/libiomp/
PKG_CFLAGS=$(SHLIB_OPENMP_CFLAGS)
PKG_LIBS=$(SHLIB_OPENMP_CFLAGS)
```

### To use Rcpp and openMP
如果在程序中引用了`Rcpp.h`头函数，然后想用`R CMD SHLIB`来产生`.so`文件，可以修改在cpp文件所在文件夹下创建Makevars如下。加上`$(SHLIB_OPENMP_CXXFLAGS)`可以enable openMP。
```
PKG_CXXFLAGS=`Rscript -e 'Rcpp:::CxxFlags()'` $(SHLIB_OPENMP_CXXFLAGS)
PKG_LIBS=`Rscript -e 'Rcpp:::LdFlags()'` $(SHLIB_OPENMP_CXXFLAGS)
```

或者，直接在Terminal运行：
```
PKG_CXXFLAGS="$(echo 'Rcpp:::CxxFlags()'| R --vanilla --slave) -fopenmp" R CMD SHLIB loglikMP.cpp
```

### Check if openMP is correctly set up in R:
- [Notebook](http://blue.for.msu.edu/envr18/exercises/exercise-1a/exercise_1a.html)



# References

- [Rcpp-FAQ](https://cran.r-project.org/web/packages/Rcpp/vignettes/Rcpp-FAQ.pdf)
- [5.5 Creating shared objects](http://www.hep.by/gnu/r-patched/r-exts/R-exts_96.html)
- [OpenMP in R on OS X](http://thecoatlessprofessor.com/programming/openmp-in-r-on-os-x/#after-3-4-0)
- [R and openMP: boosting compiled code on multi-core cpu-s](http://www.parallelr.com/r-and-openmp-boosting-compiled-code-on-multi-core-cpu-s/)
- [How to resolve include Rcpp.h problems?](http://r.789695.n4.nabble.com/How-to-resolve-include-Rcpp-h-problems-td962875.html)
