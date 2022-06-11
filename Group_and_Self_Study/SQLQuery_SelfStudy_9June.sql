SELECT CITY, SUM(TOTALPRICE)
FROM SALES
GROUP BY CITY
HAVING SUM(TOTALPRICE) < 40000
ORDER BY SUM(TOTALPRICE) DESC

SELECT CITY, SUM(TOTALPRICE)
FROM SALES
WHERE CITY IN('ANKARA','ÝSTANBUL','ÝZMÝR','AYDIN','HATAY')
GROUP BY CITY
HAVING SUM(TOTALPRICE) < 40000
ORDER BY SUM(TOTALPRICE) DESC

SELECT CITY, SUM(TOTALPRICE), COUNT(DISTINCT CUSTOMERNAME) AS CUSTOMERCOUNT
FROM SALES
GROUP BY CITY
HAVING COUNT(DISTINCT CUSTOMERNAME) > 500
ORDER BY SUM(TOTALPRICE) DESC

SELECT CITY, SUM(TOTALPRICE), COUNT(DISTINCT CUSTOMERNAME) AS CUSTOMERCOUNT
FROM SALES
GROUP BY CITY
HAVING COUNT(DISTINCT CUSTOMERNAME) > 500 AND SUM(TOTALPRICE) > 300000
ORDER BY SUM(TOTALPRICE) DESC



/* CREATE EMPLOYEES_A TABLE */

CREATE TABLE employees_A
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);

/*INSERT VALUES TO EMPLOYEES_A TABLE */

INSERT employees_A VALUES
 (17679,  'Robert'    , 'Gilmore'       ,   110000 ,  'Operations Director', 'Male')
,(26650,  'Elvis'    , 'Ritter'        ,   86000 ,  'Sales Manager', 'Male')
,(30840,  'David'   , 'Barrow'        ,   85000 ,  'Data Scientist', 'Male')
,(49714,  'Hugo'    , 'Forester'    ,   55000 ,  'IT Support Specialist', 'Male')
,(51821,  'Linda'    , 'Foster'     ,   95000 ,  'Data Scientist', 'Female')
,(67323,  'Lisa'    , 'Wiener'      ,   75000 ,  'Business Analyst', 'Female')


/* CREATE EMPLOYEES_B TABLE */

CREATE TABLE employees_B (
	emp_id BIGINT,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	salary BIGINT,
	job_title VARCHAR (30),
	gender VARCHAR(10),
);

/*INSERT VALUES TO EMPLOYEES_B TABLE */

INSERT employees_B VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')

/* UNION OPERATORS */
/* UNION operators combines results of two queries */

SELECT * FROM employees_A;
SELECT * FROM employees_B;

/* COMBINING EMPLOYEES_A AND EMPLOYEES_B TABLES */
-- UNION operator drops duplicates

SELECT * FROM employees_A
UNION
SELECT * FROM employees_B; -- As you can see from the result, duplicates were droped.

SELECT emp_id, first_name, last_name, job_title FROM employees_A
UNION
SELECT emp_id, first_name, last_name, job_title FROM employees_B;


/*Union All Operator */

/* The UNION ALL clause is used to print all the records including duplicate
records when combining the two tables. */

SELECT 'Employees_A' AS TYPE, emp_id, first_name, last_name, job_title FROM employees_A
UNION ALL
SELECT 'Employess_B' AS TYPE, emp_id, first_name, last_name, job_title FROM employees_B;

-- Type column was created to indicate which table the employees belong to.

/* The INTERSECT Operator */

/* INTERSECT operator compares the result sets of two queries 
and returns distinct rows that are output by both queries. */

SELECT emp_id, first_name, last_name, job_title FROM employees_A
INTERSECT
SELECT emp_id, first_name, last_name, job_title FROM employees_B;

/* EXCEPT Operator */

/* EXCEPT operator compares the result sets of the two queries and 
returns the rows of the previous query that differ from the next query. */

SELECT emp_id, first_name, last_name, job_title FROM employees_A
EXCEPT
SELECT emp_id, first_name, last_name, job_title FROM employees_B;

/*As you can see, in the result set, only employees who were in the employees_A table
but not the employees_B table were returned. */

/* CHECK YOURSELF:SET OPERATORS */

/* QUESTION1: List in ascending order the stores where both 
"Samsung Galaxy Tab S3 Keyboard Cover" and 
"Apple - Pre-Owned iPad 3 - 64GB - Black" are stocked. */


