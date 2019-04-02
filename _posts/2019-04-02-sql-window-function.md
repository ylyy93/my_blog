---
layout: post
title: SQL Window Function
date: 2019-04-02 10:01 -0600
categories: Tech
tags: [SQL]
---

###### Window function

Window function performs a calculation across a set of table rows that are somehow related to the current row.

1.`Order by` running (以整个dataset为window，以`order by`后面的column为group)

```
+---------+
|+-------+|
||+-----+||
|||     |||
|||     |||
|||     |||
||+-----+||
||       ||
||       ||
|+-------+|
|         |
|         |
+---------+
```

```
SELECT col1, col3
       SUM(col2)
       OVER (ORDER BY col3)
       AS running_total
FROM a
```

|col1|col3|running_total|
|---|---|---|
|1|1|475|
|2|2|2782|
|3|2|2782|
|4|3|3738|
|5|3|3738|

以`col3`为单位进行`cumsum`.

2.Partition by (以`partition by`后面的column为window，以`order by`后面的column为group)

```
+---------+
|         |
|         |
+---------+
+---------+
|         |
|         |
+---------+
+---------+
|         |
|         |
+---------+
```


```
SELECT col1,col3,
  SUM(col2)
  OVER (PARTITION BY col1
        ORDER BY col3)
  AS running_total
FROM a
WHERE ...  
```

|col1|col3|running_total|
|---|---|---|
|1|1|475|
|1|2|2782|
|1|2|2782|
|2|1|338|
|2|1|338|

先以`col1`分区，在每个区内以`col3`为单位进行`cumsum`.

2.1 如果只有`partition by`,则只进行分区操作。
2.2 如果连`partition by`都没有，只有`over()`,那就是对整个dataset操作。

3.Type of window functions

Example Table:
```
  +-----------------+-----------------+------------+--------+
  |    emp_name     |     emp_mgr     | dealer_id  | sales  |
  +-----------------+-----------------+------------+--------+
  | Beverly Lang    | Mike Palomino   | 2          | 16233  |
  | Kameko French   | Mike Palomino   | 2          | 16233  |
  | Ursa George     | Rich Hernandez  | 3          | 15427  |
  | Ferris Brown    | Dan Brodi       | 1          | 19745  |
  | Noel Meyer      | Kari Phelps     | 1          | 19745  |
  | Abel Kim        | Rich Hernandez  | 3          | 12369  |
  | Raphael Hull    | Kari Phelps     | 1          | 8227   |
  | Jack Salazar    | Kari Phelps     | 1          | 9710   |
  | May Stout       | Rich Hernandez  | 3          | 9308   |
  | Haviva Montoya  | Mike Palomino   | 2          | 9308   |
  +-----------------+-----------------+------------+--------+
```
3.1 Value

- FIRST_VALUE()

```
select emp_name, dealer_id, sales, first_value(sales) over (partition by dealer_id order by sales) as dealer_low from q1_sales;
   +-----------------+------------+--------+-------------+
   |    emp_name     | dealer_id  | sales  | dealer_low  |
   +-----------------+------------+--------+-------------+
   | Raphael Hull    | 1          | 8227   | 8227        |
   | Jack Salazar    | 1          | 9710   | 8227        |
   | Ferris Brown    | 1          | 19745  | 8227        |
   | Noel Meyer      | 1          | 19745  | 8227        |
   | Haviva Montoya  | 2          | 9308   | 9308        |
   | Beverly Lang    | 2          | 16233  | 9308        |
   | Kameko French   | 2          | 16233  | 9308        |
   | May Stout       | 3          | 9308   | 9308        |
   | Abel Kim        | 3          | 12369  | 9308        |
   | Ursa George     | 3          | 15427  | 9308        |
   +-----------------+------------+--------+-------------+
   10 rows selected (0.299 seconds)
```

- LAG()
```
select cust_id, `date`, qty_sold, lag(qty_sold,1) over (order by cust_id, `date`) as prev_qtysold from sales where cust_id = 8 order by cust_id, `date`;  

   +----------+-------------+-----------+---------------+
   | cust_id  |    date     | qty_sold  | prev_qtysold  |
   +----------+-------------+-----------+---------------+
   | 8        | 1976-01-25  | 2         | null          |
   | 8        | 1981-02-04  | 5         | 2             |
   | 8        | 1982-08-09  | 2         | 5             |
   | 8        | 1983-02-12  | 1         | 2             |
   | 8        | 1984-02-10  | 9         | 1             |
   +----------+-------------+-----------+---------------+
   5 rows selected (0.331 seconds)
```
- LAST_VALUE()

