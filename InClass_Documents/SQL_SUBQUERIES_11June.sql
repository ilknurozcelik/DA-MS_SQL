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
/* sonucu her sat�rda tekrar eder.*/

SELECT order_id, list_price, (SELECT AVG(list_price)  -- sipari� verilern �r�nlerin ortalama fiyat�
								FROM  sale.order_item) as avg_price
FROM  sale.order_item

SELECT order_id, list_price, (SELECT AVG(list_price)  -- �r�n listesindeki t�m �r�nlerin ortalama fiyat�
								FROM  product.product) as avg_price
FROM  sale.order_item

/*SUBQUERY IN WHERE CLAUSE */

SELECT order_id, order_date
FROM  sale.orders
WHERE order_date IN (
		SELECT TOP 5 order_date  -- Buradaki SELECT yan�na sadece bir s�tun eklenebilir. Where yan�nda da ayn� s�tun ad� olmal�d�r.
		FROM sale.orders
		ORDER BY order_date DESC);

/* SUBQUERY IN FROM CLAUSE */

/* S�PAR�� VER�LM�� SON 5 TAR�H� BULALIM */

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

-- 1. ��z�m:
SELECT order_id, SUM(list_price) avg_list_price
FROM sale.order_item
GROUP BY order_id

/* 2. ��z�m : 
select subquery de sum oldu�u i�in subqueryde group by da yapmaya gerek kalm�yor */

select	so.order_id,
		(
		select	sum(list_price)
		from	sale.order_item
		where	order_id=so.order_id  -- burada mutlaka ba�lant� kurmak gerekiyor.
		) AS total_price
from	sale.order_item AS so
group by so.order_id;



--iK�S� ARASINDAK� FARKIN NEDENLER�NIN MANTIKSAL A�IKLAMASI ???
--1. KOD
SELECT  B.order_id, (SELECT SUM(list_price*quantity*(1-discount)) FROM sale.order_item WHERE order_id = B.order_id ) AS TOTAL
FROM sale.order_item B
GROUP BY B.order_id
--2. KOD
SELECT  order_id, (SELECT SUM(B.list_price*B.quantity*(1-B.discount)) FROM sale.order_item B WHERE B.order_id = order_id ) AS TOTAL
FROM sale.order_item
GROUP BY order_id


/* Heagle hocan�n dedi�i inner select yapmadan do�rudan */

SELECT TOP 5 order_id, order_date
FROM sale.orders
ORDER BY order_date  DESC


/* Davis Thomas'�n �al��t��� ma�azadaki �al��anlar�n listesini getirelim */


SELECT *
FROM sale.staff
WHERE store_id = (
				SELECT store_id
				FROM sale.staff
				WHERE first_name = 'Davis' AND last_name='Thomas'
				);

/* Charles Cussona'n�n manager� oldu�u �al��anlar�n listesini getirelim */
-- �nce Charles Cussona n�n staff_id sini buluyoruz.
-- staff_id ayn� zamanda manager_id olarak kullan�lm�� ve ayn� tablo i�inde birbiri ile ili�kilendirilmi�


SELECT *
FROM sale.staff
WHERE manager_id = (
				SELECT staff_id  
				FROM sale.staff
				WHERE first_name = 'Charles' AND last_name='Cussona'
				);


/*'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)' isimli �r�nden pahal� olan �r�nleri listeleyin.
Product id, product name, model_year, fiyat, marka ad� ve kategori ad� alanlar�na ihtiya� duyulmaktad�r. */

