/* List the store names in ascending order that did not have an order between
"2018-07-22" and "2018-07-28". */

SELECT DISTINCT SS.store_name
FROM sale.store AS SS, sale.orders AS SO
WHERE SS.store_id=SO.store_id
	AND SO.store_id NOT IN (
							SELECT store_id
							FROM sale.orders
							WHERE order_date BETWEEN '2018-07-22' AND '2018-07-28'
							);

/* List customers with each order over 500$ and reside in the city of Charleston.
List customers' first name and last name ( both of the last name and first name
in ascending order). */

--Aþaðýdaki çözüm 21 row döndürüyor. Sistem bunu kabul etmedi.
SELECT DISTINCT SC.first_name, SC.last_name
FROM sale.order_item AS SOI, sale.orders AS SO, sale.customer AS SC
WHERE SO.order_id =SOI.order_id AND SO.customer_id =SC.customer_id
AND (SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500
AND SC.city = 'Charleston'
AND SO.order_status = 4
ORDER BY SC.last_name, SC.first_name -- 20 rows


-- Aþaðýdaki sorgu 25 row döndürüyor. Sistem bunu da kabul etmedi.	
SELECT DISTINCT C.first_name, C.last_name
FROM (
	SELECT SO.order_id, sum(SOI.list_price*SOI.quantity) AS Total_Order
	FROM sale.order_item AS SOI, sale.orders AS SO, sale.customer AS SC 
	WHERE SOI.order_id=SO.order_id AND SO.customer_id= SC.customer_id
	AND SC.city = 'Charleston'
	-- AND SO.order_status=4
	GROUP BY SO.order_id
	HAVING sum(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500) AS A,
	sale.orders AS B, sale.customer AS C 
	WHERE A.order_id=B.order_id AND B.customer_id= C.customer_id
	AND B.order_status = 4
ORDER BY C.last_name, C.first_name;
	

-- önce 'Charleston' þehrinde yaþayan müþterilerin customer_id sini bulalým:

SELECT customer_id
FROM sale.customer
WHERE city='Charleston'  --49 row

-- Bu 49 kiþinin order bilgilerine bakalým.

SELECT DISTINCT SO.order_id, SO.customer_id
FROM sale.order_item AS SOI, sale.orders AS SO
WHERE SO.customer_id IN (SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
AND SOI.list_price > 500  --36 ROW
AND SO.order_status = 4  --36
GROUP BY SO.order_id, SO.customer_id
HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500

-- Aþaðýdaki sorgu 49 kiþi döndürüyor. Sistem bunu kabul etmedi.
SELECT DISTINCT SC.first_name, SC.last_name
FROM sale.orders AS SO, sale.customer AS SC,
	(
	SELECT order_id, (SELECT sum(list_price*quantity*(1-discount))
				FROM sale.order_item
				WHERE SOI.order_id = order_id) AS Total_Order
FROM sale.order_item AS SOI
GROUP BY order_id) AS TP
WHERE TP.order_id = SO.order_id
	AND SO.customer_id=SO.customer_id
	AND SC.city = 'Charleston'
	AND TP.Total_Order > 500
ORDER BY SC.first_name, SC.last_name ASC
	

SELECT C.first_name, C.last_name
FROM sale.customer AS C
WHERE EXISTS(
	SELECT DISTINCT customer_id
	FROM sale.orders AS A
	WHERE EXISTS
				(
				 SELECT order_id
				 FROM  sale.order_item AS B
				 WHERE A.order_id= B.order_id
				 GROUP BY order_id
				 HAVING SUM(list_price*quantity*(1-discount)) > 500
				)
			AND C.customer_id= customer_id
			AND order_status=4)
AND C.city = 'Charleston'

ORDER BY C.last_name, C.first_name;

-- Charleston þehrinde yaþayan ve order status'u 4 olan müþteri bilgileri
SELECT SC.customer_id, SC.first_name, SC.last_name
FROM sale.orders AS SO, sale.customer AS SC
WHERE SO.customer_id= SC.customer_id
	AND SC.city = 'Charleston'
	AND SO.order_status = 4 --36 ROWS

-- order status'u 4 ve her bir order toplamý 500USD üzerinde olanlarýn order_id leri

SELECT SO.customer_id
FROM sale.order_item AS SOI, sale.orders AS SO
WHERE SOI.order_id=SO.order_id
	AND SO.order_status =4
GROUP BY SO.order_id, SO.customer_id
HAVING SUM(list_price*quantity*(1-discount)) > 500  -- 941 ROWS






SELECT SC.first_name, SC.last_name
FROM sale.orders AS SO, sale.customer AS SC,
	(SELECT order_id
	FROM sale.order_item
	GROUP BY order_id
	HAVING SUM(list_price*quantity*(1-discount)) > 500) AS A
WHERE SO.customer_id= SC.customer_id
	AND SO.order_id=A.order_id
	AND SC.city = 'Charleston'
	AND SO.order_status = 4
ORDER BY SC.last_name, SC.first_name


SELECT DISTINCT SC.first_name, SC.last_name, A.*
FROM sale.customer AS SC,
	(
	SELECT SO.order_id, SO.customer_id
	FROM sale.order_item AS SOI, sale.orders AS SO
	WHERE SOI.order_id=SO.order_id
		AND SO.order_status = 4
	GROUP BY SO.order_id, SO.customer_id
	HAVING SUM(list_price*quantity*(1-discount)) > 500
	) AS A
WHERE city='Charleston'
	AND A.customer_id = SC.customer_id


-- 2 VE ÜZERÝ SÝPARÝÞÝ OLAN MÜÞTERÝLERÝ GÖRMEK ÝÇÝN
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sale.customer c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sale.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) >= 2
    )
and city= 'Charleston'
ORDER BY
    first_name,
    last_name;

-- Charleston þehrinde ikamet eden ve order status'u 4 olan müþteri bilgileri
SELECT
    O.order_id, O.customer_id, o.order_status
FROM
    sale.orders O, sale.order_item I
WHERE
    EXISTS (
        SELECT
            customer_id
        FROM
            sale.customer C
        WHERE
            O.customer_id = C.customer_id
        AND C.city = 'Charleston'
    )
	AND order_status = 4
	AND I.order_id=O.order_id
GROUP BY O.order_id, O.customer_id, O.order_status
HAVING SUM(I.list_price*I.quantity*(1-I.discount)) > 500
ORDER BY
    O.order_id, O.customer_id;




SELECT A.first_name, A.last_name
FROM sale.customer A, sale.orders B,
	(
	SELECT DISTINCT SOI.order_id
	FROM sale.order_item SOI
	WHERE EXISTS(
			SELECT DISTINCT SO.order_id
			FROM sale.orders SO
			WHERE order_status = 4
				AND SO.order_id=SOI.order_id
				AND EXISTS (SELECT DISTINCT sc.customer_id
							FROM sale.customer SC
							WHERE SO.customer_id = SC.customer_id
								AND SC.city = 'Charleston'))
	GROUP BY SOI.order_id
	HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500
	) C
WHERE A.customer_id = B.customer_id AND B.order_id=C.order_id
ORDER BY A.last_name, A.first_name


-- Charleston þehrinde ikamet eden ve order_status=4 olan müþterilerin order bilgilerini inceleyelim.


SELECT order_id
			FROM sale.orders SO
			WHERE order_status = 4
				AND EXISTS (SELECT DISTINCT sc.customer_id
							FROM sale.customer SC
							WHERE SO.customer_id = SC.customer_id
								AND SC.city = 'Charleston')

-- Charleston þehrinde ikamet eden ve order_status=4 olan müþterilerin order item
-- bilgilerini inceleyelim.

SELECT *
FROM sale.order_item SOI
WHERE EXISTS(
SELECT order_id
			FROM sale.orders SO
			WHERE order_status = 4
				AND SOI.order_id =SO.order_id
				AND EXISTS (SELECT DISTINCT sc.customer_id
							FROM sale.customer SC
							WHERE SO.customer_id = SC.customer_id
								AND SC.city = 'Charleston'))
						

-- Charleston þehrinde ikamet eden ve order_status=4 olan müþterilerin order_id'ye göre
-- gruplanarak order bazýnda toplam tutarlarýnýn bulunmasý


SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
FROM sale.order_item SOI
WHERE EXISTS(
SELECT order_id
			FROM sale.orders SO
			WHERE order_status = 4
				AND SOI.order_id =SO.order_id
				AND EXISTS (SELECT DISTINCT sc.customer_id
							FROM sale.customer SC
							WHERE SO.customer_id = SC.customer_id
								AND SC.city = 'Charleston'))
GROUP BY SOI.order_id
HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500


-- Charleston þehrinde ikamet eden ve order_status=4 olan müþterilerin order_id'ye göre
-- gruplandýktan sonra order bazýnda toplam tutarlarý 500'den büyük olanlarýnýn
-- order_id lerinin bulunmasý


SELECT SOI.order_id
FROM sale.order_item SOI
WHERE EXISTS(
SELECT order_id
			FROM sale.orders SO
			WHERE order_status = 4
				AND SOI.order_id =SO.order_id
				AND EXISTS (SELECT DISTINCT sc.customer_id
							FROM sale.customer SC
							WHERE SO.customer_id = SC.customer_id
								AND SC.city = 'Charleston'))
GROUP BY SOI.order_id
HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500

-- Charleston þehrinde ikamet eden ve order_status=4 olan müþterilerin order bazýnda
-- toplam tutarlarý 500'den büyük olanlarýnýn order_id lerine göre
-- isim ve soyisimlerinin bulunmasý

SELECT B.first_name, B.last_name
FROM sale.orders A, sale.customer B,
	(
	SELECT SOI.order_id
	FROM sale.order_item SOI
	WHERE EXISTS(
	SELECT order_id
				FROM sale.orders SO
				WHERE order_status = 4
					AND SOI.order_id =SO.order_id
					AND EXISTS (SELECT DISTINCT sc.customer_id
								FROM sale.customer SC
								WHERE SO.customer_id = SC.customer_id
									AND SC.city = 'Charleston'))
	GROUP BY SOI.order_id
	HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500) AS C
WHERE A.customer_id=B.customer_id
	AND A.order_id = c.order_id
ORDER BY B.last_name, B.first_name

-- yalnýzca bir sipariþi olanlarý almýþ olabilir? yukarýdaki listede 2 ve üzeri sipariþi olanlar vaardý?
-- customer_id'ye göre gruplanýp, order sayýlarý bulunarak order sayýsý 1 olanlar seçilecek

-- sadece 1 sipariþi olan customer_id leri
SELECT customer_id, count(order_id)
FROM sale.orders
GROUP BY customer_id
HAVING count(order_id) = 1

-- Charleston þehrinde yaþayan ve 1 tane sipariþi olan customer_id leri 

SELECT SO.customer_id
FROM sale.orders SO
WHERE EXISTS (SELECT DISTINCT sc.customer_id
				FROM sale.customer SC
				WHERE SO.customer_id = SC.customer_id
					AND SC.city = 'Charleston')
GROUP BY SO.customer_id
HAVING count(SO.order_id) =1

-- Charleston þehrinde yaþayan ve 1 tane sipariþi olan müþterilerin order toplamlarýný bulalým.

SELECT B.order_id, SUM(B.list_price*B.quantity*(1-B.discount)) ORDER_TOTAL
FROM sale.orders AS A, sale.order_item AS B,
	(SELECT SO.customer_id
	FROM sale.orders SO
	WHERE EXISTS (SELECT DISTINCT sc.customer_id
					FROM sale.customer SC
					WHERE SO.customer_id = SC.customer_id
						AND SC.city = 'Charleston')
	GROUP BY SO.customer_id
	HAVING count(SO.order_id) =1) AS C
WHERE A. customer_id = C.customer_id
	AND A.order_id=B.order_id
GROUP BY B.order_id


-- Charleston þehrinde yaþayan ve 1 tane sipariþi olan müþterilerin order toplamý
-- 500'den büyük olanlarýn order_id lerini bulalým.

SELECT B.order_id, SUM(B.list_price*B.quantity*(1-B.discount)) ORDER_TOTAL
FROM sale.orders AS A, sale.order_item AS B,
	(SELECT SO.customer_id
	FROM sale.orders SO
	WHERE EXISTS (SELECT DISTINCT sc.customer_id
					FROM sale.customer SC
					WHERE SO.customer_id = SC.customer_id
						AND SC.city = 'Charleston')
	GROUP BY SO.customer_id
	HAVING count(SO.order_id) =1) AS C
WHERE A. customer_id = C.customer_id
	AND A.order_id=B.order_id
GROUP BY B.order_id
HAVING SUM(B.list_price*B.quantity*(1-B.discount)) >500

-- Charleston þehrinde yaþayan ve 1 tane sipariþi olan müþterilerin order toplamý
-- 500'den büyük olanlarýn isim ve soyisimlerini bulalým.



SELECT B.order_id, SUM(B.list_price*B.quantity*(1-B.discount)) ORDER_TOTAL
FROM sale.orders AS A, sale.order_item AS B,
	(SELECT SO.customer_id
	FROM sale.orders SO
	WHERE EXISTS (SELECT DISTINCT sc.customer_id
					FROM sale.customer SC
					WHERE SO.customer_id = SC.customer_id
						AND SC.city = 'Charleston')
	GROUP BY SO.customer_id
	HAVING count(SO.order_id) =1) AS C
WHERE A. customer_id = C.customer_id
	AND A.order_id=B.order_id
GROUP BY B.order_id
HAVING SUM(B.list_price*B.quantity*(1-B.discount)) >500  -- 22 rows

--Yukarýdaki sorgu 22 satýr döndürüyor. Cevap 24 satýr olmalý!!!

-- Bir kiþinin her sipariþinin tutarý 500'ün üzerinde olanlarý nasýl buluruz?

SELECT SOI.order_id, SO.customer_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) ORDER_TOTAL
FROM sale.orders SO, sale.order_item SOI
WHERE SO.order_status=SOI.order_id
GROUP BY SOI.order_id, SO.customer_id
HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500

