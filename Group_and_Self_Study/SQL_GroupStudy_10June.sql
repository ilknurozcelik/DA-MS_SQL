----Write a query that returns the count of orders of each day between
---'2020-01-19' and '2020-01-25'. Report the result using Pivot Table.
--Note: The column names should be day names (Sun, Mon, etc.).
--(Use SampleRetail DB on SQL Server and paste the result in the answer box.)


SELECT order_id, DATENAME(DW, order_date) AS DAY_
FROM sale.orders
WHERE order_date BETWEEN '2020-01-19' AND '2020-01-25'

SELECT *
FROM (SELECT order_id, DATENAME(DW, order_date) AS DAY_
	FROM sale.orders
	WHERE order_date BETWEEN '2020-01-19' AND '2020-01-25'
) AS A
PIVOT(
		COUNT(A.order_id)
		FOR DAY_
		IN ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
		) as P�VOT_TABLE;


/* QUESTION 2: Please write a query to return only the order ids that have an
average amount of more than $2000.

Your result set should include order_id. Sort the order_id in ascending order. */


SELECT order_id, COUNT(*) AS COUNT_ORDER, SUM(list_price*quantity) AS SUM_, AVG(list_price*quantity) AS AVG_AMOUNT
FROM sale.order_item
GROUP BY (order_id)
HAVING AVG(list_price*quantity) > 2000
order by order_id

SELECT *
FROM sale.order_item


/* QUESTION1: List in ascending order the stores where both 
"Samsung Galaxy Tab S3 Keyboard Cover" and 
"Apple - Pre-Owned iPad 3 - 64GB - Black" are stocked. */

SELECT D.store_name
FROM(
	SELECT B.store_id
	FROM product.product AS A, product.stock AS B
	WHERE A.product_id = B.product_id AND product_name ='Samsung Galaxy Tab S3 Keyboard Cover'
	INTERSECT
	SELECT B.store_id
	FROM product.product AS A, product.stock AS B
	WHERE A.product_id = B.product_id AND product_name ='Apple - Pre-Owned iPad 3 - 64GB - Black'
	) AS C, sale.store AS D
WHERE C.store_id = D.store_id
ORDER BY D.store_name;

/* QUESTION 2: Detect the store that does not have a product named 
"Samsung Galaxy Tab S3 Keyboard Cover" in its stock. */

SELECT D.store_name
FROM (

	SELECT B.store_id
	FROM product.product AS A, product.stock AS B
		WHERE A.product_id = B.product_id
	EXCEPT
		SELECT B.store_id
		FROM product.product AS A, product.stock AS B
		WHERE A.product_id = B.product_id AND product_name ='Samsung Galaxy Tab S3 Keyboard Cover'
		) AS C, sale.store AS D
WHERE C.store_id = D.store_id;


SELECT DISTINCT B.store_id
FROM product.stock AS B


/* QUESTION 1:
List counts of orders on the weekend and weekdays. Submit your answer in a single 
row with two columns. For example: 164 161. First value is for weekend. */


SELECT *
FROM(
	select order_id,
		CASE datename(dw, order_date)
			WHEN 'Sunday'	THEN 'Weekend'
			WHEN 'Saturday' THEN 'Weekend'
			ELSE 'Weekday'
		END week_cat
	from sale.orders
	) AS A
PIVOT(
	COUNT(A.order_id)
	FOR week_cat IN ([Weekend],[Weekday])
	) AS pivot_table;

/* Classify staff according to the count of orders they receive as follows:

a) 'High-Performance Employee' if the number of orders is greater than 400
b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
c) 'Low-Performance Employee' if the number of orders is between 1 and 100
d) 'No Order' if the number of orders is 0
Then, list the staff's first name, last name, employee class, and count of orders.
(Count of orders and first names in ascending order)
*/

SELECT staff_id, count(order_id)
FROM sale.orders
GROUP BY staff_id


SELECT *
FROM sale.orders

SELECT SS.first_name, SS.last_name,
	CASE
		WHEN count(order_id) > 400 THEN 'High-Performance Employee'
		WHEN count(order_id) BETWEEN 100 AND 400 THEN 'Normal-Performance Employee'
		WHEN count(order_id) BETWEEN 1 AND 100 THEN 'Low-Performance Employee'
		ELSE 'No Order'
	END Employee_Class,
	count(order_id) AS COUNT_ORDER
FROM sale.staff AS SS
LEFT JOIN sale.orders AS SO
ON SS.staff_id = SO.staff_id
GROUP BY SS.first_name, SS.last_name
ORDER BY 4, 1


/*    */

SELECT *,
	CASE
		WHEN DATEDIFF(DAY, order_date, shipped_date) = 0 THEN 'FAST'
		WHEN DATEDIFF(DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'NORMAL'
		WHEN DATEDIFF(DAY, order_date, shipped_date) >= 3 THEN 'SLOW'
		ELSE 'NOT SHIPPED'
	END ORDER_LABEL
FROM sale.orders


/*Sipari�lerin kargoya verilme h�zlar�n� g�steren ifadeler i�eren bir s�tun olu�turunuz.

1. E�er �r�n hen�z kargoya verilmemi�se 'Not Shipped',
2. �r�n sipari� verildi�i g�n kargoya verilmi�se 'H�zl�',
3. �r�n sipari� verildikten sonraki 2 g�n i�erisinde kargoya verilmi�se 'Normal',
4.b�r�n sipari� verildikten 3 veya daha fazla g�nde kargoya verilmi�se 'Slow'

�eklinde etiketlenmelidir.*/

SELECT *,
	CASE
		WHEN DATEDIFF(DAY, order_date, shipped_date) = 0 THEN 'FAST'
		WHEN DATEDIFF(DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'NORMAL'
		WHEN DATEDIFF(DAY, order_date, shipped_date) >= 3 THEN 'SLOW'
		ELSE 'NOT SHIPPED'
	END ORDER_LABEL
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2


/* Siperi� verildikten sonra 2 g�nden daha fazla s�rede kargoya verilen �r�nlerin 
haftan�n g�nlerine g�re sipari� say�lar�n� bularak ayr� s�tunlarda g�steriniz. */

SELECT *
FROM (SELECT order_id, datename(dw, order_date) AS DAY_
		FROM sale.orders
		WHERE DATEDIFF(DAY, order_date, shipped_date) > 2
	
) AS A
PIVOT(
		COUNT(A.order_id)
		FOR DAY_
		IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday], [Sunday])
		) as P�VOT_TABLE;