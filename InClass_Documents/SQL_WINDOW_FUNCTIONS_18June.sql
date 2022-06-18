/*  WINDOW FUNCTIONS -3 */
/* SESSION 11 */

--ROW_NUMBER()

/* --Assign an ordinal number to the product prices for each category in ascending order
--1. Herbir kategori i�inde �r�nlerin fiyat s�ralamas�n� yap�n�z (artan fiyata g�re 1'den
ba�lay�p birer birer artacak) */

select product_id, category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) RowNumber
from product.product
--order by 2,3  --partition i�inde order by yapt���m�z i�in buna gerek kalmad�

--RANK()
/* Ayn� soruyu ayn� fiyatl� �r�nler ayn� s�ra numaras�n� alacak �ekilde yap�n�z 
(RANK fonksiyonunu kullan�n�z) */
select product_id, category_id, list_price,
	RANK() OVER(PARTITION BY category_id ORDER BY list_price) RankPrice
from product.product


--DENSE_RANK()

/* Ayn� soruyu ayn� fiyatl� �r�nler ayn� s�ra numaras�n� alacak �ekilde yap�n�z 
(RANK fonksiyonunu kullan�n�z) */

select product_id, category_id, list_price,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) Dense_RankPrice
from product.product


--ROW_NUMBER, RANK AND DENSE_RANK TOGETHER

select product_id, category_id, list_price,
	ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) RowNumber,
	RANK() OVER(PARTITION BY category_id ORDER BY list_price) RankPrice,
	DENSE_RANK() OVER(PARTITION BY category_id ORDER BY list_price) Dense_RankPrice
from product.product


/*CUME_DIST */

/*PERCENT_RANK */

/*NTILE */


/* 1. Herbir model_yili i�inde �r�nlerin fiyat s�ralamas�n� yap�n�z (artan fiyata g�re 1'den
ba�lay�p birer birer artacak)
row_number(), rank(), dense_rank() ile yap�n�z */

select product_id, model_year, list_price,
	ROW_NUMBER() OVER(PARTITION BY model_year ORDER BY list_price) RowNumber,
	RANK() OVER(PARTITION BY model_year ORDER BY list_price) RankPrice,
	DENSE_RANK() OVER(PARTITION BY model_year ORDER BY list_price) Dense_RankPrice
from product.product;

/* Write a query that returns the cumulative distribution of the list price in product table by brand.

product tablosundaki list price' lar�n k�m�latif da��l�m�n� marka k�r�l�m�nda hesaplay�n�z */

select brand_id, list_price,
	ROUND(CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price), 3) CUM_DIST
from product.product;


--Yukar�daki soruyu PERCENT_RANK ile yapal�m

select brand_id, list_price,
	ROUND(CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price), 3) CUM_DIST,
	ROUND(PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price), 3) PERCENT_RANK
from product.product;

-- CUME_DIST = ROW_NUM/TOTAL ROW_NUMBER
-- PERCENT_RANK = (ROW_NUM-1) / (TOTAL ROW_NUM-1)

-- Yukar�daki sorguda CumDist alan�n� CUME_DIST fonksiyonunu kullanmadan hesaplay�n�z.

select brand_id, list_price,
	count(*) over (partition by brand_id) TotalProductInBrand,
	row_number() over (partition by brand_id order by list_price) RowNum,
	rank() over (partition by brand_id order by list_price) RankNum
from product.product

with tbl as (
	select brand_id, list_price,
		count(*) over (partition by brand_id) TotalProductInBrand,
		row_number() over (partition by brand_id order by list_price) RowNum,
		rank() over (partition by brand_id order by list_price) RankNum
	from product.product
)
select *,
	round((cast(RowNum as float) / TotalProductInBrand) , 3),
	cast((1.0*RankNum / TotalProductInBrand) as decimal(4,3))
from tbl


/* Write a query that returns both of the followings:
 The average product price of orders.
 Average net amount.
---- 
A�a��dakilerin her ikisini de d�nd�ren bir sorgu yaz�n:
Sipari�lerin ortalama �r�n fiyat�.
Ortalama net tutar. */

select distinct order_id,
	avg(list_price) over(partition by order_id) Avg_price,
	avg(list_price*quantity*(1-discount)) over() Avg_net_amount
from sale.order_item

/*Ortalama �r�n fiyat�n�n ortalama net tutardan y�ksek olanlar�n� listeleyiniz.

List orders for which the average product price is higher than the average net amount*/

with tbl as (
	select distinct order_id,
		avg(list_price) over(partition by order_id) Avg_price,
		avg(list_price*quantity*(1-discount)) over() Avg_net_amount
	from sale.order_item
)
select *
from tbl
where Avg_price > Avg_net_amount
order by Avg_price;


/* Calculate stores' weekly cumulative number of orders for 2018*/

with tbl as (
	select distinct ss.store_id, ss.store_name, datepart(ISO_WEEK, so.order_date) week_of_year,
		count(*) over (partition by ss.store_id, datepart(ISO_WEEK, so.order_date)) weeks_order
	from sale.orders as so, sale.store as ss
	where so.store_id=ss.store_id AND
		year(so.order_date) = 2018
)
select distinct *,
	CUME_DIST() over (partition by week_of_year order by weeks_order) cume_total_order
