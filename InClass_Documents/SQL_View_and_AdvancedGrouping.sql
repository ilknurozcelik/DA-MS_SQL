/* VÝEWS */

CREATE VIEW productStock AS
SELECT PP.product_id, PP.product_name, PS.store_id,PS.quantity
FROM product.product AS PP
LEFT JOIN product.stock AS PS ON pp.product_id=PS.product_id
WHERE PP.product_id > 310;

SELECT * FROM productStock;

SELECT *
FROM dbo.productStock
WHERE store_id=1;


-- Maðaza çalýþanlarýný çalýþtýklarý maðaza bilgileriyle birlikte listeleyin
-- Çalýþan adý, soyadý, maðaza adlarýný seçin

CREATE VIEW staffStore AS
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id;

SELECT * FROM staffStore
WHERE store_name='Burkes Outlet';

/* PRODUCT MARKALARINI BULMAK ÝÇÝN*/

SELECT * FROM product.brand

-- BRAND SAYISINI BULMAK ÝÇÝN

SELECT COUNT(*) FROM product.brand

--MARKAYA GÖRE ÜRÜNLERÝ GRUPLANDIRALIM
SELECT brand_id, COUNT(*)
FROM product.product
GROUP BY brand_id

-- Her bir kategorideki toplam ürünün sayýsýný bulunuz.
SELECT category_id, COUNT(*) AS CountofProduct
FROM product.product
GROUP BY category_id

-- Her bir kategorideki toplam ürünün sayýsýný category ismi ile birlikte bulunuz.
SELECT PP.category_id, PC.category_name, COUNT(*) AS CountofProduct
FROM product.product AS PP
INNER JOIN product.category AS PC
	ON PP.category_id=PC.category_id
GROUP BY PP.category_id, PC.category_name

/* HAVING CLAUSE */
/* Gruplama yaptýktan sonra oluþan gruplar üzerinden bir filtreleme yapmak için HAVING kullanýlýr.*/


-- Model yýlý 2016 dan büyük olan ürünlerin markalara göre liste_fiyatý ortalamasýný bularak
-- liste fiyatý ortalamasý 1000^den büyük olanlarý listeleyelim


SELECT PB.brand_name, AVG(PP.list_price) AS AVG_LÝST_PRICE
FROM product.product AS PP, product.brand AS PB
WHERE PP.brand_id= PB.brand_id
 AND PP.model_year > 2016
GROUP BY PB.brand_name
HAVING AVG(PP.list_price) > 1000

SELECT COUNT(*)
FROM product.product
GROUP BY product_id
HAVING COUNT(*) > 1


--maximum list price' ý 4000' in üzerinde olan veya minimum list price' ý 500' ün altýnda olan categori id' leri getiriniz
--category name' e gerek yok.
SELECT category_id, MAX(list_price) AS MAXPRICE, MIN(list_price) AS MINPRICE
FROM product.product
GROUP BY category_id
HAVING MAX(list_price) > 4000 OR MIN(list_price) < 500;

--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.

SELECT order_id, SUM((list_price*quantity)*(1-discount)) AS NETPRICE
FROM sale.order_item
GROUP BY order_id


/* GROUPING SETS */

-- Her bir kategorideki, her bir model yýlýndaki ve 
-- her bir kategorinin model yýlýndaki toplam ürün sayýsý

SELECT category_id, model_year, COUNT(*)
FROM product.product
GROUP BY
	GROUPING SETS(
	(category_id),  --1. grup
	(model_year),  --2. grup
	(category_id, model_year) --3. grup
	);

-- model yýlý boþ olanlar : category ye göre gruplanmýþlarý bulmuþ oluruz.

SELECT category_id, model_year, COUNT(*)
FROM product.product
GROUP BY
	GROUPING SETS(
	(category_id),  --1. grup
	(model_year),  --2. grup
	(category_id, model_year) --3. grup
	)
HAVING model_year IS NULL;


/* ROLLUP */

SELECT category_id, model_year, COUNT(*)CountOfProducts
FROM product.product
GROUP BY
	ROLLUP (category_id, model_year)

-- Herbir marka id, herbir category id ve herbir model yýlý için toplam ürün sayýlarýný getiriniz.
-- Sonuç tablosunda tüm ihtimaller bulunsun.

SELECT category_id, brand_id, model_year, COUNT(*)CountOfProducts
FROM product.product
GROUP BY
	ROLLUP (category_id, brand_id, model_year)

/* CUBE */

SELECT brand_id, category_id, model_year, COUNT(*)CountOfProducts
FROM product.product
GROUP BY
	CUBE (brand_id, category_id, model_year)

/* PIVOT */

--Burada normal gruplama yapýyoruz. Bunu pivot table ile nasýl yaparýz.
SELECT model_year, COUNT(*)
FROM product.product
GROUP BY model_year

--pivot table ile model year'a göre ürün sayýlarýný getiren bir sorgu yazalým.

SELECT *
FROM (SELECT product_id, model_year
	FROM product.product) AS A
PIVOT(
	COUNT(product_id)
	FOR model_year IN
	([2018], [2019], [2020], [2021])
	) AS PIVOT_TABLE;

-- kategory ve model yýlýna göre ürün sayýlarýný getiren bir sorgu yazalým.
SELECT *
FROM (SELECT category_id, model_year, product_id
	FROM product.product) AS A
PIVOT(
	COUNT(product_id)
	FOR model_year IN
	([2018], [2019], [2020], [2021])
	) AS PIVOT_TABLE;