-- Charleston þehrinde yaþayan müþterilerin her bir order toplamlarýný bulalým.

SELECT A.customer_id, B.order_id, B.ORDER_TOTAL
FROM sale.orders AS A,
	(
	SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
	FROM sale.order_item SOI, sale.orders SO
	WHERE SO.order_id=SOI.order_id
		AND SO.customer_id IN (
					SELECT customer_id
					FROM sale.customer
					WHERE city='Charleston')
GROUP BY SOI.order_id) AS B
WHERE A.order_id = B.order_id
GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
ORDER BY A.customer_id, B.order_id;
				
-- Charleston þehrinde yaþayan müþterilerin her bir order toplamlarý 500'den
-- büyük mü kontrolünü yaparak sonucu ayrý bir kolonda gösterelim.

SELECT A.customer_id, B.order_id, B.ORDER_TOTAL,
	CASE
		WHEN B.ORDER_TOTAL > 500 THEN 1
		ELSE 0
	END AS ORDER_TOTAL_GREATER
FROM sale.orders AS A,
	(
	SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
	FROM sale.order_item SOI, sale.orders SO
	WHERE SO.order_id=SOI.order_id
		AND customer_id IN (
					SELECT customer_id
					FROM sale.customer
					WHERE city='Charleston')
GROUP BY SOI.order_id) AS B
WHERE A.order_id = B.order_id
GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
ORDER BY A.customer_id, B.order_id;

