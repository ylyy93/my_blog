---
layout: post
title: Pick up Python immediately
date: 2019-11-16 17:12 -0800
categories: Coding
tags: [Python]
---

### Misc
`ex.py`
```
from operator import floordiv, mod

def divide_exact(n,d):
    """Return the quotient and reminder of dividing N by D.
    >>> q, r = divide_exact(2013,10)
    >>> q
    201
    >>> r
    3
    """

    return floordiv(n,d), mod(n,d)
```

In terminal

* `python3 -m doctest ex.py`: should see no output
* `python3 -m doctest -v ex.py`: show details
* `python3 -i ex.py`: run ex.py and follows interactively
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

### Iteration
#### while


### if condition

```
def absolute_value(x):
    if x < 0:
        return -x
    elif x == 0:
        return 0
    else:
        return x          
```

False values in Python: False, 0, '', None
True values in Python


## References
- [cs61a: Structure and Interpretation of Computer Programs](https://cs61a.org)
