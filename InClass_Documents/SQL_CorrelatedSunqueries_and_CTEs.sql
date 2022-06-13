/* CORRELATED SUBQUERIES */

/* EXISTS and NOT EXISTS operators ile tablolar aras� ba�lant� kurularak yap�lan subquery */

/* Apple - Pre-Owned iPad 3 - 32GB - White �r�n�n hi� sipari� verilmedi�i eyaletleri bulunuz.
Eyalet m��terilerin ikamet adreslerinden al�nacakt�r. */


-- 'Apple - Pre-Owned iPad 3 - 32GB - White'�r�n�n� alm�� m�sterilerin eyalet listesi
SELECT distinct C.state
FROM product.product AS P,
	sale.order_item AS I,
	sale.orders AS O,
	sale.customer AS C
WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND
	P.product_id=I.product_id AND
	I.order_id=O.order_id AND
	O.customer_id = C.customer_id -- 20 eyalet (20 rows)


-- t�m eyaletlerin listesi
select distinct [state]
from sale.customer C2 -- 27 eyalet (27 rows)

-- 'Apple - Pre-Owned iPad 3 - 32GB - White'�r�n�n� almam�� m��terilerin eyalet listesi
-- t�m eyalet listesinden bu �r�n� alm�� eyaletlerin listesi not exists yap�larak bulunabilir.

select distinct [state]
from sale.customer C2
where not exists (SELECT distinct c.state
			FROM product.product AS P,
				sale.order_item AS I,
				sale.orders AS O,
				sale.customer AS C
			WHERE product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' AND
				P.product_id=�.product_id AND
				I.order_id=O.order_id AND
				O.customer_id = C.customer_id AND
				C2.state = C.state
								); -- 7 eyalet (7 rows)


/*--Burkes Outlet ma�aza sto�unda bulunmay�p,
-- Davi techno ma�azas�nda bulunan �r�nlerin stok bilgilerini d�nd�ren bir sorgu yaz�n. */

-- 'Burkes Outlet' te bulunan �r�nler

SELECT P. product_id, ST.store_id, S.quantity
FROM product.product AS P, product.stock AS S, sale.store ST
WHERE ST.store_id = S.store_id AND
	S.product_id= P.product_id AND
	ST.store_name = 'Burkes Outlet' -- 442 rows

-- 'Davi techno Retail' te bulunan �r�nler

SELECT P. product_id, ST.store_id, S.quantity
FROM product.product AS P, product.stock AS S, sale.store ST
WHERE ST.store_id = S.store_id AND
	S.product_id= P.product_id AND
	ST.store_name = 'Davi techno Retail' -- 334 rows

-- 'Davi techno Retail' ma�azas�nda bulunan ancak 'Burkes Outlet' ma�azas�nda bulunmayan �r�nleri
-- not exists ile bulabiliriz.
SELECT A. product_id, C.store_id, B.quantity
FROM product.product AS A, product.stock AS B, sale.store C
WHERE C.store_id = B.store_id AND
	A.product_id= B.product_id AND
	C.store_name = 'Davi techno Retail' AND
	NOT EXISTS (
				SELECT P. product_id, ST.store_id, S.quantity
				FROM product.product AS P, product.stock AS S, sale.store ST
				WHERE ST.store_id = S.store_id AND
					S.product_id= P.product_id AND
					ST.store_name = 'Burkes Outlet' AND
					A.product_id = P.product_id AND
					S.quantity > 0 );  -- bu ma�azadaki miktar� 0'dan b�y�k olanlar� dikkate almak gerekiyor.


-- EXISTS �LE ��Z�M :
-- Burada 'Burkes Outlet' ma�azas�nda miktar� 0 olan �r�nlerin 'Davi techno Retail' ma�azas�nda
-- bulunanlar� EXISTS ile bulunmaktad�r. Yani 'Davi techno Retail' ma�azas�nda olup da 
-- 'Burkes Outlet' ma�azas�nda olmayanlar bulunmu� oluyor.,

SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
	 EXISTS ( SELECT DISTINCT A.product_id, A.store_id, A.quantity
			FROM product.stock A, sale.store B
			WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND
				PC.product_id = A.product_id AND A.quantity=0);


/* -- Brukes Outlet storedan al�n�p The BFLO Store ma�azas�ndan hi� al�nmayan �r�n var m�?
-- Varsa bu �r�nler nelerdir?
-- �r�nlerin sat�� bilgileri istenmiyor, sadece �r�n listesi isteniyor. */

-- Brukes Outlet store' dan al�nan �r�nler

