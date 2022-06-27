/* COMMON TABLE EXPRESSOINS */

/* Common Table Expression (CTE) is a temporary result set that you can reference or
use within another SELECT, INSERT, DELETE, or UPDATE statements.*/

/* There are two types of CTEs:

Ordinary
Recursive */

/* CTEs are created by adding a WITH clause in front of SELECT, INSERT, DELETE, or UPDATE
statements. The WITH clause is also known as CTEs. You may see CTEs as WITH clause or WITH
queries in some sources. */

-- ORDINARY CTE SYNTAX:

/* WITH query_name [(column_name1, ...)] AS
    (SELECT ...) -- CTE Definition
SELECT * FROM query_name; -- SQL_Statement */

--Ordinary Example 1:
select avg(list_price)
from product.product

with temp_table (avg_price) as
(select avg(list_price)
from product.product)
select product_name, list_price
from product.product A inner join temp_table B
on A.list_price > B.avg_price;


-- Ordinary Example 2:
WITH t1 AS 
(
SELECT *
FROM departments
WHERE dept_name = 'Computer Science'
),
t2 as
(
SELECT *
FROM departments
WHERE dept_name = 'Physics'
)
SELECT d.name, t1.graduation AS graduation_CS, t2.graduation AS graduation_PHY
FROM departments as d
LEFT JOIN t1
ON d.id = t1.id
LEFT JOIN t2
ON d.id = t2.id
WHERE t1.graduation IS NOT NULL 
OR    t2.graduation IS NOT NULL
ORDER BY 2 DESC, 3 DESC



--CTE example 2

WITH cte_sales_amounts (staff, sales, year) AS (
    SELECT    
        first_name + ' ' + last_name, 
        SUM(quantity * list_price * (1 - discount)),
        YEAR(order_date)
    FROM    
        sale.orders o
    INNER JOIN sale.order_item i ON i.order_id = o.order_id
    INNER JOIN sale.staff s ON s.staff_id = o.staff_id
    GROUP BY 
        first_name + ' ' + last_name,
        year(order_date)
)

SELECT
    staff, 
    sales
FROM 
    cte_sales_amounts
WHERE
    year = 2018;

-- CTE example 3

WITH cte_sales AS (
    SELECT 
        staff_id, 
        COUNT(*) order_count  
    FROM
        sale.orders
    WHERE 
        YEAR(order_date) = 2018
    GROUP BY
        staff_id

)
SELECT
    AVG(order_count) average_orders_by_staff
FROM 
    cte_sales;


SELECT staff_id, count(distinct order_id)
FROM sale.orders
WHERE YEAR(order_date) =2018
GROUP BY staff_id
 
SELECT count(*)/count(distinct staff_id)
FROM sale.orders
WHERE YEAR(order_date) =2018


-- Using multiple SQL Server CTE in a single query example

WITH cte_category_counts (
    category_id, 
    category_name, 
    product_count
)
AS (
    SELECT 
        c.category_id, 
        c.category_name, 
        COUNT(p.product_id)
    FROM 
        product.product p
        INNER JOIN product.category c 
            ON c.category_id = p.category_id
    GROUP BY 
        c.category_id, 
        c.category_name
),
cte_category_sales(category_id, sales) AS (
    SELECT    
        p.category_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount))
    FROM    
        sale.order_item i
        INNER JOIN product.product p 
            ON p.product_id = i.product_id
        INNER JOIN sale.orders o 
            ON o.order_id = i.order_id
    WHERE order_status = 4 -- completed
    GROUP BY 
        p.category_id
) 

SELECT 
    c.category_id, 
    c.category_name, 
    c.product_count, 
    s.sales
FROM
    cte_category_counts c
    INNER JOIN cte_category_sales s 
        ON s.category_id = c.category_id
ORDER BY 
    c.category_name;

-- RECURSIVE CTE :

/* A common table expression is recursive if its subquery refers to its own name.
The initial CTE is repeatedly executed, returning subsets of data, until the complete
result is returned. */

-- RECURSIVE CTE SYNTAX:
/* 
WITH table_name (column_list)
AS
(
    -- Anchor member
    initial_query  
    UNION ALL
    -- Recursive member that references table_name.
    recursive_query  
)
-- references table_name
SELECT *
FROM table_name
*/

-- Recursive CTE Example:

WITH cte_org AS (
    SELECT       
        staff_id, 
        first_name,
        manager_id
        
    FROM       
        sale.staff
    WHERE manager_id IS NULL
    UNION ALL
    SELECT 
        e.staff_id, 
        e.first_name,
        e.manager_id
    FROM 
        sale.staff e
        INNER JOIN cte_org o 
            ON o.staff_id = e.manager_id
)
SELECT * FROM cte_org;