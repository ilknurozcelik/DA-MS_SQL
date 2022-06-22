/* SQL PROGRAMMING */

/* PROCEDURES */

create procedure smpl_proc_1 as 
begin
select 'Hello World!';
end
execute smpl_proc_1

-- BEGIN - END fonksiyonlarý bir sorgunun baþladýðýný ve bittiðini gösterir.
-- Birden fazla sorguyu BEGIN ve END arasýna alýrsanýz, hepsi birden çalýþýr.

drop procedure smpl_proc_1  -- procedure'ü silmek için

create procedure smpl_proc_1 as  -- procedure'ü tekrar oluþturmak için
begin
select 'Hello World 3 !'
end
execute smpl_proc_1;

alter procedure smpl_proc_1 as  -- procedure'ü tekrar oluþturmak için
begin
select 'Hello World 2 !'
end

execute smpl_proc_1;

-------
CREATE TABLE ORDER_TBL 
(
ORDER_ID TINYINT NOT NULL,
CUSTOMER_ID TINYINT NOT NULL,
CUSTOMER_NAME VARCHAR(50),
ORDER_DATE DATE,
EST_DELIVERY_DATE DATE--estimated delivery date
);

--------
INSERT INTO ORDER_TBL VALUES (1, 1, 'Adam', GETDATE()-10, GETDATE()-5 ),
						(2, 2, 'Smith',GETDATE()-8, GETDATE()-4 ),
						(3, 3, 'John',GETDATE()-5, GETDATE()-2 ),
						(4, 4, 'Jack',GETDATE()-3, GETDATE()+1 ),
						(5, 5, 'Owen',GETDATE()-2, GETDATE()+3 ),
						(6, 6, 'Mike',GETDATE(), GETDATE()+5 ),
						(7, 6, 'Rafael',GETDATE(), GETDATE()+5 ),
						(8, 7, 'Johnson',GETDATE(), GETDATE()+5 )

select *
from ORDER_TBL

-------
CREATE TABLE ORDER_DELIVERY
(
ORDER_ID TINYINT NOT NULL,
DELIVERY_DATE DATE -- tamamlanan delivery date
);

SET NOCOUNT ON  -- Basýlan verinin kaç satýr olduðu mesajýný görmemek için
INSERT ORDER_DELIVERY VALUES (1, GETDATE()-6 ),
				(2, GETDATE()-2 ),
				(3, GETDATE()-2 ),
				(4, GETDATE() ),
				(5, GETDATE()+2 ),
				(6, GETDATE()+3 ),
				(7, GETDATE()+5 ),
				(8, GETDATE()+5 )

select*
from ORDER_DELIVERY;

-- Her zaman ORDER_TBL tablosundaki satýr sayýsýný döndüren bir procedure yazalým

create procedure sp_sum_order
as
begin
select count(*) as total_order
from ORDER_TBL
end;

execute sp_sum_order;

/* procedure'de input parametresi tanýmlama */

--Parametre procedure adýnýn yanýnda parantez içinde tanýmlanýr. Baþýna @ iþareti konulmalýdýr.
create procedure sp_wantedday_order
	(
	@DAY DATE
	)
AS

begin
select count(*) as total_order
from ORDER_TBL
where ORDER_DATE = @DAY
end;

execute sp_wantedday_order '2022-06-22';

/* Procedure içinde kullanýlacak parametreleri tanýmlamak için DECLARE kullanýlýr. */
/* Tanýmlanan parametrelere deðer atamak için SET veya SELECT kullanýlýr. */

DECLARE
	@p1 INT,
	@p2 INT,
	@SUM INT

SET @p1 = 5

select @p1;

select *
from ORDER_TBL
where ORDER_ID= @p1;

--------

DECLARE
	@order_id INT,
	@customer_name nvarchar(100)

SET @order_id = 5  -- set ile deðiþkene deðer atadýk.

select @customer_name=CUSTOMER_NAME --select ile deðiþkene deðeri tablodan çektik.
from ORDER_TBL
where ORDER_ID= @order_id

select @customer_name;  -- tablodan çektiðimiz deðeri yazdýrdýk.

------------
select getdate();

EXECUTE sp_wantedday_order (select cast(getdate() as date))
;
-----------
declare
	@day date

set @day = getdate() - 2

execute sp_wantedday_order @day
------------

/* USER DEFINED FUNCTIONS */

