/* DB INDEXING */

--önce tablonun çatýsýný oluþturuyoruz.


create table website_visitor 
(
visitor_id int,
ad varchar(50),
soyad varchar(50),
phone_number bigint,
city varchar(50)
);

DECLARE @i int = 1
DECLARE @RAND AS INT
WHILE @i<200000
BEGIN
	SET @RAND = RAND()*81
	INSERT website_visitor
		SELECT @i , 'visitor_name' + cast (@i as varchar(20)), 'visitor_surname' + cast (@i as varchar(20)),
		5326559632 + @i, 'city' + cast(@RAND as varchar(2))
	SET @i +=1
END;


--Tabloyu kontrol ediniz.

SELECT top 10*
FROM
website_visitor

/* Ýstatistikleri (Process ve time) açýyoruz, bunu açmak zorunda deðilsiniz sadece
yapýlan iþlemlerin detayýný görmek için açtýk. */

SET STATISTICS IO on
SET STATISTICS TIME on

--herhangi bir index olmadan visitor_id' ye þart verip tüm tabloyu çaðýrýyoruz


SELECT *
FROM
website_visitor
where
visitor_id = 100

--Ýndex oluþturalým:

Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id);

--index isimleri DB içinde unique olmak zorunda.

-- yukarýdaki sorguyu clustered index oluþturduktan sonra çalýþtýralým ve execution plan'a bakalým.
SELECT *
FROM
website_visitor
where
visitor_id = 100


SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'


-- Non-clustered index oluþturma
CREATE NONCLUSTERED INDEX ix_NoN_CLS_1 ON website_visitor (ad);

SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'

-- üzerinde index olmayan bir sütun eklersek

SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'


--composite index yapalým(iki ayrý alaný kullanarak)

Create unique NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (ad) include (soyad);

SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'

--sadece soyad üzerinden arama yapsaydýk

SELECT soyad
FROM
website_visitor
where
ad = 'visitor_name17'


/* DB CONNECTION*/


-- python üzerinden oluþturulan yeni tablo
select *
from [dbo].[product_new1]