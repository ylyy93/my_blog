---
layout: post
title: 'Rcpp Extending: using libraries'' own classes'
date: 2019-05-08 10:40 -0600
categories: Tech
tags: [R]
---

# Basic Operations

- Conversion from R to C++: `Rcpp::as`
- Conversion from C++ to R: `Rcpp::wrap`

Syntax:
```
// conversion from R to C++
template <typename T> T as(SEXP x);
// conversion from C++ to R
template <typename T> SEXP wrap(const T& object);
```

Instances: Save the following script as `list_to_list.cpp`.
```
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
List fx(List input){
  // we get a list from R
  // pull std::vector<double> from R list
  // this is achieved through an implicit
  // call to Rcpp::as

std::vector<double> x = input["x"];
// return an R list; this is achieved
// through an implicit call to Rcpp::wrap
return List::create(_["front"] = x.front(),
                    _["back"] = x.back());  
}
```

In R:
```
library(Rcpp)
Rcpp::sourceCpp(file= "/path/to/list_to_list.cpp")
input <- list(x=seq(1,10,by=0.5))
fx(input)
# $front
# [1] 1
#
# $back
# [1] 10
```

## Extending `Rcpp::wrap`: from `C++` to `R`
1. 从`RcppCommon.h`开始，以`Rcpp.h`结束。
2. intrusive, 定义了一个`Foo` class, Foo(c class)-> SEXP, 不需要知道c class 具体是啥。
3. non-intrusive, 需要引用定义c class `const Bar&`的头文件，要用Rcpp namespace， `template <> SEXP wrap(const Bar&)`
4. partial, 需要引用定义c class `const Bar&`的头文件，要用`Rcpp::traits` namespace，`template <typename T>
SEXP wrap(const Bling<T>&);`. 跟3比，class `const Bling<T>&` 可以应用于不同类型`<T>`.
5. 或者可以用Macro，不需要以`Rcpp.h`结束， 但需要引用定义c class `const Bar&`的头文件，具体函数为`RCPP_EXPOSED_WRAP(Bar)`.


###  Intrusive extension
在这个class中我们声明了怎么转换成`SEXP`.

```
#include <RcppCommon.h>
class Foo{
  public:
    Foo();
  // this operator enables implicit Rcpp::wrap
  operator SEXP();
}

#include <Rcpp.h>
```

###  Non-intrusive extension

```
#include <RcppCommon.h>

// third party library that declares class Bar
#include <foobar.h>

// declaring the specialization
namespace Rcpp {
template <> SEXP wrap(const Bar&);
}

// this must appear after the specialization,
// otherwise the specialization will not be
// seen by Rcpp types
#include <Rcpp.h>
```
It should be noted that only the declaration is required. The
implementation can appear after the `Rcpp.h` file is included, and
therefore take full advantage of the `Rcpp` type system.

```
#include "RcppCommon.h"
#include "foobar.h"
RCPP_EXPOSED_WRAP(Bar)
```
Another non-intrusive option is to expose an external pointer.
The macro `RCPP_EXPOSED_WRAP` provides an easy way to expose
a C++ class to R as an external pointer. It can be used instead of
specializing `Rcpp::wrap`, and should not be used simultaneously.

###  Templates and partial specialization

```
#include <RcppCommon.h>

// third party library that declares
// a template class Bling<T>
#include <foobar.h>

// declaring the partial specialization
namespace Rcpp {
  namespace traits {
    template <typename T>
    SEXP wrap(const Bling<T>&);
  }
}
// this must appear after the specialization, or
// specialization will not be seen by Rcpp types
#include <Rcpp.h>
```

## Extending `Rcpp::as`: from `R` to `C++`
1. 从`RcppCommon.h`开始，以`Rcpp.h`结束。
2. intrusive, 定义了一个`Foo` class, Foo(SEXP)-> c lass, 不需要知道c class 具体是啥。
3. non-intrusive, 需要引用定义c class `const Bar&`的头文件，要用Rcpp namespace， `template <> Bar as (SEXP)`.
4. partial, 需要引用定义c class `const Bar&`的头文件，要用`Rcpp::traits` namespace，`template <typename T>
class Exporter<Bling<T>>;`. 跟3比，class `Exporter<Bling<T>>` 可以应用于不同类型`<T>`.
5. 或者可以用Macro，不需要以`Rcpp.h`结束， 但需要引用定义c class `const Bar&`的头文件，具体函数为`RCPP_EXPOSED_AS(Bar)`.

