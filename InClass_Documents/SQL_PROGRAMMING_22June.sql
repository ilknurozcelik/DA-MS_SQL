/* SQL PROGRAMMING */

/* PROCEDURES */

create procedure smpl_proc_1 as 
begin
select 'Hello World!';
end
execute smpl_proc_1

-- BEGIN - END fonksiyonlar� bir sorgunun ba�lad���n� ve bitti�ini g�sterir.
-- Birden fazla sorguyu BEGIN ve END aras�na al�rsan�z, hepsi birden �al���r.

drop procedure smpl_proc_1  -- procedure'� silmek i�in

create procedure smpl_proc_1 as  -- procedure'� tekrar olu�turmak i�in
begin
select 'Hello World 3 !'
end
execute smpl_proc_1;

alter procedure smpl_proc_1 as  -- procedure'� tekrar olu�turmak i�in
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

SET NOCOUNT ON  -- Bas�lan verinin ka� sat�r oldu�u mesaj�n� g�rmemek i�in
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

-- Her zaman ORDER_TBL tablosundaki sat�r say�s�n� d�nd�ren bir procedure yazal�m

create procedure sp_sum_order
as
begin
select count(*) as total_order
from ORDER_TBL
end;

execute sp_sum_order;

/* procedure'de input parametresi tan�mlama */

--Parametre procedure ad�n�n yan�nda parantez i�inde tan�mlan�r. Ba��na @ i�areti konulmal�d�r.
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

/* Procedure i�inde kullan�lacak parametreleri tan�mlamak i�in DECLARE kullan�l�r. */
/* Tan�mlanan parametrelere de�er atamak i�in SET veya SELECT kullan�l�r. */

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

SET @order_id = 5  -- set ile de�i�kene de�er atad�k.

select @customer_name=CUSTOMER_NAME --select ile de�i�kene de�eri tablodan �ektik.
from ORDER_TBL
where ORDER_ID= @order_id

select @customer_name;  -- tablodan �ekti�imiz de�eri yazd�rd�k.

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

--Metni b�y�k harfe �eviren bir fonksiyon yazal�m
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

--fonksiyonu �a��ral�m : i�ine de�er girmek zorundas�n�z.
select dbo.fnc_uppertxt('hello world!');

-- table valued function

-- M��teri ad�n� parametre olarak al�p, o m��terinin al��veri�lerini d�nd�ren bir fonksiyon yaz�n�z.

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

--fonksiyonu �a��rmak i�in
select *
from fnc_get_order_by_customer('Owen');

-- IF / ELSE STATEMENTS

-- Bir fonksiyon yaz�n�z. Bu fonksiyon ald��� rakamsal de�eri �ift ise �ift, tek ise Tek,
-- s�f�r ise S�f�r d�nd�rs�n.

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
	print 'S�f�r'
	END
ELSE IF @modulus = 0
	BEGIN
	print '�ift'
	END
ELSE print 'Tek';

----- bu sorguyu fonksiyona d�n��t�relim

CREATE FUNCTION dbo.fnc_tekcift2
(
@input int
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	declare
		-- @input int,  -- input parametresi olarak yukar�da tan�mlad�k
		@modulus int,
		@return nvarchar(max)
	--set @input = 0

	select @modulus = @input % 2
	IF @input = 0
		BEGIN
		set @return='S�f�r'
		END
	ELSE IF @modulus = 0
		BEGIN
		set @return= '�ift'
		END
	ELSE set @return= 'Tek'
	return @return
END;

select dbo.fnc_tekcift2(100)A, dbo.fnc_tekcift2(73)B, dbo.fnc_tekcift2(0)C

/* WHILE LOOP */

-- 1'den 50'ye kadar olan say�lar� yazd�ran bir while d�ng�s� yazal�m.

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


/* --Sipari�leri, tahmini teslim tarihleri ve ger�ekle�en teslim tarihlerini k�yaslayarak
--'Late','Early' veya 'On Time' olarak s�n�fland�rmak istiyorum.
--E�er sipari�in ORDER_TBL tablosundaki EST_DELIVERY_DATE' i (tahmini teslim tarihi) 
--ORDER_DELIVERY tablosundaki DELIVERY_DATE' ten (ger�ekle�en teslimat tarihi) k���kse
--Bu sipari�i 'LATE' olarak etiketlemek,
--E�er EST_DELIVERY_DATE>DELIVERY_DATE ise Bu sipari�i 'EARLY' olarak etiketlemek,
--E�er iki tarih birbirine e�itse de bu sipari�i 'ON TIME' olarak etiketlemek istiyorum.

--Daha sonradan sipari�leri, sahip olduklar� etiketlere g�re farkl� i�lemlere tabi tutmak istiyorum.

--istenilen bir order' �n status' unu tan�mlamak i�in bir scalar valued function olu�turaca��z.
--��nk� girdimiz order_id, ��kt�m�z ise bir string de�er olan statu olmas�n� bekliyoruz. */


create FUNCTION dbo.fnc_orderstatus
(
@input int
)
RETURNS nvarchar(max)
AS
BEGIN
	declare 
		@result nvarchar(100)
		
 -- set @input = 5  -- bu de�er art�k fonksiyonun parametresi olarak gelecek.
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