```
select emp_name, dealer_id, sales, `year`, last_value(sales) over (partition by  emp_name order by `year`) as last_sale from emp_sales where `year` = 2013;
+-----------------+------------+--------+-------+------------+
|    emp_name     | dealer_id  | sales  | year  | last_sale  |
+-----------------+------------+--------+-------+------------+
| Beverly Lang    | 2          | 5324   | 2013  | 5324       |
| Ferris Brown    | 1          | 22003  | 2013  | 22003      |
| Haviva Montoya  | 2          | 6345   | 2013  | 13100      |
| Haviva Montoya  | 2          | 13100  | 2013  | 13100      |
| Kameko French   | 2          | 7540   | 2013  | 7540       |
| May Stout       | 2          | 4924   | 2013  | 15000      |
| May Stout       | 2          | 8000   | 2013  | 15000      |
| May Stout       | 2          | 15000  | 2013  | 15000      |
| Noel Meyer      | 1          | 13314  | 2013  | 13314      |
| Raphael Hull    | 1          | -4000  | 2013  | 14000      |
| Raphael Hull    | 1          | 14000  | 2013  | 14000      |
| Ursa George     | 1          | 10865  | 2013  | 10865      |
+-----------------+------------+--------+-------+------------+
12 rows selected (0.284 seconds)
```
- LEAD()
```
select show_id, `date`, commission, lead(commission,1) over (order by `date`) as next_comm from commission where show_id = 172;
  +----------+-------------+-------------+------------+
  | show_id  |    date     | commission  | next_comm  |
  +----------+-------------+-------------+------------+
  | 172      | 1979-01-01  | 29.20       | 29.50      |
  | 172      | 1979-01-01  | 29.50       | 8.25       |
  | 172      | 1979-01-01  | 8.25        | 15.50      |
  | 172      | 1979-01-01  | 15.50       | 10.25      |
  | 172      | 1979-01-01  | 10.25       | 4.40       |
  | 172      | 1979-01-01  | 4.40        | 80.20      |
  | 172      | 1979-01-01  | 80.20       | 90.10      |
  | 172      | 1979-01-02  | 90.10       | 25.50      |
  | 172      | 1979-01-02  | 25.50       | 50.00      |
  | 172      | 1979-01-02  | 50.00       | 20.20      |
  | 172      | 1979-01-02  | 20.20       | 40.00      |
  | 172      | 1979-01-02  | 40.00       | null       |
  +----------+-------------+-------------+------------+
  12 rows selected (0.241 seconds)
```

3.1.1 Use lag to define difference

```
SELECT *
  FROM (
    SELECT start_terminal,
           duration_seconds,
           duration_seconds -LAG(duration_seconds, 1) OVER
             (PARTITION BY start_terminal ORDER BY duration_seconds)
             AS difference
      FROM tutorial.dc_bikeshare_q1_2012
     WHERE start_time < '2012-01-08'
     ORDER BY start_terminal, duration_seconds
       ) sub
 WHERE sub.difference IS NOT NULL
```

3.2 Aggregate

- AVG()
```
select dealer_id, sales, avg(sales) over (partition by dealer_id) as avgsales from q1_sales;
+------------+--------+-----------+
| dealer_id  | sales  | avgsales  |
+------------+--------+-----------+
| 1          | 19745  | 14357     |
| 1          | 19745  | 14357     |
| 1          | 8227   | 14357     |
| 1          | 9710   | 14357     |
| 2          | 16233  | 13925     |
| 2          | 16233  | 13925     |
| 2          | 9308   | 13925     |
| 3          | 15427  | 12368     |
| 3          | 12369  | 12368     |
| 3          | 9308   | 12368     |
+------------+--------+-----------+
10 rows selected (0.455 seconds)
```
- COUNT()

```
select dealer_id, sales, count(*) over(order by dealer_id) as `count` from q1_sales;
+------------+--------+--------+
| dealer_id  | sales  | count  |
+------------+--------+--------+
| 1          | 19745  | 4      |
| 1          | 19745  | 4      |
| 1          | 8227   | 4      |
| 1          | 9710   | 4      |
| 2          | 16233  | 7      |
| 2          | 16233  | 7      |
| 2          | 9308   | 7      |
| 3          | 15427  | 10     |
| 3          | 12369  | 10     |
| 3          | 9308   | 10     |
+------------+--------+--------+
10 rows selected (0.215 seconds)
```