--Metni büyük harfe çeviren bir fonksiyon yazalým
--scalar valued function
CREATE FUNCTION fnc_uppertxt
(
	@inputtext varchar(max)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	RETURN UPPER(@inputtext)
END
;

--fonksiyonu çaðýralým : içine deðer girmek zorundasýnýz.
select dbo.fnc_uppertxt('hello world!');

-- table valued function

-- Müþteri adýný parametre olarak alýp, o müþterinin alýþveriþlerini döndüren bir fonksiyon yazýnýz.

CREATE FUNCTION fnc_get_order_by_customer
(
@CUSTOMER_NAME NVARCHAR(100)
)
RETURNS TABLE
AS
	RETURN
		select *
		from ORDER_TBL
		where CUSTOMER_NAME = @CUSTOMER_NAME
;

--fonksiyonu çaðýrmak için
select *
from fnc_get_order_by_customer('Owen');

-- IF / ELSE STATEMENTS

-- Bir fonksiyon yazýnýz. Bu fonksiyon aldýðý rakamsal deðeri çift ise Çift, tek ise Tek,
-- sýfýr ise Sýfýr döndürsün.

declare
	@input int,
	@modulus int

set @input = 5

select @modulus = @input % 2
print @modulus
------------
declare
	@input int,
	@modulus int

set @input = 0

select @modulus = @input % 2
IF @input = 0
	BEGIN
	print 'Sýfýr'
	END
ELSE IF @modulus = 0
	BEGIN
	print 'Çift'
	END
ELSE print 'Tek';

----- bu sorguyu fonksiyona dönüþtürelim

CREATE FUNCTION dbo.fnc_tekcift2
(
@input int
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	declare
		-- @input int,  -- input parametresi olarak yukarýda tanýmladýk
		@modulus int,
		@return nvarchar(max)
	--set @input = 0

	select @modulus = @input % 2
	IF @input = 0
		BEGIN
		set @return='Sýfýr'
		END
	ELSE IF @modulus = 0
		BEGIN
		set @return= 'Çift'
		END
	ELSE set @return= 'Tek'
	return @return
END;

select dbo.fnc_tekcift2(100)A, dbo.fnc_tekcift2(73)B, dbo.fnc_tekcift2(0)C

/* WHILE LOOP */

-- 1'den 50'ye kadar olan sayýlarý yazdýran bir while döngüsü yazalým.

DECLARE
	@counter int

set @counter = 1

print @counter

set @counter = 2

print @counter

set @counter = 3

print @counter

------

DECLARE
	@counter int,
	@total int

set @counter = 1
set @total = 50

while @counter < @total
	begin
		print @counter
		set @counter += 1
end;


/* --Sipariþleri, tahmini teslim tarihleri ve gerçekleþen teslim tarihlerini kýyaslayarak
--'Late','Early' veya 'On Time' olarak sýnýflandýrmak istiyorum.
--Eðer sipariþin ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (gerçekleþen teslimat tarihi) küçükse
--Bu sipariþi 'LATE' olarak etiketlemek,
--Eðer EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipariþi 'EARLY' olarak etiketlemek,
--Eðer iki tarih birbirine eþitse de bu sipariþi 'ON TIME' olarak etiketlemek istiyorum.

--Daha sonradan sipariþleri, sahip olduklarý etiketlere göre farklý iþlemlere tabi tutmak istiyorum.

--istenilen bir order' ýn status' unu tanýmlamak için bir scalar valued function oluþturacaðýz.
--çünkü girdimiz order_id, çýktýmýz ise bir string deðer olan statu olmasýný bekliyoruz. */


create FUNCTION dbo.fnc_orderstatus
(
@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	declare 
		@result nvarchar(100)
		
 -- set @input = 5  -- bu deðer artýk fonksiyonun parametresi olarak gelecek.
 	select @result=
			case
				when B.DELIVERY_DATE < A.EST_DELIVERY_DATE
					then 'EARLY'
				when B.DELIVERY_DATE > A.EST_DELIVERY_DATE
					then 'LATE'
				when B.DELIVERY_DATE = A.EST_DELIVERY_DATE
					then 'ON TIME'
				else NULL end
	from ORDER_TBL A, ORDER_DELIVERY B
	where A.ORDER_ID = B.ORDER_ID AND
		A.ORDER_ID = @input
;
	return @result
END
;

select dbo.fnc_orderstatus(5)



--hoca kodu

create FUNCTION dbo.fnc_orderstatus
(
	@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	declare
		@result nvarchar(100)
	-- set @input = 1
	select	@result =
				case
					when B.DELIVERY_DATE < A.EST_DELIVERY_DATE
						then 'EARLY'
					when B.DELIVERY_DATE > A.EST_DELIVERY_DATE
						then 'LATE'
					when B.DELIVERY_DATE = A.EST_DELIVERY_DATE
						then 'ON TIME'
				else NULL end
	from	ORDER_TBL A, ORDER_DELIVERY B
	where	A.ORDER_ID = B.ORDER_ID AND
			A.ORDER_ID = @input
	;
	return @result
end
;
select	dbo.fnc_orderstatus(3)
;
select	*, dbo.fnc_orderstatus(ORDER_ID) OrderStatus
from	ORDER_TBL
;