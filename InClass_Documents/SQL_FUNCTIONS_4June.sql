SELECT * FROM product.brand
ORDER BY brand_name

SELECT * FROM product.brand
ORDER BY brand_name ASC

SELECT * FROM product.brand
ORDER BY brand_name DESC

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_id

SELECT TOP 10 *
FROM product.brand
ORDER BY brand_id DESC

SELECT *
FROM product.brand
WHERE brand_name LIKE 'S%'

SELECT *
FROM product.product
ORDER BY brand_id

SELECT *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021

SELECT *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year

SELECT TOP 1 *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year

SELECT TOP 1 *
FROM product.product
WHERE model_year BETWEEN 2019 AND 2021
ORDER BY model_year DESC

SELECT *
FROM product.product
WHERE category_id IN(3,4,5)

-- A�a��daki sorgu yukar�daki ile ayn� sonucu d�nd�r�r.
SELECT *
FROM product.product
WHERE category_id=3 OR category_id=4 OR category_id=5

SELECT *
FROM product.product
WHERE category_id NOT IN(3,4,5)

SELECT *
FROM product.product
WHERE category_id<>3 AND category_id!=4 AND category_id<>5

-- COMPOSITE KEY

SELECT *
FROM product.stock

SELECT product_id, quantity
FROM product.stock

SELECT store_id, product_id, quantity
FROM product.stock
ORDER BY 2,1  -- �NCE 2. kolona g�re sonra 1. kolona g�re s�lamak i�in kolon numaras�n� da kullanabiliriz.


/* Session 3 FUNCTIONS */

--DATE functions

--�nce t_date_time ad�nda bir tablo olu�tural�m

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

SELECT * FROM t_date_time

SELECT GETDATE() as get_date

-- olu�turdu�umuz taboya veri insert etmek i�in

INSERT t_date_time
VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )

-- convert date to varchar

SELECT CONVERT(VARCHAR(10), GETDATE(), 6)  --6 BURADA G�RMEK �STED���M�Z ST�L KODU

-- CONVERT VARCHAR TO DATE

SELECT CONVERT(DATE, '04 Jun 22', 6)  --'04 Jun 22' 6 stilinde bir tarih format� old. i�in 6 yazd�k.


--DATE FUNCTIONS

--Functions for return date or time parts

SELECT A_DATE
		, DAY(A_DATE) DAY_
		, MONTH(A_DATE) [MONTH]
		, DATENAME(DW, A_DATE) DOW
		, DATEPART(WEEKDAY, A_DATE) WDY
		, DATENAME(MONTH, A_DATE) MON
FROM t_date_time

--FINDING DATE FORMATS (A�a��daki kod ile date format listesine ula��labilir)

DECLARE @counter INT = 0
DECLARE @date DATETIME = '2006-12-30 00:38:54.840'

CREATE TABLE #dateFormats (dateFormatOption int, dateOutput nvarchar(40))

WHILE (@counter <= 150 )
BEGIN
   BEGIN TRY
      INSERT INTO #dateFormats
      SELECT CONVERT(nvarchar, @counter), CONVERT(nvarchar,@date, @counter) 
      SET @counter = @counter + 1
   END TRY
   BEGIN CATCH;
      SET @counter = @counter + 1
      IF @counter >= 150
      BEGIN
         BREAK
      END
   END CATCH
END

SELECT * FROM #dateFormats

--DATEDIFF FUNCTION

SELECT DATEDIFF(DAY, '2022-05-10', GETDATE())

SELECT DATEDIFF(SECOND, '2022-05-10', GETDATE())

--DATEADD FUNCTION

SELECT DATEADD(DAY, 5, GETDATE())

SELECT DATEADD(MINUTE, 5, GETDATE())

SELECT EOMONTH(GETDATE())

SELECT EOMONTH(GETDATE(),2)

--Teslimat tarihi ile sipari� tarihi aras�ndaki g�n fark�n� bulunuz

SELECT *, DATEDIFF(DAY, order_date, shipped_date) as Diff_of_day
FROM sale.orders

--Teslimat tarihi ile kargolama/sipari� tarihi aras�ndaki g�n fark� 2'den b�y�k olanlar� bulunuz

SELECT *, DATEDIFF(DAY, order_date, shipped_date) as Diff_of_day
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

SELECT *, DATEDIFF(DAY, order_date, shipped_date) as Diff_of_day
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2 AND store_id=2


-- LEN, CHARINDEX, PATINDEX

SELECT LEN('CHARACTER')

SELECT LEN(' CHARACTER') --BA�TAK� BO�LU�U SAYIYOR.

SELECT LEN(' CHARACTER ') --SONDAK� BO�LU�U D�KKATE ALMIYOR.

---

SELECT CHARINDEX('R', 'CHARACTER')  -- �LK BULDU�U R'N�N �NDEX NUMARASINI GET�R�R

SELECT CHARINDEX('R', 'CHARACTER', 5) --5. KARAKTERDEN SONRA SAYMAYA BA�LADI�I ���N �K�NC� R N�N �NDEX�N� D�ND�RD�.

SELECT CHARINDEX('RA', 'CHARACTER')

SELECT CHARINDEX('R', 'CHARACTER', 5) -1

-- SONU R �LE B�TEN STR�NGLER

SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('%r', 'CHARACTER')

SELECT PATINDEX('%H%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('__A______', 'CHARACTER')

SELECT PATINDEX('%A____', 'CHARACTER')

SELECT PATINDEX('__A%', 'CHARACTER')

--LEFT, RIGHT, SUBSTR�NG FUNCTIONS

SELECT LEFT('CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)

SELECT SUBSTRING('CHARACTER', 3, 5)  -- 3. �NDEXTEN BA�LA VE 5 KARAKTER AL

SELECT SUBSTRING('CHARACTER', 4, 9)  -- 4. �NDEXTEN BA�LA VE 9 KARAKTER AL. 9 KARAKTER OLMADI�I ���N KALANINI GET�RD�.

SELECT SUBSTRING('CHARACTER IS A WORD', 4, 9)

--LOWER, UPPER, STRING_SPLIT

SELECT LOWER('CHARACTER')

SELECT UPPER('CHARACTER')

SELECT * 
FROM string_split('jack, martin, alain, owen', ',')

SELECT VALUE AS NAME
FROM string_split('jack, martin, alain, owen', ',')

---- 'character' KEL�MES�N�N �LK HARF�N� B�Y�TEN B�R SCR�PT YAZINIZ

SELECT UPPER(LEFT('character', 1))

SELECT UPPER(LEFT('character', 1)) + RIGHT('character',8)

SELECT UPPER(LEFT('character', 1)) + RIGHT('character',LEN('character')-1)  -- 1. ��Z�M

SELECT SUBSTRING('character', 2, 9)

SELECT LOWER(SUBSTRING('character', 2, LEN('character')))  --LOWER ile e�er i�inde varsa k���lt�yoruz.

SELECT UPPER(LEFT('character', 1)) + LOWER(SUBSTRING('character', 2, LEN('character')))  --2. ��Z�M

SELECT CONCAT(UPPER(LEFT('character', 1)), LOWER(SUBSTRING('character', 2, LEN('character'))))  -- 3. ��Z�M