### Intrusive extension

```
#include <RcppCommon.h>

class Foo{
  public:
    Foo();

    // this ctor enables implicit Rcpp::as
    Foo(SEXP);
}

// this must appear after the specialization, or
// specialization will not be seen by Rcpp types
#include <Rcpp.h>
```

### Non-intrusive extension

```
#include <RcppCommon.h>

// third party library that declares class Bar
#include <foobar.h>

// declaring the specialization
namespace Rcpp {
  template <> Bar as (SEXP);
}

// this must appear after the specialization, or
// specialization will not be seen by Rcpp types
#include <Rcpp.h>
```

The macro `RCPP_EXPOSED_AS` provides an
easy way to extend `Rcpp::as` to expose R external pointers to C++.
It can be used instead of specializing `Rcpp::as`, and should not be
used simultaneously.
```
#include RcppCommon.h
#include foobar.h
RCPP_EXPOSED_AS(Bar)
```
With this being said, there is one additional macro that
can be used to simultaneously define both `Rcpp::wrap` and
`Rcpp::as` specialization for an external pointer. The macro
`RCPP_EXPOSED_CLASS` can be use to transparently exchange a class
between R and C++ as an external pointer. Do not simultaneously
use it alongside `RCPP_EXPOSED_AS`, `RCPP_EXPOSED_WRAP`,
`Rcpp::wrap`, or `Rcpp::as`.

### Templates and partial specialization
The signature of `Rcpp::as` does not allow partial specialization.
When exposing a templated class to `Rcpp::as`, the programmer must
specialize the `Rcpp::traits::Exporter` template class.

The TMP dispatch will recognize that a specialization of Exporter
is available and delegate the conversion to this class.

Invoke the constructor of the type T taking a SEXP.

```
namespace Rcpp {
  namespace traits {

    template<typename T> class Exporter{
      public:
        Exporter(SEXP x) : t(x){}
        inline T get() {return t;}

      private:
        T t;
    }
  }
}
```

```
#include <RcppCommon.h>

// third party library that declares
// a template class Bling<T>
#include <foobar.h>

// declaring the partial specialization
namespace Rcpp {
  namespace traits {
    template <typename T>
    class Exporter<Bling<T>>;
  }
}

// this must appear after the specialization, or
// specialization will not be seen by Rcpp types
#include <Rcpp.h>
```

The requirements for the `Exporter<Bling <T>>` class are:
- it should have a constructer taking a `SEXP`
- it should have a method called `get` that returns an instance of the `Bling<T>` type.

# A Concrete Example using `boost` library

在引用`Rcpp.h`之前，需要引用头文件`RcppCommon.h`，并且在namespace `Rcpp::traits`中加入新的定义。

在namespace `Rcpp::traits`中，我们要用到两个Rcpp函数，`Rcpp::as<T>(obj)` and `Rcpp::wrap(obj)`。
为了可以使用多种类型，我们创建一个`Exporter` class, 而不是用`template <> ClassName as (SEXP)`.

### Stage 1 - Forward Declarations
```
// -------------- Stage 1: Forward Declarations with `RcppCommon.h`

#include <RcppCommon.h>

// Flags for C++ compiler: include Boost headers, use the C++11 standard

// [[Rcpp::depends(BH)]]
// [[Rcpp::plugins("cpp11")]]

// Third party library includes that provide the template class of ublas
#include <boost/numeric/ublas/matrix_sparse.hpp>
#include <boost/numeric/ublas/matrix.hpp>

// Provide Forward Declarations
namespace Rcpp {
  namespace traits {
    // Setup non-intrusive extension via template specialization for
    // 'ublas' class boost::numeric::ublas

    // Support for wrap
    template <typename T> SEXP wrap(const boost::numeric::ublas::vector<T> & obj);
    // Support for as<T>
    template <typename T> class Exporter<boost::numeric::ublas::vector<T>>;
  }
}
```

### Stage 2 Include the `Rcpp.h` header
```
// -------------- Stage 2: Including Rcpp.h

// ------ Place <Rcpp.h> AFTER the Forward Declaration!!!!

#include <Rcpp.h>

// ------ Place Implementations of Forward Declarations AFTER <Rcpp.h>!
```

