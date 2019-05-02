---
layout: post
title: Register Routines with Rcpp
date: 2019-05-02 10:44 -0600
categories: Tech
tags: [R]
---

从R（3.4.0）开始，你在写R包的时候，需要对所有编译过的函数进行注册。

这么理解，当你在R中调用C函数，R会搜索你所在session里面所有的编译过的object。

注册函数相当于加上一个namespace(::),这样R就精确知道去哪里找这个函数，速度更快。

用`Rcpp`包的话，这些会自动生成在`RcppExports.cpp`文件中。

我们看个例子；（from `spNNGP`)

```
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>
#include "spNNGP.h"

static const R_CallMethodDef CallEntries[] = {
    {"rNNGP", (DL_FUNC) &rNNGP, 24},
    {"sNNGP", (DL_FUNC) &rNNGP, 24},
    {"cNNGP", (DL_FUNC) &cNNGP, 16},
    {"rNNGPPredict", (DL_FUNC) &cNNGP, 17},
    {"sNNGPPredict", (DL_FUNC) &cNNGP, 18},
    {NULL, NULL, 0}
};

void R_init_spNNGP(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
```

### Step 1: `init.cpp`

假如现在你写了一个function，`routines.R`,首先
```
devtools::source_gist("b93b589b17c3315f766d3e2988533558", filename = "routines.R")
```
然后，
```
package_native_routine_registration_skeleton(dir = "path/to/the/base/directory/of/your/package")
```
这样即可生成
```
#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP test_func(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"test_func", (DL_FUNC) &test_func, 1},
    {NULL, NULL, 0}
};

void R_init_diffr(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
```
将这个文件放在R包`src`文件夹下，命名为`init.cpp`。

为了检查正确性，可以与`RcppExports.R`对照，比较以下两项：
1. 在`R_CallMethodDef`中的每个函数，是否在`RcppExports.R`中有对应`extern`?
2. `R_CallMethodDef`中每个函数的最后一项，即参数个数是否与`RcppExports.R`中函数的定义一致？

### Step 2: 告诉R包函数已注册

如果你是手动添加R包目录下的`NAMESPACE`文件，在里面添加行，比如
```
useDynLib(spNNGP, .registration=TRUE)
```
第一项为R包的名字。

如果你用`roxygen`来自动添加，可以



# Refenreces
- [](https://ironholds.org/registering-routines/)
