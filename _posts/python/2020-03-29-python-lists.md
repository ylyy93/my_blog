---
layout: post
title: Python - Lists
date: 2020-03-29 13:19 -0700
categories: Coding
tags: [Python]
---

- [Python 3 - Lists](https://www.tutorialspoint.com/python3/python_lists.htm)

## Create Lists (`[,]`)

```python
list1 = ['physics', 'chemistry', 1997, 2000];
list2 = [1, 2, 3, 4, 5 ];
list3 = ["a", "b", "c", "d"];
```

## Accessing Values

```python
#!/usr/bin/python3

list1 = ['physics', 'chemistry', 1997, 2000]
list2 = [1, 2, 3, 4, 5, 6, 7 ]

print ("list1[0]: ", list1[0])
print ("list2[1:5]: ", list2[1:5])
```

```bash
list1[0]:  physics
list2[1:5]:  [2, 3, 4, 5]
```

## Updating Lists
```python

#!/usr/bin/python3

list = ['physics', 'chemistry', 1997, 2000]
print ("Value available at index 2 : ", list[2])

list[2] = 2001
print ("New value available at index 2 : ", list[2])
```

```bash
Value available at index 2 :  1997
New value available at index 2 :  2001
```

## Delete List

```python
#!/usr/bin/python3

list = ['physics', 'chemistry', 1997, 2000]
print (list)

del list[2]
print ("After deleting value at index 2 : ", list)
```

```bash
['physics', 'chemistry', 1997, 2000]
After deleting value at index 2 :  ['physics', 'chemistry', 2000]
```

## Basic List Operations

* `len(mylist)`: length
* `list1 + list2`: concatenation
* `mylist * 4`: repetition
* `3 in mylist`: membership
* `for x in mylist: print (x,end='')`: iteration


## Indexing, Slicing and Matrices
```python
L = ['C++', 'Java', 'Python']
```

* `L[2]`: 'Python'
* `L[-2]`: 'Java'
* `L[1:]`: `['Java','Python']`

## Build-in List Functions and Methods

* `len(list)`
* `max(list)`
* `min(list)`
* `list(seq)`: Converts a tuple into list.

* `list.append(obj)`
* `list.count(obj)`: Returns count of how many times obj occurs in list
* `list.extend(seq)`: Appends the contents of seq to list
* `list.index(obj)`: Returns the lowest index in list that obj appears
* `list.insert(index, obj)`: Inserts object obj into list at offset index
* `list.pop(obj=list[-1])`: Removes and returns last object or obj from list
* `list.remove(obj)`: Removes object obj from list
* `list.reverse()`: Reverse objects of list in place
* `list.sort([func])`: Sorts objects of list, use compare func if given
