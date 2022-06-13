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

--A�a��daki ��z�m 21 row d�nd�r�yor. Sistem bunu kabul etmedi.
SELECT DISTINCT SC.first_name, SC.last_name
FROM sale.order_item AS SOI, sale.orders AS SO, sale.customer AS SC
WHERE SO.order_id =SOI.order_id AND SO.customer_id =SC.customer_id
AND (SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500
AND SC.city = 'Charleston'
AND SO.order_status = 4
ORDER BY SC.last_name, SC.first_name -- 20 rows


-- A�a��daki sorgu 25 row d�nd�r�yor. Sistem bunu da kabul etmedi.	
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
	

-- �nce 'Charleston' �ehrinde ya�ayan m��terilerin customer_id sini bulal�m:

SELECT customer_id
FROM sale.customer
WHERE city='Charleston'  --49 row

-- Bu 49 ki�inin order bilgilerine bakal�m.

SELECT DISTINCT SO.order_id, SO.customer_id
FROM sale.order_item AS SOI, sale.orders AS SO
WHERE SO.customer_id IN (SELECT customer_id
						FROM sale.customer
						WHERE city='Charleston')
AND SOI.list_price > 500  --36 ROW
AND SO.order_status = 4  --36
GROUP BY SO.order_id, SO.customer_id
HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500

-- A�a��daki sorgu 49 ki�i d�nd�r�yor. Sistem bunu kabul etmedi.
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

-- Charleston �ehrinde ya�ayan ve order status'u 4 olan m��teri bilgileri
SELECT SC.customer_id, SC.first_name, SC.last_name
FROM sale.orders AS SO, sale.customer AS SC
WHERE SO.customer_id= SC.customer_id
	AND SC.city = 'Charleston'
	AND SO.order_status = 4 --36 ROWS

-- order status'u 4 ve her bir order toplam� 500USD �zerinde olanlar�n order_id leri

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


-- 2 VE �ZER� S�PAR��� OLAN M��TER�LER� G�RMEK ���N
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

-- Charleston �ehrinde ikamet eden ve order status'u 4 olan m��teri bilgileri
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


-- Charleston �ehrinde ikamet eden ve order_status=4 olan m��terilerin order bilgilerini inceleyelim.


SELECT order_id
			FROM sale.orders SO
			WHERE order_status = 4
				AND EXISTS (SELECT DISTINCT sc.customer_id
							FROM sale.customer SC
							WHERE SO.customer_id = SC.customer_id
								AND SC.city = 'Charleston')

-- Charleston �ehrinde ikamet eden ve order_status=4 olan m��terilerin order item
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
						

-- Charleston �ehrinde ikamet eden ve order_status=4 olan m��terilerin order_id'ye g�re
-- gruplanarak order baz�nda toplam tutarlar�n�n bulunmas�


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


-- Charleston �ehrinde ikamet eden ve order_status=4 olan m��terilerin order_id'ye g�re
-- grupland�ktan sonra order baz�nda toplam tutarlar� 500'den b�y�k olanlar�n�n
-- order_id lerinin bulunmas�


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

-- Charleston �ehrinde ikamet eden ve order_status=4 olan m��terilerin order baz�nda
-- toplam tutarlar� 500'den b�y�k olanlar�n�n order_id lerine g�re
-- isim ve soyisimlerinin bulunmas�

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

-- yaln�zca bir sipari�i olanlar� alm�� olabilir? yukar�daki listede 2 ve �zeri sipari�i olanlar vaard�?
-- customer_id'ye g�re gruplan�p, order say�lar� bulunarak order say�s� 1 olanlar se�ilecek

-- sadece 1 sipari�i olan customer_id leri
SELECT customer_id, count(order_id)
FROM sale.orders
GROUP BY customer_id
HAVING count(order_id) = 1

-- Charleston �ehrinde ya�ayan ve 1 tane sipari�i olan customer_id leri 

SELECT SO.customer_id
FROM sale.orders SO
WHERE EXISTS (SELECT DISTINCT sc.customer_id
				FROM sale.customer SC
				WHERE SO.customer_id = SC.customer_id
					AND SC.city = 'Charleston')
GROUP BY SO.customer_id
HAVING count(SO.order_id) =1

-- Charleston �ehrinde ya�ayan ve 1 tane sipari�i olan m��terilerin order toplamlar�n� bulal�m.

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


-- Charleston �ehrinde ya�ayan ve 1 tane sipari�i olan m��terilerin order toplam�
-- 500'den b�y�k olanlar�n order_id lerini bulal�m.

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

-- Charleston �ehrinde ya�ayan ve 1 tane sipari�i olan m��terilerin order toplam�
-- 500'den b�y�k olanlar�n isim ve soyisimlerini bulal�m.



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

--Yukar�daki sorgu 22 sat�r d�nd�r�yor. Cevap 24 sat�r olmal�!!!

-- Bir ki�inin her sipari�inin tutar� 500'�n �zerinde olanlar� nas�l buluruz?

SELECT SOI.order_id, SO.customer_id, SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) ORDER_TOTAL
FROM sale.orders SO, sale.order_item SOI
WHERE SO.order_status=SOI.order_id
GROUP BY SOI.order_id, SO.customer_id
HAVING SUM(SOI.list_price*SOI.quantity*(1-SOI.discount)) > 500

-- Charleston �ehrinde ya�ayan m��terilerin her bir order toplamlar�n� bulal�m.

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
				
-- Charleston �ehrinde ya�ayan m��terilerin her bir order toplamlar� 500'den
-- b�y�k m� kontrol�n� yaparak sonucu ayr� bir kolonda g�sterelim.

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

-- Yukar�daki sorgu sonucunda ORDER_TOTAL_GREATER de�eri 0 olan m��terilerin
-- customer_id lerini bulal�m. Buradan elde edilen sonu� en az bir order toplam�
-- 500'�n alt�nda olan ki�ileri verir.

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

-- Yukar�daki sorgu sonucunda ORDER_TOTAL_GREATER de�eri 1 olan m��terilerin
-- customer_id lerini bulal�m. Bunlardan ORDER_TOTAL_GREATER de�eri 0 olan� ��kar�nca
-- sadece t�m order toplamlar� 500 �zerinde olanlar kal�r.

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

-- ORDER_TOTAL_GREATER de�eri 1 olanlardan 0 olanlar� ��kararak kalanlar�n customer_id lerini bulal�m.


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


--24 ki�iye ait customer_id lerden isim ve soyisimleri bulal�m:

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