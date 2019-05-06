---
layout: post
title: OpenMP R toolchain on Mac OSX Mojave
date: 2019-04-25 10:54 -0600
categories: Tech
tags: [R,openMP]
---

这篇文章旨在提供R-3.5.x版本上C++/fortran/openMP需要的的toolchain。包括
- Command line tools: `xcode-select --install`
- missing header files for Mojave
- gfortran-6.1
- clang6/llvm: for openMP support

### Install Command Line Tools through XCode

In your terminal, type
```
xcode-select --install
```

### Install missing header files for OSX Mojave.
For example, if `mpic++` is not working and saying `wchar.h` is not found, try running the following code in your terminal.

```
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

This command will place the header files in the `/usr/include` directory.

### Install gfortran 6.1
根据[R官网](https://cran.r-project.org/bin/macosx/tools/)上的说明：
> R 3.5.0 El Capitan binaries and higer are using more recent Clang compiler and GNU Fortran 6.1 to provide OpenMP parallelization support and C++17 standard features. If you want to compile R packages from sources, please download GNU Fortran binary from the official GNU Fortran Binaries page - in particular OS X 10.11 gfortran 6.1. Alternatively, we are providing a copy here as well as Clang binaries for OS X 10.11 and higher - see below for the download links. It is not recommended to use clang from Xcode as it is outdated and is lacking important features such as OpenMP support.

#### Delete the prior version of gfortran installed
如果你当前的版本是gfortran 6.1，忽略这节。

##### Older R version: R 3.4.x
```
sudo rm -rf /usr/local/gfortran
sudo rm -rf /usr/local/bin/gfortran

# Remove the gfortran install receipts (run after the above commands)
sudo rm -rf /private/var/db/receipts/com.gnu.gfortran.bom
sudo rm -rf /private/var/db/receipts/com.gnu.gfortran.plist
```

##### Older R version: R 3.0.0 - R 3.3.3
Delete old CRAN compiled gfortran4.8.2 binary.
```
# Download installer into working directory
curl -O http://r.research.att.com/libs/gfortran-4.8.2-darwin13.tar.bz2

# Remove _files_ associated with the binary
for file in $(tar tfz gfortran-4.8.2-darwin13.tar.bz2); do
sudo rm -f /$file;
done

# Remove empty _folders_ associated with the binary
for file in $(tar tfz gfortran-4.8.2-darwin13.tar.bz2); do
sudo rmdir -p /$file;
done

# Delete the installer
rm -rf gfortran-4.8.2-darwin13.tar.bz2
```

##### Install gfortran 6.1
Download at:
```
https://cran.r-project.org/bin/macosx/tools/gfortran-6.1.pkg
```
Download and Install.

##### Check gfortran installation
```
~> gfortran --version
GNU Fortran (GCC) 6.1.0
Copyright (C) 2016 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```


### Option 1: Enable OpenMP support using Non-Apple `llvm`

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

### Option 2: Enable OpenMP support using clang-6 (for R-3.5.x)

##### Step 1: Removing Old Installation Files

###### Delete the clang4 binary
注意除了删除安装文件，我们同样要删除安装receipt。否则即便删除了电脑也不会知道，从而影响其他版本的安装。

R 3.4.x 用的是clang4.为了转换到clang6，首先我们删除clang4.

```
sudo rm -rf /usr/local/clang4

# Remove the install receipts that indicate a package is present
# Remove the clang4 installer receipt
sudo rm -rf /private/var/db/receipts/com.rbinaries.clang4.bom
sudo rm -rf /private/var/db/receipts/com.rbinaries.clang4.plist
```

###### Remove the Makevars file
在R 3.4.x中，我们需要复杂的Makevars设置，从R 3.5.0开始不再需要了。我们只需告诉R我们clang6安装在哪了。
```
sudo rm -rf ~/.R/Makevars
```
In the prior configuration for R 3.4.x, we did a lot of configuration in ~/.R/Makevars. A large majority of this configuration is no longer needed within R 3.5.x. Thus, by removing the old files installed, we can have a “fresh” slate when working on installing the toolchain for R 3.5.x.


##### Step 2: Install toolchain

##### clang6
This package will install clang 6.0.0 for OS X 10.11 (El Capitan) or higher with `OpenMP` support in `/usr/local/clang6`

In order to use this compiler you have to add `/usr/local/clang6/bin` to the `PATH` environment variable such as
 `export PATH=/usr/local/clang6/bin:$PATH`

Download at:
```
https://cran.r-project.org/bin/macosx/tools/clang-6.0.0.pkg
```

```
touch ~/.Renviron
echo 'PATH="/usr/local/clang6/bin:${PATH}"' >> ~/.Renviron
```


#### Step 3: Check Installation

In R:
```
install.packages(c('Rcpp', 'RcppArmadillo'))
```

Save the following code as `helloworld.cpp`.
```
#include <RcppArmadillo.h>   

// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
void hello_world() {
  Rcpp::Rcout << "Hello World!" << std::endl;  
}

// After compile, this function will be immediately called using
// the below snippet and results will be sent to the R console.

/*** R
hello_world()
*/
```

In R:
```
Rcpp::sourceCpp('path/to/file/helloworld.cpp')
```

# References
- [Build R with OpenBLAS and OpenMP support on MacOS 10.14 (Mojave)](https://www.btskinner.me/code/install-r-with-openblas-and-openmp-on-macos-mojave/)
- [Enable OpenMP support in clang in Mac OS X (sierra & Mojave)](https://stackoverflow.com/questions/43555410/enable-openmp-support-in-clang-in-mac-os-x-sierra-mojave)
- [Makevars source file](https://gist.github.com/btskinner/81511cbc878eb08c8abcccef6c30f829)
- [Enable OpenMP support using Apple llvm ](https://iscinumpy.gitlab.io/post/omp-on-high-sierra/)
- [R Compiler Tools for Rcpp on macOS](http://thecoatlessprofessor.com/programming/r-compiler-tools-for-rcpp-on-macos/)
- [Binaries available for gfortran](https://gcc.gnu.org/wiki/GFortranBinaries#MacOS)
- [gfortran installer for Mac OS X](https://github.com/fxcoudert/gfortran-for-macOS/releases)
- [How to uninstall gfortran on MacOS Sierra?](https://stackoverflow.com/questions/44931195/how-to-uninstall-gfortran-on-macos-sierra)
