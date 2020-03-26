---
layout: post
title: Python - Object Oriented
date: 2020-03-25 12:18 -0700
categories: Coding
tags: [Python]
---

- [Python 3 - Object Oriented](https://www.tutorialspoint.com/python3/python_classes_objects.htm)

## Creating Classes
```python
class Employee:
   'Common base class for all employees'

   # Attributes
   empCount = 0

   # Functions
   def __init__(self, name, salary):
      self.name = name
      self.salary = salary
      Employee.empCount += 1

   def displayCount(self):
     print ("Total Employee %d" % Employee.empCount)

   def displayEmployee(self):
      print ("Name : ", self.name,  ", Salary: ", self.salary)
```

## Creating Instance Objects
```python
# This would create first object of Employee class
emp1 = Employee("Zara", 2000)
# This would create second object of Employee class
emp2 = Employee("Manni", 5000)
```

## Accessing Attributes

### Dot operation
```python
emp1.displayEmployee()
emp2.displayEmployee()
print ("Total Employee %d" % Employee.empCount)
```

###### results
```
Name :  Zara ,Salary:  2000
Name :  Manni ,Salary:  5000
Total Employee 2
```

### Use functions
* The `getattr(obj, name[, default])` − to access the attribute of object.
* The `hasattr(obj,name)` − to check if an attribute exists or not.
* The `setattr(obj,name,value)` − to set an attribute. If attribute does not exist, then it would be created.
* The `delattr(obj, name)` − to delete an attribute.

```python
hasattr(emp1, 'salary')    # Returns true if 'salary' attribute exists
getattr(emp1, 'salary')    # Returns value of 'salary' attribute
setattr(emp1, 'salary', 7000) # Set attribute 'salary' at 7000
delattr(emp1, 'salary')    # Delete attribute 'salary'
```

## Add, Remove, or Modify attributes
```python
emp1.salary = 7000  # Add an 'salary' attribute.
emp1.name = 'xyz'  # Modify 'age' attribute.
del emp1.salary  # Delete 'age' attribute.
```

## Built-In Class Attributes
Every Python class keeps following built-in attributes and they can be accessed using dot operator like any other attribute.

* **__name__** − Class name.
* **__bases__** − A possibly empty tuple containing the base classes, in the order of their occurrence in the base class list.
* **__dict__** − Dictionary containing the class's namespace.
  * **__doc__** − Class documentation string or none, if undefined.
  * **__module__** − Module name in which the class is defined. This attribute is "__main__" in interactive mode.

```python
print ("Employee.__doc__:", Employee.__doc__)
print ("Employee.__name__:", Employee.__name__)
print ("Employee.__module__:", Employee.__module__)
print ("Employee.__bases__:", Employee.__bases__)
print ("Employee.__dict__:", Employee.__dict__ )
```

```
Employee.__doc__: Common base class for all employees
Employee.__name__: Employee
Employee.__module__: __main__
Employee.__bases__: (<class 'object'>,)
Employee.__dict__: {
   'displayCount': <function Employee.displayCount at 0x0160D2B8>,
   '__module__': '__main__',
   '__doc__': 'Common base class for all employees',
   'empCount': 2,
   '__init__': <function Employee.__init__ at 0x0124F810>,
   'displayEmployee': <function Employee.displayEmployee at 0x0160D300>,
   '__weakref__': <attribute '__weakref__' of 'Employee' objects>,
   '__dict__': <attribute '__dict__' of 'Employee' objects>
}
```

## Class Inheritance

* Use everything from your "parent" as if you defined it (except for `__init__`).
* And you can override you parent class methods

```python
#!/usr/bin/python3

class Parent:        # define parent class
   parentAttr = 100
   def __init__(self):
      print ("Calling parent constructor")

   def parentMethod(self):
      print ('Calling parent method')

   def setAttr(self, attr):
      Parent.parentAttr = attr

   def getAttr(self):
      print ("Parent attribute :", Parent.parentAttr)

class Child(Parent): # define child class
   def __init__(self):
      print ("Calling child constructor")

   def childMethod(self):
      print ('Calling child method')

c = Child()          # instance of child
c.childMethod()      # child calls its method
c.parentMethod()     # calls parent's method
c.setAttr(200)       # again call parent's method
c.getAttr()          # again call parent's method
```

##### Results
```
Calling child constructor
Calling child method
Calling parent method
Parent attribute : 200
```

## Base Overloading Methods
1	`__init__ ( self [,args...] )`: Constructor (with any optional arguments)
`* Sample Call : `obj = className(args)`
2	`__del__( self )`: Destructor, deletes an object
  * Sample Call : `del obj`
3	`__repr__( self )`: Evaluatable string representation
  * Sample Call : `repr(obj)`
4	`__str__( self )`: Printable string representation
  * Sample Call : `str(obj)`
5	`__cmp__ ( self, x )`: Object comparison
  * Sample Call : `cmp(obj, x)`

```python
#!/usr/bin/python3

class Vector:
   def __init__(self, a, b):
      self.a = a
      self.b = b

   def __str__(self):
      return 'Vector (%d, %d)' % (self.a, self.b)

   def __add__(self,other):
      return Vector(self.a + other.a, self.b + other.b)

v1 = Vector(2,10)
v2 = Vector(5,-2)
print (v1 + v2)
```

## Data Hiding (with prefix `__`)
```python
#!/usr/bin/python3

class JustCounter:
   __secretCount = 0

   def count(self):
      self.__secretCount += 1
      print (self.__secretCount)

counter = JustCounter()
counter.count()
counter.count()
print (counter.__secretCount) # error
print (counter._JustCounter__secretCount)
```
