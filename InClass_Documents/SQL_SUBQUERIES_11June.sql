/* SUBQUERIES */

/* A subquery is a SELECT statement that is nested within another statement.
The subquery is also called the inner query or nested query. A subquery may be used in:

SELECT clause
FROM clause
WHERE clause
*/

/* There are some rules when using subquery:

A subquery must be enclosed in parentheses.
An ORDER BY clause is not allowed to use in a subquery.
The BETWEEN operator can't be used with a subquery.
But you can use BETWEEN within the subquery. */


/*SUBQUERY IN SELECT CLAUSE */
/* sonucu her satýrda tekrar eder.*/

SELECT order_id, list_price, (SELECT AVG(list_price)  -- sipariþ verilern ürünlerin ortalama fiyatý
								FROM  sale.order_item) as avg_price
FROM  sale.order_item

SELECT order_id, list_price, (SELECT AVG(list_price)  -- ürün listesindeki tüm ürünlerin ortalama fiyatý
								FROM  product.product) as avg_price
FROM  sale.order_item

/*SUBQUERY IN WHERE CLAUSE */

SELECT order_id, order_date
FROM  sale.orders
WHERE order_date IN (
		SELECT TOP 5 order_date  -- Buradaki SELECT yanýna sadece bir sütun eklenebilir. Where yanýnda da ayný sütun adý olmalýdýr.
		FROM sale.orders
		ORDER BY order_date DESC);

/* SUBQUERY IN FROM CLAUSE */

/* SÝPARÝÞ VERÝLMÝÞ SON 5 TARÝHÝ BULALIM */

SELECT A.order_id, A.order_date
FROM (
	SELECT TOP 5 *
		FROM sale.orders
		ORDER BY order_date DESC) A;  --alias zorunlu


/* TYPES OF SUBQUERIES */

/*
1. SINGLE ROW SUBQUERY
2. MULTIPLE ROW SUBQUERY
3. CORRELATED SUBQUERY */

/* SINGLE ROW SUBQUERY */

/* Single-row subqueries return one row with only one column and
are used with single-row operators such as =, >, >=, <=, <>, !=  */

/* Write a query that returns the total price by each order_ids. */

-- 1. çözüm:
SELECT order_id, SUM(list_price) avg_list_price
FROM sale.order_item
GROUP BY order_id

/* 2. çözüm : 
select subquery de sum olduðu için subqueryde group by da yapmaya gerek kalmýyor */

select	so.order_id,
		(
		select	sum(list_price)
		from	sale.order_item
		where	order_id=so.order_id  -- burada mutlaka baðlantý kurmak gerekiyor.
		) AS total_price
from	sale.order_item AS so
group by so.order_id;



--iKÝSÝ ARASINDAKÝ FARKIN NEDENLERÝNIN MANTIKSAL AÇIKLAMASI ???
--1. KOD
SELECT  B.order_id, (SELECT SUM(list_price*quantity*(1-discount)) FROM sale.order_item WHERE order_id = B.order_id ) AS TOTAL
FROM sale.order_item B
GROUP BY B.order_id
--2. KOD
SELECT  order_id, (SELECT SUM(B.list_price*B.quantity*(1-B.discount)) FROM sale.order_item B WHERE B.order_id = order_id ) AS TOTAL
FROM sale.order_item
GROUP BY order_id


/* Heagle hocanýn dediði inner select yapmadan doðrudan */

SELECT TOP 5 order_id, order_date
FROM sale.orders
ORDER BY order_date  DESC


/* Davis Thomas'ýn çalýþtýðý maðazadaki çalýþanlarýn listesini getirelim */


SELECT *
FROM sale.staff
WHERE store_id = (
				SELECT store_id
				FROM sale.staff
				WHERE first_name = 'Davis' AND last_name='Thomas'
				);

/* Charles Cussona'nýn managerý olduðu çalýþanlarýn listesini getirelim */
-- önce Charles Cussona nýn staff_id sini buluyoruz.
-- staff_id ayný zamanda manager_id olarak kullanýlmýþ ve ayný tablo içinde birbiri ile iliþkilendirilmiþ


SELECT *
FROM sale.staff
WHERE manager_id = (
				SELECT staff_id  
				FROM sale.staff
				WHERE first_name = 'Charles' AND last_name='Cussona'
				);


/*'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli üründen pahalý olan ürünleri listeleyin.
Product id, product name, model_year, fiyat, marka adý ve kategori adý alanlarýna ihtiyaç duyulmaktadýr. */

