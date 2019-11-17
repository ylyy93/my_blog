---
layout: post
title: Pick up Python immediately
date: 2019-11-16 17:12 -0800
categories: Coding
tags: [Python]
---

### Basic syntax
* case sensitive
* no `;`
* indent (4 spaces)
* can assign function
* `g, h = min,max`

```
from math import pi
def area(x):
    return x*x*pi
```

```
f = min
f = max
g, h = min , max
max = g
max(f(2,g(h(1,5),3)),4)
```

### math functions
- [math](https://docs.python.org/3/library/math.html)
```
from math import sqrt,sin,ceil,floor,isqrt
```

### range
- [range](https://www.w3schools.com/python/ref_func_range.asp)
```
for x in range(6):
    print x
    """
    0 1 2 3 4 5
    """

for x in range(3, 6):
      print(x)
      """
      3 4 5
      """
```

### For loop
```
for x in range(2, 6):
  print(x)
```



## References
- [cs61a: Structure and Interpretation of Computer Programs](https://cs61a.org)