- MAX()
- MIN()
```
select emp_name, dealer_id, sales, min(sales) over(partition by dealer_id) as `min` from q1_sales;
+-----------------+------------+--------+-------+
|    emp_name     | dealer_id  | sales  |  min  |
+-----------------+------------+--------+-------+
| Ferris Brown    | 1          | 19745  | 8227  |
| Noel Meyer      | 1          | 19745  | 8227  |
| Raphael Hull    | 1          | 8227   | 8227  |
| Jack Salazar    | 1          | 9710   | 8227  |
| Beverly Lang    | 2          | 16233  | 9308  |
| Kameko French   | 2          | 16233  | 9308  |
| Haviva Montoya  | 2          | 9308   | 9308  |
| Ursa George     | 3          | 15427  | 9308  |
| Abel Kim        | 3          | 12369  | 9308  |
| May Stout       | 3          | 9308   | 9308  |
+-----------------+------------+--------+-------+
10 rows selected (0.194 seconds)
```
- SUM()

```
select dealer_id, emp_name, sales, sum(sales) over(partition by dealer_id) as `sum` from q1_sales;
+------------+-----------------+--------+--------+
| dealer_id  |    emp_name     | sales  |  sum   |
+------------+-----------------+--------+--------+
| 1          | Ferris Brown    | 19745  | 57427  |
| 1          | Noel Meyer      | 19745  | 57427  |
| 1          | Raphael Hull    | 8227   | 57427  |
| 1          | Jack Salazar    | 9710   | 57427  |
| 2          | Beverly Lang    | 16233  | 41774  |
| 2          | Kameko French   | 16233  | 41774  |
| 2          | Haviva Montoya  | 9308   | 41774  |
| 3          | Ursa George     | 15427  | 37104  |
| 3          | Abel Kim        | 12369  | 37104  |
| 3          | May Stout       | 9308   | 37104  |
+------------+-----------------+--------+--------+
10 rows selected (0.198 seconds)
```
3.3 Ranking

- CUME_DIST()
```
select dealer_id, sales, cume_dist() over(order by sales) as cumedist from q1_sales;
+------------+--------+-----------+
| dealer_id  | sales  | cumedist  |
+------------+--------+-----------+
| 1          | 8227   | 0.1       |
| 3          | 9308   | 0.3       |
| 2          | 9308   | 0.3       |
| 1          | 9710   | 0.4       |
| 3          | 12369  | 0.5       |
| 3          | 15427  | 0.6       |
| 2          | 16233  | 0.8       |
| 2          | 16233  | 0.8       |
| 1          | 19745  | 1.0       |
| 1          | 19745  | 1.0       |
+------------+--------+-----------+
10 rows selected (0.241 seconds)  
```
- DENSE_RANK
```
select dealer_id, emp_name, sales, dense_rank() over(order by sales) as denserank from q1_sales;
+------------+-----------------+--------+------------+
| dealer_id  |    emp_name     | sales  | denserank  |
+------------+-----------------+--------+------------+
| 1          | Raphael Hull    | 8227   | 1          |
| 3          | May Stout       | 9308   | 2          |
| 2          | Haviva Montoya  | 9308   | 2          |
| 1          | Jack Salazar    | 9710   | 3          |
| 3          | Abel Kim        | 12369  | 4          |
| 3          | Ursa George     | 15427  | 5          |
| 2          | Beverly Lang    | 16233  | 6          |
| 2          | Kameko French   | 16233  | 6          |
| 1          | Ferris Brown    | 19745  | 7          |
| 1          | Noel Meyer      | 19745  | 7          |
+------------+-----------------+--------+------------+
10 rows selected (0.198 seconds)  
```
- NTILE()
```
select emp_mgr, sales, ntile(5) over(order by sales) as ntilerank from q1_sales;
+-----------------+--------+------------+
|     emp_mgr     | sales  | ntilerank  |
+-----------------+--------+------------+
| Kari Phelps     | 8227   | 1          |
| Rich Hernandez  | 9308   | 1          |
| Kari Phelps     | 9710   | 2          |
| Rich Hernandez  | 12369  | 2          |
| Mike Palomino   | 13181  | 3          |
| Rich Hernandez  | 15427  | 3          |
| Kari Phelps     | 15547  | 4          |
| Mike Palomino   | 16233  | 4          |
| Dan Brodi       | 19745  | 5          |
| Mike Palomino   | 23176  | 5          |
+-----------------+--------+------------+
10 rows selected (0.149 seconds)
```
```
select emp_mgr, dealer_id, sales, ntile(3) over(partition by dealer_id order by sales) as ntilerank from q1_sales;
+-----------------+------------+--------+------------+
|     emp_mgr     | dealer_id  | sales  | ntilerank  |
+-----------------+------------+--------+------------+
| Kari Phelps     | 1          | 8227   | 1          |
| Kari Phelps     | 1          | 9710   | 1          |
| Kari Phelps     | 1          | 15547  | 2          |
| Dan Brodi       | 1          | 19745  | 3          |
| Mike Palomino   | 2          | 13181  | 1          |
| Mike Palomino   | 2          | 16233  | 2          |
| Mike Palomino   | 2          | 23176  | 3          |
| Rich Hernandez  | 3          | 9308   | 1          |
| Rich Hernandez  | 3          | 12369  | 2          |
| Rich Hernandez  | 3          | 15427  | 3          |
+-----------------+------------+--------+------------+
10 rows selected (0.312 seconds)
```
- PERCENT_RANK()