SELECT product_id, product_name, model_year, list_price, B.brand_id, C.category_id
FROM product.product AS A, product.brand AS B, product.category AS C
WHERE A.list_price > (
				SELECT list_price 
				FROM product.product
				WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')
				AND A.brand_id=b.brand_id
				AND A.category_id=C.category_id;


/* MUTIPLE SUBQUERIES */
/* Birden fazla sütun döndürdüðü için WHERE CLAUSE da IN, NOT IN operatörleri ile kullanýlabilir.*/

/* Laurel Goldammer ile ayný tarihte sipariþ veren tüm müþterileri listeyiniz */

SELECT *
FROM sale.customer AS SC, sale.orders AS SO
WHERE order_date IN (
				SELECT SO.order_date
				FROM sale.customer AS SC, sale.orders AS SO
				WHERE first_name = 'Laurel' AND last_name='Goldammer'
				AND SC.customer_id=SO.customer_id)
				AND SC.customer_id=SO.customer_id;

/* Laurel Goldammer ile ayný tarihte alýþveriþ yapan tüm müþterileri listeyiniz */

SELECT *
FROM sale.customer AS SC, sale.orders AS SO
WHERE order_date IN (
				SELECT SO.order_date
				FROM sale.customer AS SC, sale.orders AS SO
				WHERE first_name = 'Laurel' AND last_name='Goldammer'
				AND SC.customer_id=SO.customer_id)
				AND SC.customer_id=SO.customer_id
				AND SO.order_status = 4;


/* 2021 de üretilen ve kategorileri Game, gps, veya Home Theater dýþýnda olan ürünleri listeleyiniz*/


-- CATEGORY_NAME üzerinden filtreleme

SELECT B.product_name, B.list_price
FROM product.category AS A, product.product AS B
WHERE category_name NOT IN (
				SELECT category_name
				FROM product.category
				WHERE category_name IN('Game', 'gps', 'Home Theater' )
				)
				AND A.category_id=B.category_id
				AND model_year = 2021;

--CATEGORY_ID üzerinden filtreleme

SELECT product_name, list_price
FROM product.product
WHERE category_id NOT IN (
				SELECT category_id
				FROM product.category
				WHERE category_name IN('Game', 'gps', 'Home Theater' )
				)
				AND model_year = 2021;

-- 3. çözüm :iç sorgudaki kategorilerin dýþýndakileri bulup, onlar üzerinden ilerlemek

SELECT product_name, list_price
FROM product.product
WHERE category_id IN (
				SELECT category_id
				FROM product.category
				WHERE category_name NOT IN('Game', 'gps', 'Home Theater' )
				)
				AND model_year = 2021;


/* Receivers Amplifiers kategorisindeki en pahalý üründen daha pahalý olan ürünlerin
model yýlý 2020 olanlarýný listeleyin.
 Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz. */

--1. ÇÖZÜM: MAX deðeri bularak

SELECT product_name, model_year, list_price
FROM product.product
WHERE list_price > (
				SELECT MAX(B.list_price)
				FROM product.category AS A, product.product AS B
				WHERE category_name = 'Receivers Amplifiers'
					AND A.category_id = B.category_id
				)
				AND model_year =2020
ORDER BY list_price DESC;


--2. ÇÖZÜM: ALL operatörünü kullanarak

SELECT *
FROM product.product
WHERE list_price > ALL (   -- Listedeki fiyatlarýn hepsinden büyük olanlarý bulmak için ALL kullanýyoruz.
				SELECT B.list_price
				FROM product.category AS A, product.product AS B
				WHERE category_name = 'Receivers Amplifiers'
					AND A.category_id = B.category_id
				)
				AND model_year =2020
ORDER BY list_price DESC;


/* Receivers Amplifiers kategorisindeki ürünlerin herhangibirinden daha pahalý
olan ürünlerin model yýlý 2020 olanlarýný listeleyin.
 Ürün adý, model_yýlý ve fiyat bilgilerini yüksek fiyattan düþük fiyata doðru sýralayýnýz. */

-- 1. ÇÖZÜM : MIN deðeri bularak

SELECT product_name, model_year, list_price
FROM product.product
WHERE list_price > (
				SELECT MIN(B.list_price)
				FROM product.category AS A, product.product AS B
				WHERE category_name = 'Receivers Amplifiers'
					AND A.category_id = B.category_id
				)
				AND model_year =2020
ORDER BY list_price DESC;


-- 2. ÇÖZÜM : ANY operatörünü kullanarak

SELECT *
FROM product.product
WHERE list_price > ANY (   -- Listedeki fiyatlarýn herhangibirinden büyük olanlarý bulmak için ALL kullanýyoruz.
				SELECT B.list_price
				FROM product.category AS A, product.product AS B
				WHERE category_name = 'Receivers Amplifiers'
					AND A.category_id = B.category_id
				)
				AND model_year =2020
ORDER BY list_price DESC;











