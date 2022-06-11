CREATE TABLE departments
(
id BIGINT,
name VARCHAR(20),
dept_name VARCHAR(20),
seniority VARCHAR(20),
graduation CHAR (3),
salary BIGINT,
hire_date DATE
);

INSERT departments VALUES
 (10238,  'Eric'    , 'Economics'        , 'Experienced'  , 'MSc'      ,   72000 ,  '2019-12-01')
,(13378,  'Karl'    , 'Music'            , 'Candidate'    , 'BSc'      ,   42000 ,  '2022-01-01')
,(23493,  'Jason'   , 'Philosophy'       , 'Candidate'    , 'MSc'      ,   45000 ,  '2022-01-01')
,(36299,  'Jane'    , 'Computer Science' , 'Senior'       , 'PhD'      ,   91000 ,  '2018-05-15')
,(30766,  'Jack'    , 'Economics'        , 'Experienced'  , 'BSc'      ,   68000 ,  '2020-04-06')
,(40284,  'Mary'    , 'Psychology'       , 'Experienced'  , 'MSc'      ,   78000 ,  '2019-10-22')
,(43087,  'Brian'   , 'Physics'          , 'Senior'       , 'PhD'      ,   93000 ,  '2017-08-18')
,(53695,  'Richard' , 'Philosophy'       , 'Candidate'    , 'PhD'      ,   54000 ,  '2021-12-17')
,(58248,  'Joseph'  , 'Political Science', 'Experienced'  , 'BSc'      ,   58000 ,  '2021-09-25')
,(63172,  'David'   , 'Art History'      , 'Experienced'  , 'BSc'      ,   65000 ,  '2021-03-11')
,(64378,  'Elvis'   , 'Physics'          , 'Senior'       , 'MSc'      ,   87000 ,  '2018-11-23')
,(96945,  'John'    , 'Computer Science' , 'Experienced'  , 'MSc'      ,   80000 ,  '2019-04-20')
,(99231,  'Santosh'	,'Computer Science'  ,'Experienced'   ,'BSc'       ,  74000  , '2020-05-07' )
;

SELECT * FROM departments

SELECT dept_name, AVG(salary) AS AVG_Salary
FROM departments
GROUP BY dept_name

SELECT dept_name, AVG(salary) AS AVG_Salary
FROM departments
GROUP BY dept_name
HAVING AVG(salary) > 50000

/* Grouping Sets Example */

SELECT seniority, graduation, AVG(salary)
FROM departments
GROUP BY
	GROUPING SETS(
	(seniority, graduation),
	(graduation),
	(seniority))
ORDER BY seniority DESC, graduation DESC;

/* Pivot Example */

SELECT [seniority], [BSc], [MSc], [PhD]
FROM 
(
SELECT seniority, graduation, salary
FROM   departments
) AS SourceTable
PIVOT 
(
 avg(salary)
 FOR graduation
 IN ([BSc], [MSc], [PhD])
) AS pivot_table;

SELECT [dept_name], [Experienced], [Candidate], [Senior] 
FROM (SELECT [dept_name], seniority, salary
		FROM departments) AS SOURCE_TABLE
PIVOT(
AVG(salary)
FOR seniority
IN ([Experienced], [Candidate], [Senior])) AS pivot_table

/* Rollup Example */

SELECT seniority, graduation, AVG(salary)
FROM departments
GROUP BY
	ROLLUP(seniority, graduation);

/*CUBE example*/

SELECT seniority, graduation, AVG(salary)
FROM departments
GROUP BY
	CUBE(seniority, graduation)
ORDER BY seniority, graduation;

/* CHECK YOURSELF: ADVANCED GROUPING OPERATIONS */

/* QUESTION 1: Write a query that returns the count of orders of each day between 
'2020-01-19' and '2020-01-25'. Report the result using Pivot Table.

Note: The column names should be day names (Sun, Mon, etc.).

(Use SampleRetail DB on SQL Server and paste the result in the answer box.) */

/* SOURCE TABLE */

SELECT order_id, DATENAME(DW, order_date) AS DAY_ FROM sale.orders
	WHERE order_date BETWEEN '2020-01-19' AND '2020-01-25'

/* PIVOT TABLO OLUÞTURMA */

-- source tabloya aggregate fonksiyon uygulayacaðýmýz sütun ile
-- gruplayacaðýmýz sütun isimlerini yazýyoruz.

SELECT *
FROM (SELECT order_id, DATENAME(DW, order_date) AS DAY_ FROM sale.orders
	WHERE order_date BETWEEN '2020-01-19' AND '2020-01-25') AS A
PIVOT (
	COUNT(A.order_id)
	FOR A.DAY_
	IN ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
) AS pivot_table;

/* QUESTION 2: Please write a query to return only the order ids that have an
average amount of more than $2000.
Your result set should include order_id. Sort the order_id in ascending order.

(Use SampleRetail DB on SQL Server and paste the result in the answer box.) */

SELECT order_id, AVG((list_price*quantity)*(1-discount))
FROM sale.order_item
GROUP BY order_id
HAVING AVG((list_price*quantity)*(1-discount)) > 2000

SELECT order_id, AVG(list_price*quantity)
FROM sale.order_item
GROUP BY order_id
HAVING AVG(list_price*quantity) > 2000
