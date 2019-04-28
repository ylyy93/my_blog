---
layout: post
title: Preprocessor Directives
date: 2019-04-27 12:02 -0600
categories: Tech
tags: [c++]
---

## 预处理（preprocessor）
- 预处理器是一些指令，指示编译器在实际编译之前所需完成的预处理。
- 所有的预处理器指令都是以井号（\#）开头，只有空格字符可以出现在预处理指令之前。预处理指令不是 C++ 语句，所以它们不会以分号（;）结尾。
- 比如，\#include 指令。这个宏用于把头文件包含到源文件中。

### \#define: creates a macro(宏)

#### 替换宏
Syntax: \#define identifier token (#define macro-name replacement-text)
```
#define WIDTH       80
#define LENGTH      ( WIDTH + 10 )
```

#### 参数宏
```
#define MIN(a,b) (a<b ? a : b)

// Macro to define cursor lines
#define CURSOR(top, bottom) (((top) << 8) | (bottom))

// Macro to get a random integer with a specified range
#define getrandom(min, max) \
    ((rand()%(int)(((max) + 1)-(min)))+ (min))
```

使用宏有以下几点好处：

  - (1)在输入源代码时，可省去许多键入操作。   
  - (2)因为宏只需定义一次，但可以多次使用，所以使用宏能增强程序的易读性和可靠性。
  - (3)使用宏不需要额外的开销，因为宏所代表的代码只在宏出现的地方展开，因此不会引起程序中的跳转。
  - (4)宏的参数对类型不敏感，因此你不必考虑将何种数据类型传递给宏。

### 条件编译
有几个指令可以用来有选择地对部分程序源代码进行编译。这个过程被称为条件编译。

条件预处理器的结构与 if 选择结构很像。请看下面这段预处理器的代码：
```
#ifdef NULL
  #define NULL 0
#endif
```

您可以只在调试时进行编译，调试开关可以使用一个宏来实现，如下所示：
```
#ifdef DEBUG
  cerr <<"Variable x = " << x << endl;
#endif
```
如果在指令 `#ifdef` DEBUG 之前已经定义了符号常量 DEBUG，则会对程序中的 `cerr` 语句进行编译。

您可以使用 `#if 0` 语句注释掉程序的一部分，如下所示：
```
#if 0
   不进行编译的代码
#endif
```

### \# and \#\# 运算符
\# 和 \#\# 预处理运算符在 C++ 和 ANSI/ISO C 中都是可用的。\# 运算符会把 replacement-text 令牌转换为用引号引起来的字符串。

```
#include <iostream>
using namespace std;

#define MKSTR( x ) #x

int main ()
{
    cout << MKSTR(HELLO C++) << endl;

    return 0;
}
```

Output:
```
HELLO C++
```

工作原理：
```
cout << MKSTR(HELLO C++) << endl;
```
to
```
cout << "HELLO C++" << endl;
```

\#\# 运算符用于连接两个令牌。下面是一个实例：

Instance:
```
#include <iostream>
using namespace std;

#define concat(a, b) a ## b
int main()
{
   int xy = 100;

   cout << concat(x, y);
   return 0;
}
```
Output:
```
100
```
工作原理：
```
cout << concat(x, y);
```
to
```
cout << xy;
```

### 预定义宏

Instance:
```
#include <iostream>
using namespace std;

int main ()
{
    cout << "Value of __LINE__ : " << __LINE__ << endl; //这是第六行
    cout << "Value of __FILE__ : " << __FILE__ << endl;
    cout << "Value of __DATE__ : " << __DATE__ << endl;
    cout << "Value of __TIME__ : " << __TIME__ << endl;

    return 0;
}
```
Output:
```
Value of __LINE__ : 6
Value of __FILE__ : .../predefined_macros/predefined_macros/main.cpp
Value of __DATE__ : Apr 27 2019
Value of __TIME__ : 13:07:06
Program ended with exit code: 0
```
