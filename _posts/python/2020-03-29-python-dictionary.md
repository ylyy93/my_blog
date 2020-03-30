---
layout: post
title: Python - Dictionary
date: 2020-03-29 17:23 -0700
categories: Coding
tags: [Python]
---

## Accessing Values

```python
#!/usr/bin/python3

dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}
print ("dict['Name']: ", dict['Name'])
print ("dict['Age']: ", dict['Age'])
```

```bash
dict['Name']:  Zara
dict['Age']:  7
```

## Updating
```python
#!/usr/bin/python3

dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}
dict['Age'] = 8; # update existing entry
dict['School'] = "DPS School" # Add new entry

print ("dict['Age']: ", dict['Age'])
print ("dict['School']: ", dict['School'])
```

```bash
dict['Age']:  8
dict['School']:  DPS School
```

## Delete

```python
#!/usr/bin/python3

dict = {'Name': 'Zara', 'Age': 7, 'Class': 'First'}

del dict['Name'] # remove entry with key 'Name'
dict.clear()     # remove all entries in dict
del dict         # delete entire dictionary
```

## Properties

* (a) More than one entry per key is not allowed. This means no duplicate key is allowed. When duplicate keys are encountered during assignment, the last assignment wins.

```python
#!/usr/bin/python3

dict = {'Name': 'Zara', 'Age': 7, 'Name': 'Manni'}
print ("dict['Name']: ", dict['Name'])
```

```bash
dict['Name']:  Manni
```

* (b) Keys must be immutable. This means you can use strings, numbers or tuples as dictionary keys but something like ['key'] is not allowed.

```python
#!/usr/bin/python3

dict = {['Name']: 'Zara', 'Age': 7}
print ("dict['Name']: ", dict['Name'])
```

```bash
Traceback (most recent call last):
   File "test.py", line 3, in <module>
      dict = {['Name']: 'Zara', 'Age': 7}
TypeError: list objects are unhashable
```

## Built-in Dictionary Functions and Methods

### Functions

* `len(dict)`: Gives the total length of the dictionary. This would be equal to the number of items in the dictionary.
* `str(dict)`: Produces a printable string representation of a dictionary
* `type(variable)`: Returns the type of the passed variable. If passed variable is dictionary, then it would return a dictionary type.

### Methods

|Method                              |   Description   |
|------------------------------------|-----------------|
|dict.clear()                        |Removes all elements of dictionary dict   |
|dict.copy()                         |Returns a shallow copy of dictionary dict   |
|dict.fromkeys()                     |Create a new dictionary with keys from seq and values set to value   |
|dict.get(key,default=None)          |For `key` key, returns value or default if key not in dictionary   |
|dict.items()                        |Returns a list of dict's (key, value) tuple pairs   |
|dict.keys()                         |Returns list of dictionary dict's keys   |
|dict.setdefault(key,default=None)   |Similar to get(), but will set dict[key] = default if key is not already in dict   |
|dict.update(dict2)                  |Adds dictionary dict2's key-values pairs to dict   |
|dict.values()                       |Returns list of dictionary dict's values   |
