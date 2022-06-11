/* UNION */

-- duplicate ler gelmez.
-- Sütun sayýlarý eþit olmalý
-- veri türleri ayný olmalý
-- order by union yapýldýktan sonra kullanýlmalý

/* SORU: Charlotte þehrindeki müþteriler ile Aurora þehrindeki müþterilerin 
soyisimlerini listeleyin */

SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
UNION
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'

/* SORU: Çalýþanlarýn ve müþterilerin e-posta adreslerini
unique olacak þekilde listeleyiniz. */

SELECT email
FROM sale.customer
UNION
SELECT email
FROM sale.staff;

/* UNION ALL */

--duplicate ler de gelir. Ýki sorgudan dönen tüm verileri birbirine append yapar.

-- Adý Thomas olan ya da soyadý Thomas olan müþterilerin isim soyisimlerini listeleyiniz.

SELECT first_name,last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION ALL
SELECT first_name,last_name
FROM sale.customer
WHERE last_name = 'Thomas';

SELECT first_name,last_name
FROM sale.customer
WHERE first_name = 'Thomas'
UNION
SELECT first_name,last_name
FROM sale.customer
WHERE last_name = 'Thomas';

/* INTERSECT */

-- Ýki sorgunun sonucunda ortak olanlarý döndürür.

-- Write a query that returns brands that have products for both 2018 and 2019.

SELECT PP.brand_id, PB.brand_name
FROM product.brand AS PB, product.product AS PP
WHERE PP.brand_id=PB.brand_id AND PP.model_year = 2018
INTERSECT
SELECT PP.brand_id, PB.brand_name
FROM product.brand AS PB, product.product AS PP
WHERE PP.brand_id=PB.brand_id AND PP.model_year = 2019


-- Write a query that returns customers who have orders for both 2018, 2019, and 2020


SELECT SC.first_name, SC.last_name, SO.customer_id 
FROM sale.customer AS SC, sale.orders AS SO
WHERE SC.customer_id=SO.customer_id AND YEAR(order_date) = 2018
INTERSECT
SELECT SC.first_name, SC.last_name, SO.customer_id
FROM sale.customer AS SC, sale.orders AS SO
WHERE SC.customer_id=SO.customer_id AND YEAR(order_date) = 2019
INTERSECT
SELECT SC.first_name, SC.last_name, SO.customer_id
FROM sale.customer AS SC, sale.orders AS SO
WHERE SC.customer_id=SO.customer_id AND YEAR(order_date) = 2020;


/* 2018, 2019 ve 2020 yýllarýnda sipariþ vermiþ müþterilerin sipariþ bilgilerini 
getiren bir sorgu yazýnýz. */

SELECT *
FROM(
	select SC.customer_id, SC.first_name, SC.last_name
	from sale.orders AS SO, sale.customer AS SC
	where year(SO.order_date) =2018 AND
		SO.customer_id=SC.customer_id
	INTERSECT
	select SC.customer_id, SC.first_name, SC.last_name
	from sale.orders AS SO, sale.customer AS SC
	where year(SO.order_date) =2019 AND
		SO.customer_id=SC.customer_id
	INTERSECT
	select SC.customer_id, SC.first_name, SC.last_name
	from sale.orders AS SO, sale.customer AS SC
	where year(SO.order_date) =2020 AND
		SO.customer_id=SC.customer_id
	) AS A, sale.orders AS B
WHERE A.customer_id=B.customer_id AND Year(B.order_date) in (2018, 2019, 2020)
order by A.customer_id, B.order_date;

/*
SELECT *
FROM sale.orders
WHERE customer_id = 8 
*/

select *
from
	(
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2018
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A, sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2019
	INTERSECT
	select	A.first_name, A.last_name, B.customer_id
	from	sale.customer A , sale.orders B
	where	A.customer_id = B.customer_id and
			YEAR(B.order_date) = 2020
	) A, sale.orders B
where	a.customer_id = b.customer_id and Year(b.order_date) in (2018, 2019, 2020)
order by a.customer_id, b.order_date
;


-- 'Charlotte'  ve 'Aurora' þehrinde yaþayan ve soyisimleri ayný olan kiþilerin soyadlarýný görelim.
SELECT last_name
FROM sale.customer
WHERE city = 'Charlotte'
INTERSECT
SELECT last_name
FROM sale.customer
WHERE city = 'Aurora'


/* EXCEPT */

/* bir sorgunun döndürdüðü kümenin diðer sorgunun döndürdüðü kümeden farkýný bulmak için 
kullanýlýr. */

-- Model yýlý 2018 olupta model yýlý 2019 olmayan markalarý bulalým.

SELECT PB.brand_id, PB.brand_name
FROM product.brand AS PB, product.product AS PP
WHERE PB.brand_id = PP.brand_id AND PP.model_year = 2018
except
SELECT PB.brand_id, PB.brand_name
FROM product.brand AS PB, product.product AS PP
WHERE PB.brand_id = PP.brand_id AND PP.model_year = 2019;

--Sadece 2019 yýlýnda sipariþ verilen diðer yýllarda sipariþ verilmeyen ürünleri getiriniz.

