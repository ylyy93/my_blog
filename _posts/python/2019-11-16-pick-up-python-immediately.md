---
layout: post
title: Pick up Python immediately
date: 2019-11-16 17:12 -0800
categories: Coding
tags: [Python]
---

### Misc
`ex.py`

```python
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

```python
from math import pi
def area(x):
    return x*x*pi
```

```python
f = min
f = max
g, h = min , max
max = g
max(f(2,g(h(1,5),3)),4)
```

### math functions
- [math](https://docs.python.org/3/library/math.html)

```python
from math import sqrt,sin,ceil,floor,isqrt
```

### range
- [range](https://www.w3schools.com/python/ref_func_range.asp)

```python
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

### [Condition](http://composingprograms.com/pages/15-control.html#conditional-statements)

```python
def absolute_value(x):
    if x < 0:
        return -x
    elif x == 0:
        return 0
    else:
        return x          
```

### Iteration
#### while

```python
i, total = 0,0
while i < 3:
    i = i + 1
    total = total + i    
```



False values in Python: False, 0, '', None
True values in Python


### `Call` expression v.s. `if` expression

```python
def with_if_statement():
    """
    >>> result = with_if_statement()
    2
    >>> print(result)
    None
    """
    if c():
        return t()
    else:
        return f()

def with_if_function():
    """
    >>> result = with_if_function()
    1
    2
    >>> print(result)
    None
    """
    return if_function(c(), t(), f())

def c():
    return False

def t():
    print(1)

def f():
    print(2)
```

The function with_if_function uses a call expression, which guarantees that all of its operand subexpressions will be evaluated before if_function is applied to the resulting arguments.

Therefore, even if c returns False, the function t will be called. When we call t, we print out 1. Then, when we call f, we will also print 2.

By contrast, with_if_statement will never call t if c returns False. Thus, we will only call f, printing 2.


## References
- [cs61a: Structure and Interpretation of Computer Programs](https://cs61a.org)
