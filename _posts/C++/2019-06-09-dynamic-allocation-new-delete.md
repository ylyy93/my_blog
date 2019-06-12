---
layout: post
title: 'Dynamic allocation: new/delete '
date: 2019-06-09 10:19 -0600
categories: Tech
tags: [c++]
---

## Dynamic allocation
1. In `c`, use `malloc` + `free`
2. In `c++`, use `new` + `delete`


- `c`:
  * malloc
  * `int *data = (int*) malloc(sizeof(int));`
- `c++`:
  * new
  * `int *data = new int;`
- allocation of contiguous block of memory

To recycle a segment of memory allocated with new:
- `c`:
  * free()
- `c++`:
  * `delete (data);`

If the allocated memory is not freed when it's no longer necessary it will result in a memory leak.

#### Memory leak
 It is not specified what will happen to the leaked memory, but contemporary operating systems collect it when the **program terminates**. Memory leaks can be very dangerous because the system may run out of memory.

 To eliminate them, C++ provides a destructor member for every class where the programmer should deallocate all the memory it allocates inside the class.

### malloc v.s. new in `c++`
- 不建议在`c++`中用malloc + free。（new + delete preferred）
- cast<int> not required (or undesirable) in `c` (c has implicit cast between void\* and other pointer types)
- we must cast pointer if use malloc in c++ (void\* not recommended in `c++`)
- if want to use void\* in c++, use `dynamic_cast` or `static_cast`

#### new/delete: cons
- type safe, no need to cast
- figures out size automatically, no need to specify
- throws an exception when it fails, no need to check (null pointer <- returned by malloc when it fails)


### Dynamic arrays: `new[]` and `delete[]`

```
Myclass *myclass;
my_class = new Myclass [size]; // size must be of type int
delete [] my_class;
```
