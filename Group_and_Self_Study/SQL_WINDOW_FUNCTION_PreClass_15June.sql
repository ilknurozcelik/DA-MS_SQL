/* WINDOW FUNCTIONS */

/* A window function is an SQL function where the input values are taken from a "window"
of one or more rows in the results set of a SELECT statement. */

/*Window functions are distinguished from other SQL functions by the presence of an OVER clause.
If a function has an OVER clause, then it is a window function. If it lacks an OVER clause,
then it is an ordinary aggregate or scalar function. Window functions might also have a FILTER
clause in between the function and the OVER clause. */

/* WINDOW FUNCTION SYNTAX:

window_function (expression) OVER (
[ PARTITION BY expr_list ]
[ ORDER BY order_list ] [ frame_clause ])

*/

/* The OVER() clause can take the following clauses to extend its functionality:

PARTITION BY clause: Defines window partitions to form groups of rows
ORDER BY clause: Orders rows within a partition
ROW or RANGE clause: Defines the scope of the function

*/


/* We can group window functions into three categories:

Aggregate Window Functions

	MIN(), MAX(), AVG(), SUM(), COUNT()

Ranking Window Functions

	ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE(), CUME_DIST(), PERCENT_RANK()

Value Window Functions

	FIRST_VALUE(), LAST_VALUE(), LEAD(), LAG()

*/


/* AGGREGATE WINDOW FUNCTIONS */

SELECT *
FROM departments

SELECT graduation, COUNT(id) OVER() AS COUNT_EMPLOYEE
FROM departments
--As you see, the whole table records were returned for the graduation column



-- If you use DISTINCT keyword like the query below, you would be get rid of duplicate rows.
SELECT DISTINCT graduation, COUNT(id) OVER() AS COUNT_EMPLOYEE
FROM departments


-- If we use PARTITION BY with DISTINCT keyword like below:
SELECT DISTINCT graduation, COUNT(graduation) OVER(PARTITION BY graduation) AS COUNT_EMPLOYEE
FROM departments
--As you see above, the query returned the count of employees according to graduation.

/* Tip:

PARTITION BY specifies partitions on which a window function operates. The window function is
applied to each partition separately and computation restarts for each partition.
If we don't include PARTITION BY, the window function operates on the whole column.

*/

-- What if we use only ORDER BY in the parentheses? Let's try and see it.

SELECT hire_date, COUNT(id) OVER (ORDER BY hire_date) AS CNT_EMPLOYEE
FROM departments

/* You see that when we don't include the ORDER BY we get total
when we include ORDER BY we get running total/cumulative total.

You don't have to use ORDER BY with aggregate window functions.
But that's important to know what happened when you use ORDER BY with aggregate functions.

*/

/* RANKING WINDOW FUNCTIONS */

/*

CUME_DIST : Compute the cumulative distribution of a value in an ordered set of values.

DENSE_RANK : Compute the rank for a row in an ordered set of rows with no gaps in rank values.

NTILE : Divide a result set into a number of buckets as evenly as possible and assign a bucket
	number to each row.

PERCENT_RANK : Calculate the percent rank of each row in an ordered set of rows.

RANK : Assign a rank to each row within the partition of the result set.

ROW_NUMBER : Assign a sequential integer starting from one to each row within the current partition.

*/

SELECT name, RANK() OVER(ORDER BY hire_date DESC) AS rank_duration
FROM departments;

-- RANK() function assigns the same rank number if the hire_date value is same. 

SELECT name, DENSE_RANK() OVER(ORDER BY hire_date DESC) AS rank_duration
FROM departments;

SELECT name, seniority, hire_date, ROW_NUMBER() OVER(PARTITION BY seniority ORDER BY hire_date) AS "row_number"
FROM departments;

-- Note: We must use ORDER BY with ranking window functions.

/* VALUE WINDOW FUNCTIONS */
/*
FIRST_VALUE : Get the value of the first row in a specified window frame.

LAG : Provide access to a row at a given physical offset that comes before the current row.

LAST_VALUE : Get the value of the last row in a specified window frame.

LEAD : Provide access to a row at a given physical offset that follows the current row.

*/

/* LAG() and LEAD() functions are useful to compare rows to preceding or following rows.
LAG returns data from previous rows and LEAD returns data from the following rows. */


/* Syntax of the LAG and LEAD function  */

--LAG(column_name [,offset] [,default])

--LEAD(column_name [,offset] [,default])

/* offset: Optional. It specifies the number of rows back from the current row from which
to obtain a value. If not given, the default is 1. In that case, it returns the value of
the previous value. If there is no previous row (the current row is the first), then returns
NULL. Offset value must be a non-negative integer. */

/* default: The value to return when the offset is beyond the scope of the partition.
If a default value is not specified, NULL is returned. */

SELECT id, name, LAG(name) OVER(ORDER BY id) as previous_name
FROM departments;

SELECT id, name, LEAD(name) OVER (ORDER BY id) AS next_name
FROM departments;

/*If you want to access two rows back from the current row, you need to specify the offset
argument 2. The following query displays the values two rows back from the current row. */

SELECT id, name, LAG(name, 2) OVER(ORDER BY id) as previous_name  -- offset:2
FROM departments;

SELECT id, name, FIRST_VALUE(name) OVER(ORDER BY id) as first_name 
FROM departments;

