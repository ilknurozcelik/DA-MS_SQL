/* 
WINDOW FUNCTIONS
 SESSION 2

*/

select distinct category_id, brand_id, count(*) over(partition by category_id, brand_id) num_of_prod
from product.product


/* aggregate fonksiyonlarda order by kullanmak zorunlu deðil. */

/* navigasyon fonksiyonlarýnda order by kullanmak zorunlu. */

/* write a query that returns most stocked product ids in each store with first_value function */

-- with max agg. function
select distinct ps.store_id, max(ps.quantity) over(partition by ps.store_id)
from product.product as pp, product.stock as ps
where pp.product_id = ps.product_id  -- BURADA ÜRÜNLERÝN MÝKTARLARI GELDÝ.
--BÝZDEN ÝSTENEN STOKTA EN ÇOK BULUNAN ÜRÜNLERÝ(YANÝ ID'LERÝNÝ GETÝRMEK)
--BUNUN ÝÇÝN DE WINDOW FUNC. KULLANMALIYIZ.


select distinct store_id, max(quantity) over (partition by store_id)
from product.stock -- BU DA WÝNDOW FUNCTION ÝLE MÝKTARI EN ÇOK OLANLARI GETÝRMEK ÝÇÝN 

select distinct store_id, product_id, max(quantity)
from product.stock
group by store_id, product_id
order by max(quantity) desc

select distinct store_id, max(quantity)
from product.stock
group by store_id  --SADECE STOK TABLOSUNU KULLANARAK STOKTA EN ÇOK BULUNAN ÜRÜN MÝKTARLARINI GETÝRMEK ÝÇÝN

-- with first_value function
-- ile store_id'ye göre gruplayýp, quantity'ye göre azalan bir þekilde sýraladýðýmýzda stoktaki miktarý
-- en çok olan ürünün id'sini getirebiliriz.
select distinct store_id,
	first_value(product_id) over(partition by store_id order by quantity desc) most_stocked_product
from product.stock


--product_id ile miktarlarýný da bulalým
select distinct store_id,
	first_value(product_id) over(partition by store_id order by quantity desc) most_stocked_product,
	first_value(product_id) over(order by quantity desc) msp_wt
from product.stock


/*Write a query that returns customers and their most valuable order with total amount of it. */


-- group by ile : burada bir müþteri için tüm sipariþ miktarlarýný görüyoruz.
-- buradan first value yaparak max. deðerlere ulaþabiliriz.

select so.customer_id, so.order_id, sum(soý.list_price*soý.quantity*(1-soý.discount)) net_price
from sale.orders as so, sale.order_item as soý
where so.order_id=soý.order_id
group by so.customer_id, so.order_id
order by so.customer_id, sum(soý.list_price) desc

-- yukarýdaki sorguyu cte 'ye alarak first_value'larý alalým

with T1 as(
	select so.customer_id, so.order_id, sum(soý.list_price*soý.quantity*(1-soý.discount)) net_price
	from sale.orders as so, sale.order_item as soý
	where so.order_id=soý.order_id
	group by so.customer_id, so.order_id)
select distinct customer_id,
	first_value(order_id) over (partition by customer_id order by net_price desc) as mv_order,
	first_value(net_price) over (partition by customer_id order by net_price desc) as mv_net_price
from T1;



/* Aylara göre ilk sipariþ gününü getiren bir sorgu yazýnýz. */

select year(order_date), order_date
from sale.orders
group by year(order_date), order_date -- group by ile bu yapýlamýyor.

-- first_value window func. ile
select distinct year(order_date) YEAR_, month(order_date) MONTH_,
	first_value(order_date) over (partition by year(order_date), month(order_date) order by order_date) FIRST_ORDER_DATE
from sale.orders


/* LAST_VALUE 

Bu fonksiyonu kullanýrken mutlaka frame belirtmemiz gerekiyor. Yoksa default frame'e
(RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) göre çalýþtýðý
için doðru sonuç vermiyor.*/

/* write a query that returns most stocked product in each store
last_value() window func. ile çözelim*/

select distinct store_id,
	last_value(product_id) over (partition by store_id order by quantity asc, product_id desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_product
from product.stock

--HOCA KODU

SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock
-------
SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock

/* LAG() FUNCTION */

/* LEAD() FUNCTION */

/* Her eleman için sipariþlerinin bir önceki sipariþ tarihlerini yazdýran bir sorgu yazýnýz */
/* --Write a query that returns the order date of the one previous sale of each staff
(use de LAG function). */

select so.order_id, ss.staff_id, ss.first_name, ss.last_name, so.order_date,
	lag(so.order_date) over (partition by ss.staff_id order by so.order_date) as prev_order_date  -- sipariþlere göre (yani önceki sipariþ tarihine göre) sýralamamýz lazým.
from sale.orders as so, sale.staff as ss
where so.staff_id=ss.staff_id

/* Write a query that returns the order date of the one next sale of each staff (use the LEAD function) */

select so.order_id, ss.staff_id, ss.first_name, ss.last_name, so.order_date,
	lead(so.order_date) over (partition by ss.staff_id order by so.order_id) as prev_order_date  -- sipariþlere göre (yani önceki sipariþ tarihine göre) sýralamamýz lazým.
from sale.orders as so, sale.staff as ss
where so.staff_id=ss.staff_id


/* HOCA KODU */
--Write a query that returns the order date of the one previous sale of each staff (use the LAG function)
SELECT	A.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY A.order_id) prev_order
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
--Write a query that returns the order date of the one next sale of each staff (use the LEAD function)
SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date,
		LEAD(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_id) next_order_date
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
;

/* SQL ATASÖZÜ : 
Son database'e SQL sorgusu yazýldýðýnda,
Son data frame'e EDA yapýldýðýnda,
Son model train edildiðinde, 
data scientistler 0 ve 1 lerin yenmeyen þeyler olduðunu anlayacak...
*/

/* SQL ESPRÝLERÝ:
---
GÖREVÝMÝZ SQL
----

SELECT SQL_FILES
FROM CANSIN
WHERE SLACK
GROUP BY DS11/22_EU
----

SELECT A.SQL_lecture_notes, B.usefultips, C.code_snippets
FROM master_cansin A, master_allen B, master_serdar C
WHERE slack;

*/