```
select dealer_id, emp_name, sales, percent_rank() over(order by sales) as perrank from q1_sales;
+------------+-----------------+--------+---------------------+
| dealer_id  |    emp_name     | sales  |       perrank       |
+------------+-----------------+--------+---------------------+
| 1          | Raphael Hull    | 8227   | 0.0                 |
| 3          | May Stout       | 9308   | 0.1111111111111111  |
| 2          | Haviva Montoya  | 9308   | 0.1111111111111111  |
| 1          | Jack Salazar    | 9710   | 0.3333333333333333  |
| 3          | Abel Kim        | 12369  | 0.4444444444444444  |
| 3          | Ursa George     | 15427  | 0.5555555555555556  |
| 2          | Beverly Lang    | 16233  | 0.6666666666666666  |
| 2          | Kameko French   | 16233  | 0.6666666666666666  |
| 1          | Ferris Brown    | 19745  | 0.8888888888888888  |
| 1          | Noel Meyer      | 19745  | 0.8888888888888888  |
+------------+-----------------+--------+---------------------+
10 rows selected (0.169 seconds)

```
- RANK()
```
select dealer_id, emp_name, sales, rank() over(order by sales) as `rank` from q1_sales;
+------------+-----------------+--------+-------+
| dealer_id  |    emp_name     | sales  | rank  |
+------------+-----------------+--------+-------+
| 1          | Raphael Hull    | 8227   | 1     |
| 3          | May Stout       | 9308   | 2     |
| 2          | Haviva Montoya  | 9308   | 2     |
| 1          | Jack Salazar    | 9710   | 4     |
| 3          | Abel Kim        | 12369  | 5     |
| 3          | Ursa George     | 15427  | 6     |
| 2          | Beverly Lang    | 16233  | 7     |
| 2          | Kameko French   | 16233  | 7     |
| 1          | Ferris Brown    | 19745  | 9     |
| 1          | Noel Meyer      | 19745  | 9     |
+------------+-----------------+--------+-------+
10 rows selected (0.174 seconds)
```
- ROW_NUMBER()
```
select dealer_id, emp_name, sales, row_number() over(partition by dealer_id order by sales) as `rownum` from q1_sales;
+------------+-----------------+--------+---------+
| dealer_id  |    emp_name     | sales  | rownum  |
+------------+-----------------+--------+---------+
| 1          | Raphael Hull    | 8227   | 1       |
| 1          | Jack Salazar    | 9710   | 2       |
| 1          | Ferris Brown    | 19745  | 3       |
| 1          | Noel Meyer      | 19745  | 4       |
| 2          | Haviva Montoya  | 9308   | 1       |
| 2          | Beverly Lang    | 16233  | 2       |
| 2          | Kameko French   | 16233  | 3       |
| 3          | May Stout       | 9308   | 1       |
| 3          | Abel Kim        | 12369  | 2       |
| 3          | Ursa George     | 15427  | 3       |
+------------+-----------------+--------+---------+
10 rows selected (0.241 seconds)
```

4.Window Alias
```
SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER ntile_window AS quartile,
       NTILE(5) OVER ntile_window AS quintile,
       NTILE(100) OVER ntile_window AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
WINDOW ntile_window AS
         (PARTITION BY start_terminal ORDER BY duration_seconds)
 ORDER BY start_terminal, duration_seconds
```
# References
- [Mode](https://mode.com/resources/sql-tutorial/sql-window-functions/)
- [SQL Window Functions Introduction](https://drill.apache.org/docs/sql-window-functions-introduction/)
