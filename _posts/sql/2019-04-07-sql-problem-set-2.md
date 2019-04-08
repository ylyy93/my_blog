---
layout: post
title: sql problem set 2
date: 2019-04-07 14:12 -0600
categories: Tech
tags: [SQL]
---

1. not equal to `<>`
2. 取余数 `MOD(a,b)` or `a%b`
3. `COUNT(*)` 可以直接在`having`语句中。
4. 一个table的primary key满足两个条件：a. unique b. not null.
5. `datediff(w1.Date,w2.Date)`
### Problem 1. 不boring的电影

X city opened a new cinema, many people would like to go to this cinema. The cinema also gives out a poster indicating the movies’ ratings and descriptions.

Please write a SQL query to output movies with an odd numbered ID and a description that is not 'boring'. Order the result by rating.

For example, table cinema:
---------------------
```
+---------+-----------+--------------+-----------+
|   id    | movie     |  description |  rating   |
+---------+-----------+--------------+-----------+
|   1     | War       |   great 3D   |   8.9     |
|   2     | Science   |   fiction    |   8.5     |
|   3     | irish     |   boring     |   6.2     |
|   4     | Ice song  |   Fantacy    |   8.6     |
|   5     | House card|   Interesting|   9.1     |
+---------+-----------+--------------+-----------+
```
```
SELECT id, description
FROM cinema
WHERE MOD(id,2) = 1
AND description <> 'boring'
ORDER BY rating DESC
```

### Problem 2. 重复的Email
Write a SQL query to find all duplicate emails in a table named `Person`.

```
+----+---------+
| Id | Email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
```

```
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
```

```
SELECT Email
FROM Person
GROUP BY Email
HAVING COUNT(*) > 1
```

### Problem 3. Combine two tables
Q: `as` 是必要的吗？

Table: Person
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| PersonId    | int     |
| FirstName   | varchar |
| LastName    | varchar |
+-------------+---------+
PersonId is the primary key column for this table.
```
Table: Address
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| AddressId   | int     |
| PersonId    | int     |
| City        | varchar |
| State       | varchar |
+-------------+---------+
AddressId is the primary key column for this table.
```

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:

> FirstName, LastName, City, State


```
SELECT t1.FirstName, t1.LastName, t2.City, t2.State
FROM Person as t1
LEFT JOIN Address as t2
ON t1.PersonId = t2.PersonId
```

### Problem 4: 比经理赚更多的雇员。

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.
```
+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
```
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.
```
+----------+
| Employee |
+----------+
| Joe      |
+----------+
```
---------------------
```
SELECT e1.Name as Employee
FROM Employee e1
INNER JOIN Employee e2
ON e1.ManagerId = e2.Id
WHERE e1.Salary > e2.Salary
```

### Problem 5: 从来不买的顾客

Suppose that a website contains two tables, the Customers table and the Orders table. Write a SQL query to find all customers who never order anything.

Table: Customers.
```
+----+-------+
| Id | Name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
```
Table: Orders.
```
+----+------------+
| Id | CustomerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
```
Using the above tables as example, return the following:
```
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
```
Answer:
```
SELECT Name as Customers
FROM Customers
WHERE Id NOT in
(SELECT DISTINCT CustomerId
 FROM Orders
)
```

### Problem 6: 升高的温度
Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.
```
+---------+------------+------------------+
| Id(INT) | Date(DATE) | Temperature(INT) |
+---------+------------+------------------+
|       1 | 2015-01-01 |               10 |
|       2 | 2015-01-02 |               25 |
|       3 | 2015-01-03 |               20 |
|       4 | 2015-01-04 |               30 |
+---------+------------+------------------+
```
For example, return the following Ids for the above Weather table:
```
+----+
| Id |
+----+
|  2 |
|  4 |
+----+
```

```
SELECT Id
FROM Weather as w1
JOIN Weather as w2
ON datediff(w1.Date,w2.Date) = 1
and w1.Temporature > w2.Temporature
```

