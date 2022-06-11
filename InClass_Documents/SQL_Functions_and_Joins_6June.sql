--TRIM FONKSIYONU BÝR STRINGÝN BAÞINDAKÝ VE SONUNDAKÝ BOÞLUKLARI SÝLER.
-- VEYA BELÝRTÝLEN STRÝNG ÝFADELERÝ BAÞINDAN VEYA SONUNDAN KALDIRIR.

SELECT TRIM(' CHARACTER');

SELECT ' CHARACTER';

SELECT GETDATE();

SELECT TRIM(' CHARACTER ');

SELECT TRIM(    ' CHARACTER   '  );

SELECT TRIM(    ' CHAR  ACTER   '  );  --ARADAKÝ BOÞLUÐU SÝLMEZ

SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')

SELECT TRIM('X' FROM 'ABCXXDE')  --ARADAKÝ BÝR STRÝNG ÝFADEYÝ SÝLMEZ

SELECT TRIM('X' FROM 'XXXXXXXABCXXDEXXXXXXXXXXXXXX')  --SADECE BAÞTAKÝ VE SONDAKÝ X'LERÝ SÝLDÝ.

-- LTRIM: SOLDAKÝ BOÞLUKLARI SÝLER

SELECT TRIM('      CHARACTER ');

-- RTRIM: SAÐDAKÝ BOÞLUKLARI SÝLER

SELECT RTRIM('  CHARACTER       ');

-- REPLACE FONKSÝYONU BÝR STRINGÝN ÝÇERÝSÝNDE BELÝRTÝLEN BÝR ÝFADENÝN YENÝSÝ ÝLE DEÐÝÞTÝRÝLMESÝNÝ SAÐLAR.

SELECT REPLACE('CHARACTER STRING', ' ', '/')

-- REPLACE(input_string, substring, output_string)
SELECT REPLACE('CHARA CTER STRI NG', ' ', '/')

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

--STR FONKSÝYONU ÝLE BÝR NÜMERÝK DEÐERÝ STRÝNGE ÇEVÝRÝYORUZ.
SELECT STR(5454) -- BAÞINDA SONUNDA TIRNAK ÝÞARETÝ OLMADIÐI ÝÇÝN SQL SERVER BUNU NUMERÝK OLARAK ALGILAR.

SELECT STR(2135454654)

SELECT STR(133215.654645, 11, 3)--TOPLAM 11 KARAKTER, VÝRGÜLDEN SONRA 3 KARAKTER OLACAK

SELECT LEN(STR(2135454654789456))  --KARAKTER SAYISI BELÝRTÝLMEDÝÐÝNDE DEFAULT OLARAK 10 KARAKTER GETÝRÝR.


--CAST FONKSÝYONU: BÝR ÝFADENÝN VERÝ TÜRÜNÜ BAÞKA BÝR  TÜRE ÇEVÝRMEK ÝÇÝN KULLANILIR.
SELECT CAST (12345 AS CHAR)

SELECT CAST (123.65 AS INT)


-- CONVERT FONKSÝYONU: VERÝ TÝPÝNÝ DEÐÝÞTÝRMEK ÝÇÝN KULLANILIR.
SELECT CONVERT(int, 30.60)

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(),112 )

SELECT CAST ('20201010' AS DATE)

SELECT CONVERT (NVARCHAR, CAST ('20201010' AS DATE),103 )

-- COALESCE FONKSÝYONU NULL DEÐERLER ARASINDAN ÝLK NULL OLMAYANI BULUR VE GETÝRÝR.

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL)


-- NULLIF : GÝRÝLEN ÝKÝ PARAMETRE AYNI ÝSE NULL, DEÐÝLSE ÝLK PARAMETREYÝ GETÝRÝR.

SELECT NULLIF(10,10)

SELECT NULLIF(10,11)

--ROUND FONKSÝYONU: FLOAT DEÐERLERÝ YUVARLAMAK ÝÇÝN KULLANILIR

SELECT ROUND(432.368, 2, 0)
SELECT ROUND(432.368, 2, 1)
SELECT ROUND(432.368, 2)

-- ISNULL : ÝÇÝNE YAZILAN PARAMETRELERDEN ÝLKÝ NULL ÝSE ÝKÝNCÝYÝ GETÝRÝR.
--NULL DEÐÝLSE ÝLK PARAMETREYÝ GETÝRÝR.

SELECT ISNULL(NULL, 'ABC')
SELECT ISNULL('', 'ABC')

--ISNUMERIC  : DEÐERLERÝN SAYISAL OLUP OLMADIÐINI SORGULAMAK ÝÇÝN KULLANILIR. NUMERÝK ÝSE 1, DEÐÝLSE 0 DÖNDÜRÜR.

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

-- HÝÇ SÝPARÝÞ ALMAMIÞ ÜRÜNLERÝN ÝSÝMLERÝNÝ GÖRMEK ÝÇÝN

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
WHERE PS.product_id > 310   -- 159 satýr döndürdü.

SELECT PP.product_id, PP.product_name, PS.*
FROM product.product AS PP
LEFT JOIN product.stock AS PS
ON PP.product_id = PS.product_id
WHERE PS.product_id IS NULL  -- 78 satýr döndürdü


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

-- Ürünlerin stok miktarlarý ve sipariþ bilgilerini birlikte listeleyin
SELECT TOP 100 PP.product_id, PS.store_id, PS.quantity, SOI.order_id, SOI.list_price
FROM product.product AS PP
FULL OUTER JOIN product.stock AS PS
ON PP.product_id = PS.product_id
FULL OUTER JOIN sale.order_item AS SOI
ON PP.product_id = SOI.product_id
ORDER BY PS.store_id


/* CROSS JOIN */

--stock tablosunda olmayýp product tablosunda mevcut olan ürünlerin
-- stock tablosuna tüm storelar için kayýt edilmesi gerekiyor. 
--stoðu olmadýðý için quantity leri 0 olmak zorunda
--Ve bir product id tüm store' larýn stockuna eklenmesi gerektiði için 
-- cross join yapmamýz gerekiyor.

SELECT B.store_id, A.product_id, 0 quantity  --quantity sütunu oluþtur ve deðer olarak 0 gir
FROM product.product A
CROSS JOIN sale.store B
WHERE A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id

SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id