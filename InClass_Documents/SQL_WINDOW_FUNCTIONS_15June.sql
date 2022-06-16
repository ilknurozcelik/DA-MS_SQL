/* WINDOW FUNCTIONS */

/* Ürünlerin stok sayýlarýný bulunuz*/

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


-- product_id'ye göre distinct yaparsak 
SELECT DISTINCT product_id, SUM(quantity) OVER(PARTITION BY product_id) AS TOTAL_AMOUNT_WF
FROM product.stock;

-- NOT: where bloðuna yazacaðýnýz þart window function uygulanmadan çalýþtýrýlýr.

/* Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz. */

--GROUP BY ÝLE
SELECT PB.brand_id, PB.brand_name, AVG(PP.list_price)
FROM product.product AS PP, product.brand AS PB -- brand name getirmeyecekseniz product.brand tablosuna gerek yok
WHERE PP.brand_id = PB.brand_id
GROUP BY PB.brand_id, PB.brand_name
ORDER BY PB.brand_name

--WINDOW F. ÝLE

SELECT DISTINCT PB.brand_id, PB.brand_name, AVG(PP.list_price) OVER(PARTITION BY PB.brand_name) AS AVG_list_price
FROM product.product AS PP, product.brand AS PB -- brand name getirmeyecekseniz product.brand tablosuna gerek yok
WHERE PP.brand_id = PB.brand_id
ORDER BY PB.brand_name

/*Markalara göre ürün sayýsýný bulalým */

SELECT *, count(*) OVER(PARTITION BY brand_id) AS COUNT_OF_PRODUCT
FROM product.product

/*Markalara göre ürün sayýsýnýlarýný ve her markadaki max ürün fiyatýný bulalým */
SELECT *, 
		count(*) OVER(PARTITION BY brand_id) AS COUNT_OF_PRODUCT,
		MAX(list_price) OVER(PARTITION BY brand_id) AS MAX_LÝST_PRICE
FROM product.product

/*markaya ve categoriye göre ürün sayýlarýný ayrý ayrý bulalým */
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

-- window function ile oluþturulan kolonlar bribirinden baðýmsýz hesaplanýr/oluþturulur.
-- dolayýsýyla ayný select bloðu içinde farklý partition lar tanýmlayarak yeni kolonlar oluþturabilirsiniz.

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

/*Farklý Frame büyüklüklerinde SQL nasýl davranýyor. Örneklerle inceleyelim. */

-- Window Frames

-- Windows frame i anlamak için birkaç örnek:
-- Herbir satýrda iþlem yapýlacak olan frame in büyüklüðünü (satýr sayýsýný) tespit edip
 -- window frame in nasýl oluþtuðunu aþaðýdaki sorgu sonucuna göre konuþalým.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,  -- partition tanýmlanmadýðý için tablonun tamamýný alýr.
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
 Herbir kategorideki en ucuz ürünün fiyatýný bulunuz? */

SELECT DISTINCT category_id, MIN(list_price) OVER (PARTITION BY category_id) cheapest_product
FROM product.product
ORDER BY category_id


/* How many different product in the product table?
 Product tablosunda toplam kaç faklý product bulunduðunu window function ile bulunuz */

SELECT DISTINCT count(*) OVER () number_of_product
FROM product.product

/*-- How many different product in the order_item table?
-- Order_item tablosunda kaç farklý ürün bulunmaktadýr? */

SELECT DISTINCT product_id, count(*) OVER (PARTITION BY product_id) number_of_product
FROM sale.order_item -- buradan sonuca ulaþamadýk.

--Group by ile yapsaydýk nasýl yapacaktým

select count(distinct product_id) Uniqueproduct
from sale.order_item

--bunu window function ile yapabilir miyiz?

select count(distinct product_id) over() Uniqueproduct
from sale.order_item  -- bu þekilde distinct burada çalýþmaz. Hata verir.

--window function ile sonuca ulaþmak için ek olarak group by yapmak gerekir. Ama group by yapmadan daha kolay bir þekilde sonuca ulaþabidiðim içi burada group by yapmaya gerek yok.


/* Write a query that returns how many different products are in each order?
 Her sipariþte kaç farklý ürün olduðunu döndüren bir sorgu yazýn? */

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
Herbir kategorideki herbir markada kaç farklý ürünün bulunduðunu bulunuz? */

select distinct category_id, brand_id,
	count(*) over(PARTITION BY category_id, brand_id ) num_of_product
from product.product