SELECT DISTINCT P. product_id, ST.store_id, O.order_status
FROM product.product AS P, product.stock AS S, sale.store ST, sale.orders AS O
WHERE ST.store_id = S.store_id AND
	S.product_id= P.product_id AND
	O.store_id = ST.store_id AND
	ST.store_name = 'Burkes Outlet'

-- The BFLO Store' dan al�nan �r�nler
SELECT DISTINCT P. product_id, ST.store_id, O.order_status
FROM product.product AS P, product.stock AS S, sale.store ST, sale.orders AS O
WHERE ST.store_id = S.store_id AND
	S.product_id= P.product_id AND
	O.store_id = ST.store_id AND
	ST.store_name = 'The BFLO Store'



SELECT DISTINCT A. product_id, A.product_name
FROM product.product AS A, product.stock AS B, sale.store C, sale.orders AS D
WHERE C.store_id = B.store_id AND
	B.product_id= A.product_id AND
	D.store_id = C.store_id AND
	C.store_name = 'Burkes Outlet' AND
	NOT EXISTS (
				SELECT DISTINCT P. product_id, P.product_name
				FROM product.product AS P, product.stock AS S, sale.store ST, sale.orders AS O
				WHERE ST.store_id = S.store_id AND
					S.product_id= P.product_id AND
					O.store_id = ST.store_id AND
					ST.store_name = 'The BFLO Store' AND
					A.product_id = P.product_id);  -- 8 SATIR D�N�YOR. HATA VAR?

--Tu�ba Hoca'n�n ��z�m�

SELECT DISTINCT P.product_name
FROM product.product P,
    sale.order_item I,
    sale.orders O,
    sale.store S
WHERE store_name = �Burkes Outlet�
    AND P.product_id = I.product_id
    AND I.order_id = O.order_id
    AND O.store_id = S.store_id
    AND NOT EXISTS (SELECT PP.product_name
                    FROM product.product PP,
                        sale.order_item SI,
                        sale.orders SO,
                        sale.store SS
                    WHERE store_name = �The BFLO Store�
                        AND PP.product_id = SI.product_id
                        AND SI.order_id = SO.order_id
                        AND SO.store_id = SS.store_id
                        AND P.product_name = PP.product_name)

-- hOCANIN ��Z�M�-1

SELECT P.product_name, p.list_price, p.model_year
FROM product.product P
WHERE NOT EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
				and P.product_id = I.product_id)
	AND
	EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
				and P.product_id = I.product_id)
;

--HOCANIN ��Z�M�-2:

SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
except
		SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
;


/* CTEs: COMMON TABLE EXPRESSION */

-- ADVANTAGES

-- EASY TO READ AND USE

-- FAST

/* Jerald Berray isimli m��terinin son sipari�inden �nce sipari� vermi� 
ve Austin �ehrinde ikamet eden m��terileri listeleyin. */

SELECT MAX(B.order_date) JeraldLastOrderDate
FROM sale.customer AS A, sale.orders AS B
WHERE A.customer_id=B.customer_id AND
	A.first_name = 'Jerald' and a.last_name = 'Berray'

select *
from sale.customer AS A, sale.orders AS B
where A.city = 'Austin' AND A.customer_id=B.customer_id


-- benim kod:
with tbl AS(SELECT MAX(B.order_date) JeraldLastOrderDate
FROM sale.customer AS A, sale.orders AS B
WHERE A.customer_id=B.customer_id AND
	A.first_name = 'Jerald' and a.last_name = 'Berray')

select DISTINCT A.first_name, A.last_name
from sale.customer AS A, sale.orders AS B, tbl AS C
where A.city = 'Austin' AND A.customer_id=B.customer_id
	AND B.order_date < C.JeraldLastOrderDate;

-- HOCANIN ��Z�M�

with tbl AS (
	select	max(b.order_date) JeraldLastOrderDate
	from	sale.customer a, sale.orders b
	where	a.first_name = 'Jerald' and a.last_name = 'Berray'
			and a.customer_id = b.customer_id
)
select	distinct a.first_name, a.last_name
from	sale.customer a,
		Sale.orders b,
		tbl c
where	a.city = 'Austin' and a.customer_id = b.customer_id and
		b.order_date < c.JeraldLastOrderDate
;

/* Herbir markan�n sat�ld��� en son tarihi bir CTE sorgusunda,
 Yine herbir markaya ait ka� farkl� �r�n bulundu�unu da ayr� bir CTE sorgusunda tan�mlay�n�z.
 Bu sorgular� kullanarak  Logitech ve Sony markalar�na ait son sat�� tarihini ve
 toplam �r�n say�s�n� (product tablosundaki) ayn� sql sorgusunda d�nd�r�n�z. */