-- Yukarýdaki sorgu sonucunda ORDER_TOTAL_GREATER deðeri 0 olan müþterilerin
-- customer_id lerini bulalým. Buradan elde edilen sonuç en az bir order toplamý
-- 500'ün altýnda olan kiþileri verir.

SELECT C.customer_id
FROM (
	SELECT A.customer_id, B.order_id, B.ORDER_TOTAL,
		CASE
			WHEN B.ORDER_TOTAL > 500 THEN 1
			ELSE 0
		END AS ORDER_TOTAL_GREATER
	FROM sale.orders AS A,
		(
		SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
		FROM sale.order_item SOI, sale.orders SO
		WHERE SO.order_id=SOI.order_id
			AND customer_id IN (
						SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
	GROUP BY SOI.order_id) AS B
	WHERE A.order_id = B.order_id
	GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
	) AS C
WHERE C.ORDER_TOTAL_GREATER=0

-- Yukarýdaki sorgu sonucunda ORDER_TOTAL_GREATER deðeri 1 olan müþterilerin
-- customer_id lerini bulalým. Bunlardan ORDER_TOTAL_GREATER deðeri 0 olaný çýkarýnca
-- sadece tüm order toplamlarý 500 üzerinde olanlar kalýr.

SELECT C.customer_id
FROM (
	SELECT A.customer_id, B.order_id, B.ORDER_TOTAL,
		CASE
			WHEN B.ORDER_TOTAL > 500 THEN 1
			ELSE 0
		END AS ORDER_TOTAL_GREATER
	FROM sale.orders AS A,
		(
		SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
		FROM sale.order_item SOI, sale.orders SO
		WHERE SO.order_id=SOI.order_id
			AND customer_id IN (
						SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
	GROUP BY SOI.order_id) AS B
	WHERE A.order_id = B.order_id
	GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
	) AS C
WHERE C.ORDER_TOTAL_GREATER=1

-- ORDER_TOTAL_GREATER deðeri 1 olanlardan 0 olanlarý çýkararak kalanlarýn customer_id lerini bulalým.


SELECT DISTINCT C.customer_id
FROM (
	SELECT A.customer_id, B.order_id, B.ORDER_TOTAL,
		CASE
			WHEN B.ORDER_TOTAL > 500 THEN 1
			ELSE 0
		END AS ORDER_TOTAL_GREATER
	FROM sale.orders AS A,
		(
		SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
		FROM sale.order_item SOI, sale.orders SO
		WHERE SO.order_id=SOI.order_id
			AND customer_id IN (
						SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
	GROUP BY SOI.order_id) AS B
	WHERE A.order_id = B.order_id
	GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
	) AS C
WHERE C.ORDER_TOTAL_GREATER=1
	AND C.customer_id NOT IN(SELECT C.customer_id
FROM (
	SELECT A.customer_id, B.order_id, B.ORDER_TOTAL,
		CASE
			WHEN B.ORDER_TOTAL > 500 THEN 1
			ELSE 0
		END AS ORDER_TOTAL_GREATER
	FROM sale.orders AS A,
		(
		SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
		FROM sale.order_item SOI, sale.orders SO
		WHERE SO.order_id=SOI.order_id
			AND customer_id IN (
						SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
	GROUP BY SOI.order_id) AS B
	WHERE A.order_id = B.order_id
	GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
	) AS C
WHERE C.ORDER_TOTAL_GREATER=0) --24 ROWS


--24 kiþiye ait customer_id lerden isim ve soyisimleri bulalým:

SELECT D.first_name, D.last_name
FROM sale.customer as D,
	(SELECT DISTINCT C.customer_id
FROM (
	SELECT A.customer_id, B.order_id, B.ORDER_TOTAL,
		CASE
			WHEN B.ORDER_TOTAL > 500 THEN 1
			ELSE 0
		END AS ORDER_TOTAL_GREATER
	FROM sale.orders AS A,
		(
		SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
		FROM sale.order_item SOI, sale.orders SO
		WHERE SO.order_id=SOI.order_id
			AND customer_id IN (
						SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
	GROUP BY SOI.order_id) AS B
	WHERE A.order_id = B.order_id
	GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
	) AS C
WHERE C.ORDER_TOTAL_GREATER=1
	AND C.customer_id NOT IN(SELECT C.customer_id
FROM (
	SELECT A.customer_id, B.order_id, B.ORDER_TOTAL,
		CASE
			WHEN B.ORDER_TOTAL > 500 THEN 1
			ELSE 0
		END AS ORDER_TOTAL_GREATER
	FROM sale.orders AS A,
		(
		SELECT SOI.order_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) AS ORDER_TOTAL
		FROM sale.order_item SOI, sale.orders SO
		WHERE SO.order_id=SOI.order_id
			AND customer_id IN (
						SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
	GROUP BY SOI.order_id) AS B
	WHERE A.order_id = B.order_id
	GROUP BY A.customer_id, B.order_id, B.ORDER_TOTAL
	) AS C
WHERE C.ORDER_TOTAL_GREATER=0)) as E
WHERE D.customer_id=E.customer_id
ORDER BY D.last_name, D.first_name