-- Store names that solds "Samsung Galaxy Tab S3 Keyboard Cover"
SELECT SS.store_name, PP.product_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id
WHERE product_name = 'Samsung Galaxy Tab S3 Keyboard Cover';

-- Store names that solds "Apple - Pre-Owned iPad 3 - 64GB - Black"
SELECT SS.store_name, PP.product_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black';

--store names that sold both "Samsung Galaxy Tab S3 Keyboard Cover" and "Apple - Pre-Owned iPad 3 - 64GB - Black"

SELECT SS.store_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id
WHERE product_name = 'Samsung Galaxy Tab S3 Keyboard Cover'
INTERSECT
SELECT SS.store_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 64GB - Black';


/*	QUESTION 2: Detect the store that does not have a product named 
"Samsung Galaxy Tab S3 Keyboard Cover" in its stock. */


-- store names that sold "Samsung Galaxy Tab S3 Keyboard Cover"
SELECT SS.store_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id
WHERE product_name = 'Samsung Galaxy Tab S3 Keyboard Cover';


-- all distinct store names
SELECT DISTINCT SS.store_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id;

--combining of two queries above with except
SELECT DISTINCT SS.store_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id
EXCEPT
SELECT SS.store_name
FROM product.product AS PP
INNER JOIN product.stock AS PS
ON PP.product_id=ps.product_id
INNER JOIN sale.store AS SS
ON PS.store_id = SS.store_id
WHERE product_name = 'Samsung Galaxy Tab S3 Keyboard Cover';


/* Simple CASE Expression */

/* The simple CASE expression compares an expression to a set of expressions 
to return the result. */

/* syntax: */

CASE case_expression
  WHEN when_expression_1 THEN result_expression_1
  WHEN when_expression_1 THEN result_expression_1
  ...
  [ ELSE else_result_expression ]
END
--örnek
SELECT emp_id, gender,
	CASE gender
		WHEN 'Male' THEN 0
		ELSE 1
	END AS gender_cat
FROM employees_A


/* Searched CASE Expression */

/* The searched CASE expression evaluates a set of expressions to determine
the result. In this type of CASE statement, we don't specify any expression
right after the CASE keyword. */

/* syntax: */

CASE
  WHEN condition_1 THEN result_1
  WHEN condition_2 THEN result_2
  WHEN condition_N THEN result_N
  [ ELSE result ]
END

-- Örnek:

SELECT *,
	CASE
		WHEN gender = 'Male' THEN 0
		WHEN gender = 'Female' THEN 1
	END as gender_cat
FROM employees_A;


/* Using CASE expression with aggregation functions most of the time saves
you from long queries. */

/* example:

SELECT first_name,
       SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) AS Seniority,
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) AS Graduation
FROM departments
GROUP BY first_name
HAVING SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) > 0
	     AND
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) > 0
*/


/* CHECK YOURSELF : CASE STATEMENTS */

/* QUESTION 1:
List counts of orders on the weekend and weekdays. Submit your answer in a single 
row with two columns. For example: 164 161. First value is for weekend. */

SELECT COUNT(*) AS COUNT_OF_ORDERS,
	CASE DATENAME(DW, order_date)
		WHEN 'SATURDAY' THEN 'WEEKEND'
		WHEN 'SUNDAY' THEN 'WEEKEND'
		ELSE 'WEEKDAY'
	END AS DAY_CATEGORY
FROM sale.orders
GROUP BY CASE DATENAME(DW, order_date)
			WHEN 'SATURDAY' THEN 'WEEKEND'
			WHEN 'SUNDAY' THEN 'WEEKEND'
			ELSE 'WEEKDAY'
		END

-- PIVOT ÝLE DÜZENLEME

SELECT *
FROM (SELECT order_id,
	CASE DATENAME(DW, order_date)
		WHEN 'SATURDAY' THEN 'WEEKEND'
		WHEN 'SUNDAY' THEN 'WEEKEND'
		ELSE 'WEEKDAY'
	END AS DAY_CATEGORY
	FROM sale.orders) AS A
PIVOT (
	COUNT(A.order_id)
	FOR A.DAY_CATEGORY
	IN ([WEEKEND],[WEEKDAY])
) AS pivot_table;


/* QUESTION 2:
Classify staff according to the count of orders they receive as follows:

a) 'High-Performance Employee' if the number of orders is greater than 400
b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
c) 'Low-Performance Employee' if the number of orders is between 1 and 100
d) 'No Order' if the number of orders is 0

Then, list the staff's first name, last name, employee class, and count of orders.
(Count of orders and first names in ascending order) */






