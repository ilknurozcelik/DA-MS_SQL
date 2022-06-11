--TRIM FONKSIYONU B�R STRING�N BA�INDAK� VE SONUNDAK� BO�LUKLARI S�LER.
-- VEYA BEL�RT�LEN STR�NG �FADELER� BA�INDAN VEYA SONUNDAN KALDIRIR.

SELECT TRIM(' CHARACTER');

SELECT ' CHARACTER';

SELECT GETDATE();

SELECT TRIM(' CHARACTER ');

SELECT TRIM(    ' CHARACTER   '  );

SELECT TRIM(    ' CHAR  ACTER   '  );  --ARADAK� BO�LU�U S�LMEZ

SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')

SELECT TRIM('X' FROM 'ABCXXDE')  --ARADAK� B�R STR�NG �FADEY� S�LMEZ

SELECT TRIM('X' FROM 'XXXXXXXABCXXDEXXXXXXXXXXXXXX')  --SADECE BA�TAK� VE SONDAK� X'LER� S�LD�.

-- LTRIM: SOLDAK� BO�LUKLARI S�LER

SELECT TRIM('      CHARACTER ');

-- RTRIM: SA�DAK� BO�LUKLARI S�LER

SELECT RTRIM('  CHARACTER       ');

-- REPLACE FONKS�YONU B�R STRING�N ��ER�S�NDE BEL�RT�LEN B�R �FADEN�N YEN�S� �LE DE���T�R�LMES�N� SA�LAR.

SELECT REPLACE('CHARACTER STRING', ' ', '/')

-- REPLACE(input_string, substring, output_string)
SELECT REPLACE('CHARA CTER STRI NG', ' ', '/')

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

--STR FONKS�YONU �LE B�R N�MER�K DE�ER� STR�NGE �EV�R�YORUZ.
SELECT STR(5454) -- BA�INDA SONUNDA TIRNAK ��ARET� OLMADI�I ���N SQL SERVER BUNU NUMER�K OLARAK ALGILAR.

SELECT STR(2135454654)

SELECT STR(133215.654645, 11, 3)--TOPLAM 11 KARAKTER, V�RG�LDEN SONRA 3 KARAKTER OLACAK

SELECT LEN(STR(2135454654789456))  --KARAKTER SAYISI BEL�RT�LMED���NDE DEFAULT OLARAK 10 KARAKTER GET�R�R.


--CAST FONKS�YONU: B�R �FADEN�N VER� T�R�N� BA�KA B�R  T�RE �EV�RMEK ���N KULLANILIR.
SELECT CAST (12345 AS CHAR)

SELECT CAST (123.65 AS INT)


-- CONVERT FONKS�YONU: VER� T�P�N� DE���T�RMEK ���N KULLANILIR.
SELECT CONVERT(int, 30.60)

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )

-- COALESCE FONKS�YONU NULL DE�ERLER ARASINDAN �LK NULL OLMAYANI BULUR VE GET�R�R.

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL)


-- NULLIF : G�R�LEN �K� PARAMETRE AYNI �SE NULL, DE��LSE �LK PARAMETREY� GET�R�R.

SELECT NULLIF(10,10)

SELECT NULLIF(10,11)

--ROUND FONKS�YONU: FLOAT DE�ERLER� YUVARLAMAK ���N KULLANILIR

SELECT ROUND(432.368, 2, 0)
SELECT ROUND(432.368, 2, 1)
SELECT ROUND(432.368, 2)

-- ISNULL : ���NE YAZILAN PARAMETRELERDEN �LK� NULL �SE �K�NC�Y� GET�R�R.
--NULL DE��LSE �LK PARAMETREY� GET�R�R.

SELECT ISNULL(NULL, 'ABC')
SELECT ISNULL('', 'ABC')

--ISNUMERIC  : DE�ERLER�N SAYISAL OLUP OLMADI�INI SORGULAMAK ���N KULLANILIR. NUMER�K �SE 1, DE��LSE 0 D�ND�R�R.

SELECT ISNUMERIC(123)

SELECT ISNUMERIC('ABC')

SELECT ISNUMERIC(STR(123))



/* JOIN*/

SELECT PP.product_id, PP.product_name, PC.category_id, PC.category_name
FROM product.product AS PP
INNER JOIN product.category AS PC
ON PP.category_id = PC.category_id


select *
from [product].[category]
left join [product].[product]
on [product].[category].[category_id] = [product].[product].[category_id]
order by [product].[category].[category_id],[product].[product].[product_id]

SELECT STA.first_name, STA.last_name, STO.store_name
FROM sale.staff AS STA
INNER JOIN sale.store AS STO
ON STA.store_id = STO.store_id


/* LEFT JOIN*/

-- H�� S�PAR�� ALMAMI� �R�NLER�N �S�MLER�N� G�RMEK ���N

SELECT PP.product_id, PP.product_name, SOI.order_id
FROM product.product AS PP
LEFT JOIN sale.order_item AS SOI
ON PP.product_id =SOI.product_id
WHERE SOI.order_id IS NULL


SELECT PP.product_id, PP.product_name, PS.store_id, PS.product_id, PS.quantity
FROM product.product AS PP
LEFT JOIN product.stock AS PS
ON PP.product_id = PS.product_id
WHERE PP.product_id > 310


SELECT PP.product_id, PP.product_name, PS.*
FROM product.product AS PP
LEFT JOIN product.stock AS PS
ON PP.product_id = PS.product_id
WHERE PP.product_id > 310

SELECT PP.product_id, PP.product_name, PS.*
FROM product.product AS PP
LEFT JOIN product.stock AS PS
ON PP.product_id = PS.product_id
WHERE PS.product_id > 310   -- 159 sat�r d�nd�rd�.

SELECT PP.product_id, PP.product_name, PS.*
FROM product.product AS PP
LEFT JOIN product.stock AS PS
ON PP.product_id = PS.product_id
WHERE PS.product_id IS NULL  -- 78 sat�r d�nd�rd�


/* RIGHT JOIN */

SELECT PP.product_id, PP.product_name, PS.*
FROM product.stock AS PS
RIGHT JOIN product.product AS PP
ON PS.product_id = PP.product_id
WHERE PP.product_id > 310

select	B.product_id, B.product_name, A.*
from	product.stock A
right join product.product B
	ON	A.product_id = B.product_id
where	B.product_id > 310


/* FULL OUTER JOIN */

-- �r�nlerin stok miktarlar� ve sipari� bilgilerini birlikte listeleyin
SELECT TOP 100 PP.product_id, PS.store_id, PS.quantity, SOI.order_id, SOI.list_price
FROM product.product AS PP
FULL OUTER JOIN product.stock AS PS
ON PP.product_id = PS.product_id
FULL OUTER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
ORDER BY PS.store_id


/* CROSS JOIN */

--stock tablosunda olmay�p product tablosunda mevcut olan �r�nlerin
-- stock tablosuna t�m storelar i�in kay�t edilmesi gerekiyor. 
--sto�u olmad��� i�in quantity leri 0 olmak zorunda
--Ve bir product id t�m store' lar�n stockuna eklenmesi gerekti�i i�in 
-- cross join yapmam�z gerekiyor.

SELECT B.store_id, A.product_id, 0 quantity  --quantity s�tunu olu�tur ve de�er olarak 0 gir
FROM product.product A
CROSS JOIN sale.store B
WHERE A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id

SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id