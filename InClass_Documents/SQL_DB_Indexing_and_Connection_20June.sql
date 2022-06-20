/* DB INDEXING */

--�nce tablonun �at�s�n� olu�turuyoruz.


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

/* �statistikleri (Process ve time) a��yoruz, bunu a�mak zorunda de�ilsiniz sadece
yap�lan i�lemlerin detay�n� g�rmek i�in a�t�k. */

SET STATISTICS IO on
SET STATISTICS TIME on

--herhangi bir index olmadan visitor_id' ye �art verip t�m tabloyu �a��r�yoruz


SELECT *
FROM
website_visitor
where
visitor_id = 100

--�ndex olu�tural�m:

Create CLUSTERED INDEX CLS_INX_1 ON website_visitor (visitor_id);

--index isimleri DB i�inde unique olmak zorunda.

-- yukar�daki sorguyu clustered index olu�turduktan sonra �al��t�ral�m ve execution plan'a bakal�m.
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


-- Non-clustered index olu�turma
CREATE NONCLUSTERED INDEX ix_NoN_CLS_1 ON website_visitor (ad);

SELECT ad
FROM
website_visitor
where
ad = 'visitor_name17'

-- �zerinde index olmayan bir s�tun eklersek

SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'


--composite index yapal�m(iki ayr� alan� kullanarak)

Create unique NONCLUSTERED INDEX ix_NoN_CLS_2 ON website_visitor (ad) include (soyad);

SELECT ad, soyad
FROM
website_visitor
where
ad = 'visitor_name17'

--sadece soyad �zerinden arama yapsayd�k

SELECT soyad
FROM
website_visitor
where
ad = 'visitor_name17'


/* DB CONNECTION*/


-- python �zerinden olu�turulan yeni tablo
select *
from [dbo].[product_new1]