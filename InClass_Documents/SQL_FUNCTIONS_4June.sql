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

-- Aþaðýdaki sorgu yukarýdaki ile ayný sonucu döndürür.
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
ORDER BY 2,1  -- ÖNCE 2. kolona göre sonra 1. kolona göre sýlamak için kolon numarasýný da kullanabiliriz.


/* Session 3 FUNCTIONS */

--DATE functions

--önce t_date_time adýnda bir tablo oluþturalým

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

-- oluþturduðumuz taboya veri insert etmek için

INSERT t_date_time
VALUES (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )

-- convert date to varchar

SELECT CONVERT(VARCHAR(10), GETDATE(), 6)  --6 BURADA GÖRMEK ÝSTEDÝÐÝMÝZ STÝL KODU

-- CONVERT VARCHAR TO DATE

SELECT CONVERT(DATE, '04 Jun 22', 6)  --'04 Jun 22' 6 stilinde bir tarih formatý old. için 6 yazdýk.


--DATE FUNCTIONS

--Functions for return date or time parts

SELECT A_DATE
		, DAY(A_DATE) DAY_
		, MONTH(A_DATE) [MONTH]
		, DATENAME(DW, A_DATE) DOW
		, DATEPART(WEEKDAY, A_DATE) WDY
		, DATENAME(MONTH, A_DATE) MON
FROM t_date_time

--FINDING DATE FORMATS (Aþaðýdaki kod ile date format listesine ulaþýlabilir)

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

--Teslimat tarihi ile sipariþ tarihi arasýndaki gün farkýný bulunuz

SELECT *, DATEDIFF(DAY, order_date, shipped_date) as Diff_of_day
FROM sale.orders

--Teslimat tarihi ile kargolama/sipariþ tarihi arasýndaki gün farký 2'den büyük olanlarý bulunuz

SELECT *, DATEDIFF(DAY, order_date, shipped_date) as Diff_of_day
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2

SELECT *, DATEDIFF(DAY, order_date, shipped_date) as Diff_of_day
FROM sale.orders
WHERE DATEDIFF(DAY, order_date, shipped_date) > 2 AND store_id=2


-- LEN, CHARINDEX, PATINDEX

SELECT LEN('CHARACTER')

SELECT LEN(' CHARACTER') --BAÞTAKÝ BOÞLUÐU SAYIYOR.

SELECT LEN(' CHARACTER ') --SONDAKÝ BOÞLUÐU DÝKKATE ALMIYOR.

---

SELECT CHARINDEX('R', 'CHARACTER')  -- ÝLK BULDUÐU R'NÝN ÝNDEX NUMARASINI GETÝRÝR

SELECT CHARINDEX('R', 'CHARACTER', 5) --5. KARAKTERDEN SONRA SAYMAYA BAÞLADIÐI ÝÇÝN ÝKÝNCÝ R NÝN ÝNDEXÝNÝ DÖNDÜRDÜ.

SELECT CHARINDEX('RA', 'CHARACTER')

SELECT CHARINDEX('R', 'CHARACTER', 5) -1

-- SONU R ÝLE BÝTEN STRÝNGLER

SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('%r', 'CHARACTER')

SELECT PATINDEX('%H%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('__A______', 'CHARACTER')

SELECT PATINDEX('%A____', 'CHARACTER')

SELECT PATINDEX('__A%', 'CHARACTER')

--LEFT, RIGHT, SUBSTRÝNG FUNCTIONS

SELECT LEFT('CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)

SELECT SUBSTRING('CHARACTER', 3, 5)  -- 3. ÝNDEXTEN BAÞLA VE 5 KARAKTER AL

SELECT SUBSTRING('CHARACTER', 4, 9)  -- 4. ÝNDEXTEN BAÞLA VE 9 KARAKTER AL. 9 KARAKTER OLMADIÐI ÝÇÝN KALANINI GETÝRDÝ.

SELECT SUBSTRING('CHARACTER IS A WORD', 4, 9)

--LOWER, UPPER, STRING_SPLIT

SELECT LOWER('CHARACTER')

SELECT UPPER('CHARACTER')

SELECT * 
FROM string_split('jack, martin, alain, owen', ',')

SELECT VALUE AS NAME
FROM string_split('jack, martin, alain, owen', ',')

---- 'character' KELÝMESÝNÝN ÝLK HARFÝNÝ BÜYÜTEN BÝR SCRÝPT YAZINIZ

SELECT UPPER(LEFT('character', 1))

SELECT UPPER(LEFT('character', 1)) + RIGHT('character',8)

SELECT UPPER(LEFT('character', 1)) + RIGHT('character',LEN('character')-1)  -- 1. ÇÖZÜM

SELECT SUBSTRING('character', 2, 9)

SELECT LOWER(SUBSTRING('character', 2, LEN('character')))  --LOWER ile eðer içinde varsa küçültüyoruz.

SELECT UPPER(LEFT('character', 1)) + LOWER(SUBSTRING('character', 2, LEN('character')))  --2. ÇÖZÜM

SELECT CONCAT(UPPER(LEFT('character', 1)), LOWER(SUBSTRING('character', 2, LEN('character'))))  -- 3. ÇÖZÜM