from tbl; -- bu istenen sonucu vermedi.

--HOCA KODU

select distinct ss.store_id, ss.store_name,
		datepart(ISO_WEEK, so.order_date) week_of_year,
		count(*) over (partition by ss.store_id, datepart(ISO_WEEK, so.order_date)) weeks_order,
		count(*) over (partition by ss.store_id order by datepart(ISO_WEEK, so.order_date) )
from sale.orders as so, sale.store as ss
where so.store_id=ss.store_id AND
	ss.store_name = 'Davi Techno Retail' AND
	year(so.order_date) = 2018


/*Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12' */

with tbl as (
	select distinct so.order_date,
		sum(so�.quantity) over (partition by so.order_date) SumQuantity
	from sale.order_item as so�, sale.orders as so
	where so�.order_id=so.order_id AND
		order_date between '2018-03-12' and '2018-04-12'
)
select *,
	avg(SumQuantity) over (order by order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)  -- current row ile birlikte 7 sat�r yap�yor
from tbl;


--ileri do�ru 7 g�n ortl. alarak
with tbl as (
	select distinct so.order_date,
		sum(so�.quantity) over (partition by so.order_date) SumQuantity
	from sale.order_item as so�, sale.orders as so
	where so�.order_id=so.order_id AND
		order_date between '2018-03-12' and '2018-04-12'
)
select *,
	avg(SumQuantity) over (order by order_date ROWS BETWEEN CURRENT ROW and 6 FOLLOWING)  -- current row ile birlikte 7 sat�r yap�yor
from tbl;


/* HOCA KODU */

--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' aras�nda sat�lan �r�n say�s�n�n 7 g�nl�k hareketli ortalamas�n� hesaplay�n.
with tbl as (
	select	B.order_date, sum(A.quantity) SumQuantity --A.order_id, A.product_id, A.quantity
	from	sale.order_item A, sale.orders B
	where	A.order_id = B.order_id
	group by B.order_date
)
select	*,
	avg(SumQuantity) over(order by order_date rows between 6 preceding and current row) sales_moving_average_7
from	tbl
where	order_date between '2018-03-12' and '2018-04-12'
order by 1

--eksik tarihler ???

-- 2018-03-12'den �nceki tarihlerdeki ortalamalar� da almak istiyorsak where blo�unu bir outer query'de kullanmak gerekirdi.
-- �rnek:

with tbl as (
	select	B.order_date, sum(A.quantity) SumQuantity --A.order_id, A.product_id, A.quantity
	from	sale.order_item A, sale.orders B
	where	A.order_id = B.order_id
	group by B.order_date
)
select	*
from	(
	select	*,
		avg(SumQuantity*1.0) over(order by order_date rows between 6 preceding and current row) sales_moving_average_7
	from	tbl
) A
where	A.order_date between '2018-03-12' and '2018-04-12'
order by 1


/* List customers whose have at least two consequtive orders are not shipped */

with tbl as(
	select customer_id, order_date, shipped_date,
		count(order_date) over(partition by customer_id) count_of_order,
		count(shipped_date) over(partition by customer_id  order by order_date, shipped_date rows between current row and 2 following) shipped_count
	from sale.orders
)
select customer_id, sum(shipped_count)
from tbl
where count_of_order=3  -- en az �� sipari�i olanlar
group by customer_id
having sum(shipped_count) = 1


/*Write a query that returns the highest turnover amount for each week on a yearly basis*/

select year(so.order_date) ord_year, DATEPART(ISO_WEEK, so.order_date)ord_week, so.order_date, so�.list_price, so�.quantity,
	count(*) over (partition by year(so.order_date), DATEPART(ISO_WEEK, so.order_date), so.order_date) order_count
from sale.orders as so, sale.order_item as so�
where so.order_id=so�.order_id


with tbl as(
	select year(so.order_date) ord_year, DATEPART(ISO_WEEK, so.order_date)ord_week, so.order_date, so�.list_price, so�.quantity, so�.discount,
		count(*) over (partition by year(so.order_date), DATEPART(ISO_WEEK, so.order_date), so.order_date) order_count
	from sale.orders as so, sale.order_item as so�
	where so.order_id=so�.order_id
)
select ord_year, ord_week, order_date, sum(list_price*quantity) daily_sum
from tbl
group by ord_year, ord_week, order_date
order by ord_year, ord_week, order_date


with tbl as(
	select year(so.order_date) ord_year, DATEPART(ISO_WEEK, so.order_date)ord_week, so.order_date, so�.list_price, so�.quantity, so�.discount,
		count(*) over (partition by year(so.order_date), DATEPART(ISO_WEEK, so.order_date), so.order_date) order_count
	from sale.orders as so, sale.order_item as so�
	where so.order_id=so�.order_id
),
tbl2 as (
	select distinct ord_year, ord_week, order_date,
		sum(list_price*quantity) over(partition by ord_year, ord_week, order_date)daily_sum
	from tbl
)
select distinct ord_year, ord_week,
	max(daily_sum) over(partition by ord_year, ord_week)highest_turnover
from tbl2