SELECT SOI.product_id, PP.product_name
FROM sale.orders AS SO, product.product AS PP, sale.order_item AS SOI
WHERE SO.order_id= SOI.order_id AND SOI.product_id=PP.product_id AND YEAR(SO.order_date)= 2019
EXCEPT
SELECT SOI.product_id, PP.product_name
FROM sale.orders AS SO, product.product AS PP, sale.order_item AS SOI
WHERE SO.order_id= SOI.order_id AND SOI.product_id=PP.product_id AND YEAR(SO.order_date) <> 2019;


-- 2018 ve 2019 da ürünü olmayan markalarý bulalým.

SELECT brand_id, brand_name  --bütün ürünleri içeren tablo
FROM product.brand
EXCEPT
SELECT PP.brand_id, PB.brand_name  --2018 ve 2019 da ürünü olan tablo
FROM product.brand AS PB, product.product AS PP
WHERE PP.brand_id=PB.brand_id AND PP.model_year = 2018
INTERSECT
SELECT PP.brand_id, PB.brand_name
FROM product.brand AS PB, product.product AS PP
WHERE PP.brand_id=PB.brand_id AND PP.model_year = 2019;


-- yýllara göre sipariþ verilen ürün sayýsýný bulan bir sorgu yazalým ve yýllarý sütunlarda gösterelim

SELECT *
FROM	(
			SELECT P.product_name, P.product_id, YEAR(O.order_date) as order_year
			FROM product.product P, sale.orders O, sale.order_item OI 
			WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id
			) A
PIVOT
(
	count(product_id)
	FOR order_year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

-- Sadece 2019 yýlýnda sipariþ verilmiþ diðer yýllarda sipariþ verilmemiþ ürünleri bulalým

select	B.product_id, C.product_name
from	sale.orders A, sale.order_item B, product.product C
where	Year(A.order_date) = 2019 AND
		A.order_id = B.order_id AND C.product_id=B.product_id
except
select	B.product_id, C.product_name
from	sale.orders A, sale.order_item B, product.product C
where	Year(A.order_date) <> 2019 AND
		A.order_id = B.order_id AND C.product_id=B.product_id
	
-- Önce id döndüren ve sonrasýnda id üzerinden product_name getiren þekilde düzenleyelim.
-- Böyle yazdýðýmýzda performansý daha iyi oluyor.
select PP.product_id, PP.product_name
from
(
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) = 2019 AND
			A.order_id = B.order_id
	except
	select	B.product_id
	from	sale.orders A, sale.order_item B
	where	Year(A.order_date) <> 2019 AND
			A.order_id = B.order_id
	) AS A, product.product AS PP
WHERE A.product_id=PP.product_id;

/* CASE STATEMENTS */

/* SIMPLE CASE*/

SELECT order_id, order_status,
	CASE order_status
		WHEN 1 THEN 'PENDING'
		WHEN 2 THEN 'PROCESSING'
		WHEN 3 THEN 'REJECTED'
		WHEN 4 THEN 'COMPLETED'
	END order_status_category
FROM sale.orders



-- Maðaza isimlerine göre çalýþan isimlerini gösteren bir sorgu yazalým.
SELECT SA.first_name, SA.last_name, SO.store_id,
	CASE SO.store_id
		WHEN 1 THEN 'Davi techno Retail'
		WHEN 2 THEN 'The BFLO Store'
		WHEN 3 THEN 'Burkes Outlet'
	END AS Store_Name
FROM sale.staff AS SA, sale.store AS SO
WHERE SA.store_id=SO.store_id;


/* SEARCHED CASE */

SELECT order_id, order_status,
	CASE
		WHEN order_status = 1 THEN 'PENDING'
		WHEN order_status = 2 THEN 'PROCESSING'
		WHEN order_status = 3 THEN 'REJECTED'
		WHEN order_status = 4 THEN 'COMPLETED'
	END order_status_category
FROM sale.orders;

--Müþterilerin e-mail adreslerindeki servis saðlayýcýlarýný yeni bir sütun oluþturarak belirtiniz.
SELECT first_name, last_name, email,
	CASE
		WHEN email LIKE '%@gmail%' THEN 'Gmail'
		WHEN email LIKE '%@hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%@yahoo%' THEN 'Yahoo'
		ELSE 'OTHER'
	END email_stat
FROM sale.customer

--AYNI sipariþte hem mp4 player, hem speakers hem de computer accessories keategorilerinden ürün alan müþterileri bulunuz.

SELECT SOI.order_id, COUNT(DISTINCT pp.category_id)
	FROM product.category AS PC, product.product AS PP, sale.order_item AS SOI
	WHERE PC.category_id= PP.category_id AND PP.product_id=SOI.product_id
		 AND PC.category_name IN ('mp4 player', 'speakers', 'computer accessories')
	GROUP BY SOI.order_id
	HAVING COUNT(DISTINCT pp.category_id) = 3



SELECT C.first_name, C.last_name
FROM(
	SELECT SOI.order_id, COUNT(DISTINCT PC.category_id) UniqueCategory
	FROM product.category AS PC, product.product AS PP, sale.order_item AS SOI
	WHERE PC.category_id= PP.category_id AND PP.product_id=SOI.product_id
		 AND PC.category_name IN ('mp4 player', 'speakers', 'computer accessories')
	GROUP BY SOI.order_id
	HAVING COUNT(DISTINCT PC.category_id) = 3
	) A, sale.orders B, sale.customer C
WHERE A.order_id=B.order_id AND B.customer_id=c.customer_id