---
layout: post
title: Garbage Collection in R
date: 2019-05-01 15:15 -0600
categories: Tech
tags: [R]
---

## 介绍`R`的`C`界面

R的C API主要有两种。第一种叫`.C`界面，这种界面下，你的c程序不需要懂任何的R object。 这个API在`Rdefines.h`中被定义。
第二种叫`.Call`界面，要用这个API，我们需要引用头文件`Rinternals.h`。

打开`R`，我们可以找到这个头文件所在的路径：
```
> rinternals <- file.path(R.home("include"), "Rinternals.h")
> rinternals
[1] "/Library/Frameworks/R.framework/Resources/include/Rinternals.h"
```

如果想要看到`Rinternals.h` 的具体内容，可以用：
```
> file.show(rinternals)
```

在这个文件中，所有的函数都有`Rf_`或者`R_`的前缀。 但是导出的时候都省略了这些前缀。

通常`C++`比`C`对于内存管理更加完善，所以推荐写`C++`程序而不是`C`程序。

## 在`R`中调用`C`

通常这个过程需要两个部分：一个`C`程序，和一个`R`外包程序。

`C`程序如下例：
```
#include <R.h>
#include <Rinternal.h>

SEXP add(SEXP a, SEXP b){
  SEXP result = PROTECT(allocVector(REALSXP,1)); // 分配内存给R object
  REAL(result)[0] = asReal(a) + asReal(b); // 将R object换成C object进行计算。
  //这里这么理解，首先告诉C我有一个类型为double的指针，将指针指向的值重新赋值。
  //REAL()函数并不改变result的类型，result依然是R中浮点的指针。
  UNPROTECT(1);
  return result;
}

```
`R`外包程序:
```
add <- function(a,b){
  .Call("add",a,b)
}
```

除了`.Call`外还有一个函数`.External`。这个函数的作用与`.Call`类似，只不过它只接受单个的`LISTSXP`参数。然而R包`inline`目前还不支持这个函数，所以按下不表。

在R中可以直接调用R包`inline`:
```
library(inline)
add <- cfunction(
  c(a="integer",b="integer"), #参数
  "  
  SEXP result = PROTECT(allocVector(REALSXP, 1));
  REAL(result)[0] = asReal(a) + asReal(b);
  UNPROTECT(1);

  return result;
  " #主体函数
)

# Test
add(1, 5)
```

在`C`里，所有的R objects都有公用的数据类型`SEXP`,所以如果你的C程序要在R中引用，输入和输出就都必须是`SEXP`类型。

同时,`SEXP`是一个多变的类型，即它包含很多子类。其中重要的几种包括：

| 类型| 描述   |
|----|--------|
| REALSXP| double vector |
| INTSXP| integer vector |
| LGLSXP| logical vector |
| STRSXP| character vector |
| VECSXP| list |
| CLOSXP| function(closure) |
| ENVSXP| environment |
| NILSXP| NULL|

### 数组的产生和更改（垃圾回收）

你在C中创建了一个R object，如果你不对其进行保护，R会认为他们没用了然后将其删除。下面我们一个个说明：

首先，创建R object: 用`allocVector(Type,size)`
```
// in C
SEXP dummy(){
  SEXP dbls = PROTECT(allocVector(REALSXP,4));
  SEXP lgls = PROTECT(allocVector(LGLSXP, 4));
  SEXP ints = PROTECT(allocVector(INTSXP, 4));

  SEXP vec = PROTECT(allocVector(VECSXP, 3));
  SET_VECTOR_ELT(vec, 0, dbls);
  SET_VECTOR_ELT(vec, 1, lgls);
  SET_VECTOR_ELT(vec, 2, ints);
  UNPROTECT(4);
  return vec;
}
```
上面函数中的`PROTECT`告诉`R`这个object正在被使用，如果你正在进行垃圾清理，请勿删除。
同时，你要保证，所有你保护下的object最后都需要进行`UNPROTECT`。你保护的对象个数必须等于你最后解除保护的对象的个数。否则会报错。

总之，每一次你产生了一个新的R object，你都需要将其保护起来。

另外，关于先UNPROTECT再return的合理性问题，在《S Programming》第145页给出了解释。
`UNPROTECT(n)`解除了对最后被保护的n个R objects的保护。 我们在进行return之间先告诉R我们完事了，但是立刻R就知道vec要当作Argument传递给一个R function `return`,所以认为it is still in use。 NO PROBLEM！！

##### 关于`VECSXP`的一点补充。
我们可以通过C里面的 `namesgets` 函数对list中的每个元素命名, 注意命名时`mkChar("string")`的使用。

```
\\首先，定义一个list以及一个name list
PROTECT(result_r = allocVector(VECSXP, size));
PROTECT(resultName_r = allocVector(VECSXP, size));
SET_VECTOR_ELT(result_r, 0, obj0_r);
SET_VECTOR_ELT(resultName_r, 0, mkChar("obj0_r"));
SET_VECTOR_ELT(result_r, 1, obj1_r);
SET_VECTOR_ELT(resultName_r, 1, mkChar("obj1_r"));
namesgets(result_r, resultName_r);
UNPROTECT(nProtect);
```

#### 初始化

```
zeroes <- cfunction(
  c(n_ = "integer"), '
  int n = asInteger(n_);

  SEXP out = PROTECT(allocVector(INTSXP, n));
  memset(INTEGER(out), 0, n * sizeof(int));
  UNPROTECT(1);

  return out;
')
zeroes(10);
```

- `asInteger`相当于取出R object `n_` 所指位置的值并赋值给`n`
- `memset`同样作用与out所指向的位置，INTEGER不改变pointer，只是告诉C里面的函数你处理的是个`int`。

未完待续。。。

# Refenreces

- [R’s C interface](http://adv-r.had.co.nz/C-interface.html)
