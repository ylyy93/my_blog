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



# References
- [Getting Started with Boost on Mac OSX](https://blog.koalatea.io/2018/01/03/getting-started-with-boost-on-mac-osx/)
- [Compiling Boost with GCC or Clang on macOS](https://solarianprogrammer.com/2018/08/07/compiling-boost-gcc-clang-macos/)
- [How to use Boost library in C++ with Rcpp](https://stackoverflow.com/questions/16131462/how-to-use-boost-library-in-c-with-rcpp)
