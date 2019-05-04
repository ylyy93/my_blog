---
layout: post
title: Enable OpenMP support in clang in Mac OSX Mojave
date: 2019-04-25 10:54 -0600
categories: Tech
tags: [R,openMP]
---

### Install Command Line Tools through XCode
```
xcode-select --install
```

### Install missing header files for OSX Mojave.
For example, if `mpic++` is not working and saying `wchar.h` is not found, try running the following code in your terminal.

```
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

This command will place the header files in the `/usr/include` directory.

### Enable OpenMP support using Non-Apple `llvm`

#### Using Homebrew's `llvm`:
```
brew install llvm
```

Check if `openMP` is appropriately installed
```
curl -O https://computing.llnl.gov/tutorials/openMP/samples/C/omp_hello.c
/usr/local/opt/llvm/bin/clang -fopenmp -L/usr/local/opt/llvm/lib omp_hello.c -o hello
./hello
```

This chunk would output like
```
Hello World from thread = 0
Number of threads = 4
Hello World from thread = 2
Hello World from thread = 3
Hello World from thread = 1
```

The `make` file would look like this
```
CPP = /usr/local/opt/llvm/bin/clang
CPPFLAGS = -I/usr/local/opt/llvm/include -fopenmp
LDFLAGS = -L/usr/local/opt/llvm/lib

omp_hello: omp_hello.c
    $(CPP) $(CPPFLAGS) $^ -o $@ $(LDFLAGS)
```

**[Note:]**
The Apple `llvm` also support `openMP`, but they require their unique flags (not convenient).

```{R}
> Rcpp::sourceCpp('GPvecchia/src/U_NZentries.cpp')
ld: warning: directory not found for option '-L/usr/local/gfortran/lib/gcc/x86_64-apple-darwin15/6.1.0'
```



# References
- [Build R with OpenBLAS and OpenMP support on MacOS 10.14 (Mojave)](https://www.btskinner.me/code/install-r-with-openblas-and-openmp-on-macos-mojave/)
- [Enable OpenMP support in clang in Mac OS X (sierra & Mojave)](https://stackoverflow.com/questions/43555410/enable-openmp-support-in-clang-in-mac-os-x-sierra-mojave)
- [Makevars source file](https://gist.github.com/btskinner/81511cbc878eb08c8abcccef6c30f829)
- [Enable OpenMP support using Apple llvm ](https://iscinumpy.gitlab.io/post/omp-on-high-sierra/)