### Problem 7: 学生人数超过5个的班级
There is a table courses with columns: student and class

Please list out all classes which have more than or equal to 5 students.

For example, the table:
```
+---------+------------+
| student | class      |
+---------+------------+
| A       | Math       |
| B       | English    |
| C       | Math       |
| D       | Biology    |
| E       | Math       |
| F       | Computer   |
| G       | Math       |
| H       | Math       |
| I       | Math       |
+---------+------------+
```
Should output:
```
+---------+
| class   |
+---------+
| Math    |
+---------+
```

```
SELECT class
FROM courses
GROUP BY class
HAVING COUNT(DINSTINCT student) >= 5
```

### Problem 8: 删除重复的邮件。
```
DELETE p1
FROM Person p1
INNER JOIN Person p2
ON p1.Email = p2.Email AND p1.Id > p2.Id
```
### Problem 9: 第二高的薪水。

Write a SQL query to get the second highest salary from the Employee table.
```
+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
```
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.
```
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
```

Method 1: Use Rank function
```
SELECT Salary as SecondHighestSalary, DENSE_RANK() OVER(ORDER BY Salary DESC) as rnk
FROM Employee
WHERE rnk = 2
```
Method 2: Use limit function (simple syntax)
```
SELECT T.Salary as SecondHighestSalary
FROM
(SELECT Salary
 FROM Employee
 ORDER BY Salary DESC LIMIT 2)
AS T
ORDER BY T.Salary ASC LIMIT 1  
```
Method 3: Use limit function (advanced syntax)
```
SELECT Salary as SecondHighestSalary
FROM Employee
ORDER BY Salary DESC
LIMIT 1,1
```
Method 4: Max
```
select max(Salary) as SecondHighestSalary
from Employee
where Salary != (select max(Salary) from Employee)
```

### Problem 9: 成绩排序。

Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

```
+----+-------+
| Id | Score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
```
For example, given the above Scores table, your query should generate the following report (order by highest score):
```
+-------+------+
| Score | Rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+
```
Method 1: By window function
```
SELECT Score, DENSE_RANK() OVER(ORDER BY Score DESC) as "Rank"
FROM Scores
```
Method 2: By self join
```
SELECT s1.Score, count(DISTINCT s2.Score) as "RANK"
FROM Scores s1
JOIN Scores s2
ON s1.Score<=s2.Score
GROUP BY s1.Id
ORDER BY s1.Score DESC
```

### Problem 10: 连续数字
Write a SQL query to find all numbers that appear at least three times consecutively.
```
+----+-----+
| Id | Num |
+----+-----+
| 1  |  1  |
| 2  |  1  |
| 3  |  1  |
| 4  |  2  |
| 5  |  1  |
| 6  |  2  |
| 7  |  2  |
+----+-----+
```
For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.
```
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
```
产生一个行数为7*7*7的table
```
SELECT DISTINCT Num
FROM Logs a, Logs b, Logs c
WHERE a.Id = b.Id - 1
AND b.Id = c.Id - 1
AND a.Num = b.Num
AND b.Num = c.Num
```

### Problem 11: 部门最高薪水

The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.
```
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
```
The Department table holds all departments of the company.
```
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```
Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.
```
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| Sales      | Henry    | 80000  |
+------------+----------+--------+
```

```
SELECT t2.Name as Department, t1.Name as Employee, Max(t1.Salary)
FROM Employee t1
JOIN Department t2
ON t1.DepartmentId = t2.Id
GROUP BY Department
```

```
select d.Name as Department,e.Name as Employee, e.Salary
from Employee as e inner join Department as d
on e.DepartmentId = d.Id
where (e.DepartmentId,e.salary) in (select DepartmentId,max(Salary) from Employee group by DepartmentId)
```

# References
- [SQL](https://blog.csdn.net/wstcjf/article/details/77996594)