### Stage 3 - Implementing the Declarations
#### Implement `wrap()`
To implement `wrap()` we must appeal to a built-in type conversion index within Rcpp which is called `Rcpp::traits::r_sexptype_traits<T>::rtype`. From this, we are able to obtain an int containing the RTYPE and then construct an `Rcpp::Vector`. For the construction of a matrix, the same ideas hold true.


#### Implement `as()`
For `as<>()`, we need to consider the template that will be passed in. Furthermore, we setup a `typedef` directly underneath the `Exporter` class definition to easily define an `OUT` object to be used within the `get()` method. Outside of that, we use the same trick to move back and forth from a `C++ T` template type to an R type (implemented as one of several SEXP types).

In order to accomplish the as<>, or the direct port from R to C++, I had to do something dirty: I copied the vector contents. The code that governs this output is given within the get() of the Exporter class. You may wish to spend some time looking into changing the assignment using pointers perhaps. I am not very well versed with ublas so I did not see an easy approach to resolve the pointer pass.

```
// -------------- Stage 3: Implementation the Declarations

// Define template specializations for as<> and wrap
namespace Rcpp {

    namespace traits{

        // Defined wrap case: c class obj -> Rcpp::Vector<RTYPE>
        template <typename T> SEXP wrap(const boost::numeric::ublas::vector<T> &obj){
          const int RTYPE = Rcpp::traits::r_sexptype_traits<T>::rtype;
          return Rcpp::Vector<RTYPE> (obj.begin(), obj.end());
        }
        // Defined as<> case: R obj vec -> x of type OUT in c
        template <typename T> class Exporter<boost::numeric::ublas::vector<T>> {
          typedef typename boost::numeric::ublas::vector<T> OUT;
          // Convert the type to a valid rtype;
          // why static??
          const static int RTYPE = Rcpp::traits::r_sexptype_traits<T>::rtype;
          Rcpp::Vector<RTYPE> vec;

          public:
          Exporter(SEXP x) : vec(x){
            if (TYPEOF(x)!=RTYPE)
              throw std::invalid_argument("Wrong R type for mapped 1D array");
          }
          OUT get(){
            // Need to figure out a way to perhaps do a pointer pass?
            OUT x(vec.size());
            std::copy(vec.begin(),vec.end(),x.begin()); //have to copy data
            return x;
          }
        }
```

### Stage 4 - Testing
```
// -------------- Stage 4: Testing

// Here we define a shortcut to the Boost ublas class to enable multiple ublas
// types via a template.
// ublas::vector<T> => ublas::vector<double>, ... , ublas::vector<int>
namespace ublas = ::boost::numeric::ublas;

// [[Rcpp::export]]
void containment_test(Rcpp::NumericVector x1){
  Rcpp::Rcout << "Converting from Rcpp::NumericVector to ublas::vector<double>" <<std::endl;

  //initialize the vector to all zero
  ublas::vector<double> x = Rcpp::as<ublas::vector<double>>(x1);

  Rcpp::Rcout << "Running output test with ublas::vector<double>" << std::endl;

  for (unsigned i=0; i < x.size(); ++i)
    Rcpp::Rcout << x(i) << std::endl;

  Rcpp::Rcout << "Converting from ublas::vector<double> to Rcpp::NumericVector" <<std::endl;

  Rcpp::NumericVector test = Rcpp::wrap(x);
  Rcpp::Rcout << "Running output test with Rcpp::NumericVector" << std::endl;

  for (unsigned i=0; i<test.size(); ++i)
    Rcpp::Rcout << test(i) << std::endl;
}
```

In R:
```
containment_test(c(1,2,3,4))
```

In C:
```
// [[Rcpp::export]]
ublas::vector<double> automagic_ublas_rcpp(ublas::vector<double> x1) {
    return x1;
}
```

In R:
```
automagic_ublas_rcpp(c(1,2,3.2,1.2))
```

## Other Examples
Check the R package `RcppEigen` and look for the header file `RcppEigenWrap.h`.

## Creating as and wrap for sparse matrices
### `as`