-- MARKALARIN SON S�PAR�� TAR�HLER�
SELECT PB.brand_id, PB.brand_name, MAX(SO.order_date) MAX_ORDER_DATE
FROM product.product AS PP, sale.orders AS SO, sale.order_item AS SOI, product.brand AS PB
WHERE PP.product_id = SOI.product_id AND
	SOI.order_id = SO.order_id AND
	PP.brand_id= PB.brand_id
GROUP BY PB.brand_id, PB.brand_name

--MARKALARIN TOPLAM �R�N SAYILARI
SELECT PB.brand_id, PB.brand_name, COUNT(DISTINCT PP.product_id) COUNT_OF_PRODUCT
FROM product.product AS PP, product.brand AS PB
WHERE PP.brand_id= PB.brand_id
GROUP BY PB.brand_id, PB.brand_name;


with tbl1 AS (
	SELECT PB.brand_id, PB.brand_name, MAX(SO.order_date) MAX_ORDER_DATE
	FROM product.product AS PP, sale.orders AS SO, sale.order_item AS SOI, product.brand AS PB
	WHERE PP.product_id = SOI.product_id AND
		SOI.order_id = SO.order_id AND
		PP.brand_id= PB.brand_id
	GROUP BY PB.brand_id, PB.brand_name
	),
tbl2 AS (
SELECT PB.brand_id, PB.brand_name, COUNT(*) COUNT_OF_PRODUCT
FROM product.product AS PP, product.brand AS PB
WHERE PP.brand_id= PB.brand_id
GROUP BY PB.brand_id, PB.brand_name
)
select	*
from	tbl1 A, tbl2 B
		
where	A.brand_name = 'Sony' OR A.brand_name = 'Logitech'
	AND A.brand_id = B.brand_id;
	

-- Hocan�n ��z�m�: t�m markalar i�in
with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id
;

-- Hocan�n ��z�m�: sony ve logitech i�in
with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id and
		a.brand_name in ('Logitech', 'Sony')
;


/* RECURSIVE CTE */

-- 0'dan 9'a kadar herbir rakam bir sat�rda olacak �ekide bir tablo olu�turun.

with cte AS(
	SELECT 0 AS RAKAM
	UNION ALL
	SELECT 1 RAKAM
	UNION ALL
	SELECT 2 RAKAM
	UNION ALL
	SELECT 3 RAKAM
)

SELECT * FROM CTE


with cte AS(
	SELECT 0 AS RAKAM
	UNION ALL
	SELECT RAKAM + 1
	FROM CTE
	WHERE RAKAM < 9  -- RAKAM 9'DAN K���K OLDU�U M�DDET�E RAKAM'A 1 EKLEYEREK SORGUYU �ALI�TIRIR.
)

SELECT * FROM CTE

-- 2020 Ocak ay�n�n her bir tarihi bir sat�r olacak �ekilde 31 sat�rl� bir tablo olu�turunuz.

with cte AS(
	SELECT CAST('2020-01-01' AS DATE) AS DATE_
	UNION ALL
	SELECT CAST(DATEADD(DAY, 1, DATE_) AS DATE) as DATE_
	FROM cte
	WHERE DATE_ < '2020-01-31')

SELECT * FROM cte

-- alternatif ��z�m:

with cte AS(
	SELECT CAST('2020-01-01' AS DATE) AS DATE_
	UNION ALL
	SELECT CAST(DATEADD(DAY, 1, DATE_) AS DATE) as DATE_
	FROM cte
	WHERE DATE_ < EOMONTH('2020-01-01') )

SELECT * FROM cte;

with cte AS(
	SELECT CAST('2020-01-01' AS DATE) AS DATE_
	UNION ALL
	SELECT CAST(DATEADD(DAY, 1, DATE_) AS DATE) as DATE_
	FROM cte
	WHERE DATE_ < EOMONTH('2020-01-01') )

SELECT DATE_ AS TAR�H, DAY(DATE_) AS G�N, MONTH(DATE_) AS AY, YEAR(DATE_) AS YIL,
	EOMONTH('2020-01-01') AS AYIN_SON_G�N�
FROM cte;



-- HOCANIN ��Z�M�

with cte AS (
	select cast('2020-01-01' as date) AS gun
	union all
	select DATEADD(DAY,1,gun)
	from cte
	where gun < EOMONTH('2020-01-01')
)
select gun tarih, day(gun) gun, month(gun) ay, year(gun) yil,
	EOMONTH(gun) ayinsongunu
from cte;


/* Write a query that returns all staff with their manager_ids. (use recursive CTE) */

with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte
;

/* 2018 y�l�nda t�m ma�azalar�n ortalama cirosunun alt�nda ciroya sahip ma�azalar� listeleyin.
 List the stores their earnings are under the average income in 2018. */

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;