SELECT id, name, LAST_VALUE(name) OVER(ORDER BY id) as last_name 
FROM departments;

/* As you see, for each row, FIRST_VALUE() function returns the first value from the whole
name column sorted by id.*/

/* Because the default window frame covered all of the rows for each row. */

SELECT id, name,
	LAST_VALUE(name) OVER(ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_name
FROM departments;

/* In the example above, for each row, LAST_VALUE() function returns the last value from
the whole name column sorted by id. */

/* We change the window frame. Because the default window frame didn't cover all of the rows
for each row. */



SELECT id, name,
	LAST_VALUE(name) OVER(ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS las_name
FROM departments;


/* WINDOW FRAMES */

/* By default, a window is set for each row to encompass all the rows from the first to
the current row in the partition.

However, this is the default and can be adjusted using the window frame clause.

A window function query using the window frame clause would look as follows:
*/

-- frame syntax :

/*
SELECT {columns},
{window_func} OVER (PARTITION BY {partition_key} ORDER BY {order_key}
{rangeorrows} BETWEEN {frame_start} AND {frame_end})
FROM {table1};
*/

/*
Here,

{columns} are the columns to retrieve from tables for the query,

{window_func} is the window function you want to use,

{partition_key} is the column or columns you want to partition on (more on this later),

{order_key} is the column or columns you want to order by,

{rangeorrows} is either the RANGE keyword or the  ROWS keyword,

{frame_start} is a keyword indicating where to start the window frame,

{frame_end} is a keyword indicating where to end the window frame

*/

/* Commonly Used Framing Syntax */

/* ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW	
meaning : Start at row 1 of the partition and include rows up to the current row. */

/* ROWS UNBOUNDED PRECEDING	
meaning : Start at row 1 of the partition and include rows up to the current row. */

/* ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
meaning : Start at the current row and include rows up to the end of the partition. */

/* ROWS BETWEEN N PRECEDING AND CURRENT ROW
meaning : Start at a specified number of rows before the current row and include rows
up to the current row. */

/* ROWS BETWEEN CURRENT ROW AND N FOLLOWING
meaning : Start at the current row and include rows up to a specified number of rows following
the current row. */

/* ROWS BETWEEN N PRECEDING AND N FOLLOWING
meaning : Start at a specified number of rows before the current row and include a specified
number of rows following the current row. Yes, the current row is also included. */

/* CHECK YOURSELF */

/*QUESTION 1:

List the employee's first order dates by month in 2020.
Expected columns are: first name, last name, month and the first order date.
(last name and month in ascending order) */

-- group by ile

select staff_id, month(order_date) month_, min(order_date) first_order_date
from sale.orders
where year(order_date) = 2020
group by staff_id, month(order_date)
order by staff_id, month(order_date)


-- window func. ile

select distinct staff_id, month(order_date) month_,
	min(order_date) over(partition by staff_id, month(order_date) order by month(order_date)) first_order_date
from sale.orders
where year(order_date) = 2020


-- staff isimlerini de getirelim

select distinct first_name, SS.last_name, month(SO.order_date) month_,
	min(SO.order_date) over(partition by SS.staff_id, month(SO.order_date) order by month(SO.order_date)) first_order_date
from sale.orders AS SO, sale.staff AS SS
where year(order_date) = 2020 AND
	SO.staff_id=SS.staff_id
order by SS.last_name, month_

/*QUESTION 2:

Write a query using the window function that returns staffs' first name, last name
and their total net amount of orders in descending order. */

--group by ile
select SS.first_name, SS.last_name, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) net_amount_of_orders
from sale.order_item AS SOI, sale.orders AS SO, sale.staff AS SS
where SOI.order_id=SO.order_id AND
	SO.staff_id=SS.staff_id
group by SS.first_name, SS.last_name
order by SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) desc

--window fucnc. ile
select distinct SS.first_name, SS.last_name,
	SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) over(partition by SS.first_name, SS.last_name) as net_amount_of_orders
from sale.order_item AS SOI, sale.orders AS SO, sale.staff AS SS
where SOI.order_id=SO.order_id AND
	SO.staff_id=SS.staff_id
order by net_amount_of_orders desc


/*QUESTION 3:

Write a query using the window function that returns the cumulative total turnovers of the
Burkes Outlet by order date between "2019-04-01" and "2019-04-30".

Columns that should be listed are: 'order_date' in ascending order and 'Cumulative_Total_Price'. */

-- group by ile tarih bazýnda toplam satýþlarý bulalým. cumulative toplamlarý bulmak için window fuc. kullanmak gerekir.

select SO.order_date, SUM(list_price*quantity) as total
from sale.orders as SO, sale.order_item as SOI, sale.store as SS
where SO.order_id = SOI.order_id AND
	SO.store_id = SS.store_id AND
	SS.store_name = 'Burkes Outlet' AND
	SO.order_date BETWEEN '2019-04-01' AND '2019-04-30'
group by SO.order_date


-- window func. ile cumulative total deðerlerini bulmak için

select distinct SO.order_date,
	SUM(list_price*quantity) over (order by SO.order_date)
from sale.orders as SO, sale.order_item as SOI, sale.store as SS
where SO.order_id = SOI.order_id AND
	SO.store_id = SS.store_id AND
	SS.store_name = 'Burkes Outlet' AND
	SO.order_date BETWEEN '2019-04-01' AND '2019-04-30'

