1. The classes for the most common types of R vectors are defined in namespace `Rcpp`:
`NumericVector`, `IntegerVector`, `CharacterVector`, and `LogicalVector`. Besides these,
one can define template vector by `const int RTYPE = Rcpp::traits::r_sexptype_traits<T>::rtype;` and
`Vector<RTYPE>`.

```
#include <RcppArmadillo.h>
 // [[Rcpp::depends(RcppArmadillo)]]

 using namespace Rcpp;

 namespace Rcpp {

     // converts an SEXP object from R which was created as a sparse
     // matrix via the Matrix package) into an Armadillo sp_mat matrix
     //
     // NB: called as_() here as a similar method is already in the
     //     RcppArmadillo sources
     //

     // The following as_() only applies to dgCMatrix.
     // For other types of sparse matrix conversion,
     // you might want to check the source code of RcppArmadillo.
     template <typename T> arma::SpMat<T> as_(SEXP sx) {

       // Rcpp representation of template type
       const int RTYPE = Rcpp::traits::r_sexptype_traits<T>::rtype;

       // instantiate S4 object with the sparse matrix passed in
       // copy R object sx from R to S4 object mat in C++
       // dims,i,p,x are R Vectors defined in namespace Rcpp
       S4 mat(sx);
       IntegerVector dims = mat.slot("Dim");
       IntegerVector i = mat.slot("i");
       IntegerVector p = mat.slot("p");
       Vector<RTYPE> x = mat.slot("x");

       // create sp_mat object of appropriate size
       arma::SpMat<T> res(dims[0], dims[1]);

       // In order to access the internal arrays of the SpMat class
       res.sync();

       // Making space for the elements
       res.mem_resize(static_cast<unsigned>(x.size()));

       // Copying elements
       std::copy(i.begin(), i.end(), arma::access::rwp(res.row_indices));
       std::copy(p.begin(), p.end(), arma::access::rwp(res.col_ptrs));
       std::copy(x.begin(), x.end(), arma::access::rwp(res.values));

       return res;
     }

 }

```

### `wrap()`

```
namespace Rcpp {

     // convert an Armadillo sp_mat into a corresponding R sparse matrix
     // we copy to STL vectors as the Matrix package expects vectors whereas the
     // default wrap in Armadillo returns matrix with one row (or col)
     //
     // NB: called wrap_() here as a similar method is already in the
     //     RcppArmadillo sources
     //
     template <typename T> SEXP wrap_(const arma::SpMat<T>& sm) {
       const int  RTYPE = Rcpp::traits::r_sexptype_traits<T>::rtype;

       // In order to update internal state of SpMat object
       sm.sync();
       IntegerVector dim = IntegerVector::create( sm.n_rows, sm.n_cols );

       // copy the data into R objects
       Vector<RTYPE> x(sm.values, sm.values + sm.n_nonzero ) ;
       IntegerVector i(sm.row_indices, sm.row_indices + sm.n_nonzero);
       IntegerVector p(sm.col_ptrs, sm.col_ptrs + sm.n_cols+1 ) ;

       std::string klass = "dgCMatrix";

       S4 s(klass);
       s.slot("i")   = i;
       s.slot("p")   = p;
       s.slot("x")   = x;
       s.slot("Dim") = dim;
       return s;
     }

 }
```

```
// [[Rcpp::export]]
arma::sp_mat doubleSparseMatrix(arma::sp_mat m) {
    Rcpp::Rcout << m << std::endl;  // use the i/o code from Armadillo
    arma::sp_mat n = 2*m;
    return n;
}
```

In R:
```
suppressMessages({
  library(methods)
  library(Matrix)
})
i <- c(1,3:8)              # row indices
j <- c(2,9,6:10)           # col indices
x <- 7 * (1:7)             # values
A <- sparseMatrix(i, j, x = x)
A
B <- doubleSparseMatrix(A)
B
identical(2*A, B)
```


## References
- [Rcpp Extending](https://cran.r-project.org/web/packages/Rcpp/vignettes/Rcpp-extending.pdf)
- [Custom Templated as and wrap Functions within Rcpp.](https://gallery.rcpp.org/articles/custom-templated-wrap-and-as-for-seamingless-interfaces/)
- [Creating as and wrap for sparse matrices](http://gallery.rcpp.org/articles/as-and-wrap-for-sparse-matrices/)