SELECT product_id, product_name, model_year, list_price, B.brand_id, C.category_id
FROM product.product AS A, product.brand AS B, product.category AS C
WHERE A.list_price > (
				SELECT list_price 
				FROM product.product
				WHERE product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')
				AND A.brand_id=b.brand_id
				AND A.category_id=C.category_id;


/* MUTIPLE SUBQUERIES */
/* Birden fazla s�tun d�nd�rd��� i�in WHERE CLAUSE da IN, NOT IN operat�rleri ile kullan�labilir.*/

/* Laurel Goldammer ile ayn� tarihte sipari� veren t�m m��terileri listeyiniz */

SELECT *
FROM sale.customer AS SC, sale.orders AS SO
WHERE order_date IN (
				SELECT SO.order_date
				FROM sale.customer AS SC, sale.orders AS SO
				WHERE first_name = 'Laurel' AND last_name='Goldammer'
				AND SC.customer_id=SO.customer_id)
				AND SC.customer_id=SO.customer_id;

/* Laurel Goldammer ile ayn� tarihte al��veri� yapan t�m m��terileri listeyiniz */

SELECT *
FROM sale.customer AS SC, sale.orders AS SO
WHERE order_date IN (
				SELECT SO.order_date
				FROM sale.customer AS SC, sale.orders AS SO
				WHERE first_name = 'Laurel' AND last_name='Goldammer'
				AND SC.customer_id=SO.customer_id)
				AND SC.customer_id=SO.customer_id
				AND SO.order_status = 4;


/* 2021 de �retilen ve kategorileri Game, gps, veya Home Theater d���nda olan �r�nleri listeleyiniz*/


-- CATEGORY_NAME �zerinden filtreleme

SELECT B.product_name, B.list_price
FROM product.category AS A, product.product AS B
WHERE category_name NOT IN (
				SELECT category_name
				FROM product.category
				WHERE category_name IN('Game', 'gps', 'Home Theater' )
				)
				AND A.category_id=B.category_id
				AND model_year = 2021;

--CATEGORY_ID �zerinden filtreleme

SELECT product_name, list_price
FROM product.product
WHERE category_id NOT IN (
				SELECT category_id
				FROM product.category
				WHERE category_name IN('Game', 'gps', 'Home Theater' )
				)
				AND model_year = 2021;

-- 3. ��z�m :i� sorgudaki kategorilerin d���ndakileri bulup, onlar �zerinden ilerlemek

SELECT product_name, list_price
FROM product.product
WHERE category_id IN (
				SELECT category_id
				FROM product.category
				WHERE category_name NOT IN('Game', 'gps', 'Home Theater' )
				)
				AND model_year = 2021;


/* Receivers Amplifiers kategorisindeki en pahal� �r�nden daha pahal� olan �r�nlerin
model y�l� 2020 olanlar�n� listeleyin.
 �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z. */

--1. ��Z�M: MAX de�eri bularak

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


--2. ��Z�M: ALL operat�r�n� kullanarak

SELECT *
FROM product.product
WHERE list_price > ALL (   -- Listedeki fiyatlar�n hepsinden b�y�k olanlar� bulmak i�in ALL kullan�yoruz.
				SELECT B.list_price
				FROM product.category AS A, product.product AS B
				WHERE category_name = 'Receivers Amplifiers'
					AND A.category_id = B.category_id
				)
				AND model_year =2020
ORDER BY list_price DESC;


/* Receivers Amplifiers kategorisindeki �r�nlerin herhangibirinden daha pahal�
olan �r�nlerin model y�l� 2020 olanlar�n� listeleyin.
 �r�n ad�, model_y�l� ve fiyat bilgilerini y�ksek fiyattan d���k fiyata do�ru s�ralay�n�z. */

-- 1. ��Z�M : MIN de�eri bularak

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


-- 2. ��Z�M : ANY operat�r�n� kullanarak

SELECT *
FROM product.product
WHERE list_price > ANY (   -- Listedeki fiyatlar�n herhangibirinden b�y�k olanlar� bulmak i�in ALL kullan�yoruz.
				SELECT B.list_price
				FROM product.category AS A, product.product AS B
				WHERE category_name = 'Receivers Amplifiers'
					AND A.category_id = B.category_id
				)
				AND model_year =2020
ORDER BY list_price DESC;











