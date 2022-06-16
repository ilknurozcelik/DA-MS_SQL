/* WINDOW FUNCTIONS */

/* �r�nlerin stok say�lar�n� bulunuz*/

SELECT PP.product_id, SUM(PS.quantity) AS TOTAL_AMOUNT
FROM product.product AS PP, product.stock AS PS
WHERE PP.product_id = PS.product_id
GROUP BY PP.product_id;

-- product.product tablosuna gitmeye gerek yok.
SELECT product_id, SUM(quantity) AS TOTAL_AMOUNT
FROM product.stock
GROUP BY product_id
ORDER BY product_id;

--window function ile

SELECT *, SUM(quantity) OVER(PARTITION BY product_id) AS TOTAL_AMOUNT_WF
FROM product.stock;


-- product_id'ye g�re distinct yaparsak 
SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id) AS TOTAL_AMOUNT_WF
FROM product.stock;

-- NOT: where blo�una yazaca��n�z �art window function uygulanmadan �al��t�r�l�r.

/* Markalara g�re ortalama �r�n fiyatlar�n� hem Group By hem de Window Functions ile hesaplay�n�z. */

--GROUP BY �LE
SELECT PB.brand_id, PB.brand_name, AVG(PP.list_price)
FROM product.product AS PP, product.brand AS PB -- brand name getirmeyecekseniz product.brand tablosuna gerek yok
WHERE PP.brand_id = PB.brand_id
GROUP BY PB.brand_id, PB.brand_name
ORDER BY PB.brand_name

--WINDOW F. �LE

SELECT DISTINCT PB.brand_id, PB.brand_name, AVG(PP.list_price) OVER(PARTITION BY PB.brand_name) AS AVG_list_price
FROM product.product AS PP, product.brand AS PB -- brand name getirmeyecekseniz product.brand tablosuna gerek yok
WHERE PP.brand_id = PB.brand_id
ORDER BY PB.brand_name

/*Markalara g�re �r�n say�s�n� bulal�m */

SELECT *, count(*) OVER(PARTITION BY brand_id) AS COUNT_OF_PRODUCT
FROM product.product

/*Markalara g�re �r�n say�s�n�lar�n� ve her markadaki max �r�n fiyat�n� bulal�m */
SELECT *, 
		count(*) OVER(PARTITION BY brand_id) AS COUNT_OF_PRODUCT,
		MAX(list_price) OVER(PARTITION BY brand_id) AS MAX_L�ST_PRICE
FROM product.product

/*markaya ve categoriye g�re �r�n say�lar�n� ayr� ayr� bulal�m */
SELECT *, 
		count(*) OVER(PARTITION BY brand_id) AS COUNT_OF_PRODUCT_as_brand,
		count(*) OVER(PARTITION BY category_id) AS COUNT_OF_PRODUCT_as_category
FROM product.product

SELECT *, 
		count(*) OVER(PARTITION BY brand_id, category_id) AS COUNT_OF_PRODUCT_as_brand
FROM product.product


SELECT product_id, brand_id, category_id, model_year,
	count(*) OVER (PARTITION BY brand_id) CountOfProductInBrand,
	count(*) OVER (PARTITION BY category_id) CountOfProductInCategory
FROM product.product
ORDER BY brand_id, category_id, model_year

-- window function ile olu�turulan kolonlar bribirinden ba��ms�z hesaplan�r/olu�turulur.
-- dolay�s�yla ayn� select blo�u i�inde farkl� partition lar tan�mlayarak yeni kolonlar olu�turabilirsiniz.

-- HOCA KODU :
select	product_id, brand_id, category_id, model_year,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by category_id, brand_id, model_year


select	DISTINCT brand_id, category_id, model_year,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by category_id, brand_id, model_year


select	DISTINCT brand_id, category_id,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by category_id, brand_id

/*Farkl� Frame b�y�kl�klerinde SQL nas�l davran�yor. �rneklerle inceleyelim. */

-- Window Frames

-- Windows frame i anlamak i�in birka� �rnek:
-- Herbir sat�rda i�lem yap�lacak olan frame in b�y�kl���n� (sat�r say�s�n�) tespit edip
 -- window frame in nas�l olu�tu�unu a�a��daki sorgu sonucuna g�re konu�al�m.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,  -- partition tan�mlanmad��� i�in tablonun tamam�n� al�r.
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

;


/* Cheapest product price in each category
 Herbir kategorideki en ucuz �r�n�n fiyat�n� bulunuz? */

SELECT DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id) cheapest_product
FROM product.product
ORDER BY category_id


/* How many different product in the product table?
 Product tablosunda toplam ka� fakl� product bulundu�unu window function ile bulunuz */

SELECT DISTINCT count(*) OVER () number_of_product
FROM product.product

/*-- How many different product in the order_item table?
-- Order_item tablosunda ka� farkl� �r�n bulunmaktad�r? */

SELECT DISTINCT product_id, count(*) OVER (PARTITION BY product_id) number_of_product
FROM sale.order_item -- buradan sonuca ula�amad�k.

--Group by ile yapsayd�k nas�l yapacakt�m

select count(distinct product_id) Uniqueproduct
from sale.order_item

--bunu window function ile yapabilir miyiz?

select count(distinct product_id) over() Uniqueproduct
from sale.order_item  -- bu �ekilde distinct burada �al��maz. Hata verir.

--window function ile sonuca ula�mak i�in ek olarak group by yapmak gerekir. Ama group by yapmadan daha kolay bir �ekilde sonuca ula�abidi�im i�i burada group by yapmaya gerek yok.


/* Write a query that returns how many different products are in each order?
 Her sipari�te ka� farkl� �r�n oldu�unu d�nd�ren bir sorgu yaz�n? */

--Group by ile

select order_id, count(distinct product_id) Uniqueproduct,
	sum(quantity)TotalProduct
from sale.order_item
group by order_id


-- Window F. ile

select distinct order_id, count(product_id) over(PARTITION BY order_id) Uniqueproduct,
	sum(quantity) over(PARTITION BY order_id)TotalProduct
from sale.order_item


/* How many different product are in each brand in each category?
Herbir kategorideki herbir markada ka� farkl� �r�n�n bulundu�unu bulunuz? */

select distinct category_id, brand_id,
	count(*) over(PARTITION BY category_id, brand_id ) num_of_product
from product.product