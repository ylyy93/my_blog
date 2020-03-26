---
layout: post
title: Python - Object Oriented
date: 2020-03-25 12:18 -0700
categories: Coding
tags: [Python]
---

- [Python 3 - Object Oriented](https://www.tutorialspoint.com/python3/python_classes_objects.htm)

## Creating Classes
```python3
class Employee:
   'Common base class for all employees'
   empCount = 0

   def __init__(self, name, salary):
      self.name = name
      self.salary = salary
      Employee.empCount += 1

   def displayCount(self):
     print ("Total Employee %d" % Employee.empCount)

   def displayEmployee(self):
      print ("Name : ", self.name,  ", Salary: ", self.salary)
```
