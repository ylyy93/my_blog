---
layout: post
title: Boost on Mac (using Clang)
date: 2019-05-07 11:16 -0600
categories: Tech
tags: [c++]
---

Since both brew and macports do not seem to work well, we will build Boost library from source.
gcc 8 seems to be more complicated, so we stick to clang.

1. Download Boost from [here](https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.bz2) and unzip it.

Install:
```
cd /path/to/boost_1_70_0/
./bootstrap.sh --prefix=/usr/local/boost-1.70.0
sudo ./b2 cxxflags=-std=c++17 install
```

Set path:

```
export DYLD_LIBRARY_PATH=/usr/local/boost-1.70.0/lib:$DYLD_LIBRARY_PATH
```
Or save the above line in `~/.zshrc` for changing the path permanently.

# Test

Save the following c++ code in `test.cpp`.
```
#include <iostream>
#include <boost/filesystem.hpp>

int main()
{
	// Get the current directory
	auto path = boost::filesystem::current_path();
	std::cout << path << "\n";

	// Print the content of the current directory
	for(auto &entry : boost::filesystem::directory_iterator(path))
	{
		std::cout << entry << std::endl;
	}

	return 0;
}
```

In terminal:
```
clang++ -std=c++17 -I /usr/local/boost-1.70.0/include -L /usr/local/boost-1.70.0/lib test.cpp -o test -lboost_system -lboost_filesystem
./test
```

# Use boost in R
Save the following script as `simpleBoost.cpp`:
```
#include <Rcpp.h>
#include <boost/math/common_factor.hpp>  // included in BH  

// [[Rcpp::depends(BH)]]    

using namespace Rcpp;

// [[Rcpp::export]]   
int computeGCD(int a, int b) {
  return boost::math::gcd(a, b);
}
```

In R:
```
R> library(Rcpp)
R> sourceCpp("/path/to/simpleBoost.cpp")
R> computeGCD(6, 15)
[1] 3
```

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

# References
- [Getting Started with Boost on Mac OSX](https://blog.koalatea.io/2018/01/03/getting-started-with-boost-on-mac-osx/)
- [Compiling Boost with GCC or Clang on macOS](https://solarianprogrammer.com/2018/08/07/compiling-boost-gcc-clang-macos/)
- [How to use Boost library in C++ with Rcpp](https://stackoverflow.com/questions/16131462/how-to-use-boost-library-in-c-with-rcpp)
