--DE���KEN TANIMLAMA
--SQL de de�i�ken tan�mlarken kullan�lan komut DECLARE dir.

DECLARE @ISIM AS VARCHAR(100) --de�i�kenin ad�n� yazarken @ kullan�l�r ve sonras�nda de�i�kenin tipini yazar�z.

--�imdi bu de�i�kenin de�erini �ekelim

SELECT @ISIM  --@ISIM de�i�kenini bir de�er atamad���m�z i�in NULL olarak getirir.

--De�i�keni tan�mlarken ayn� anda ba�lang�� de�eri atayabiliriz.
DECLARE @ISIM AS VARCHAR(100) ='matrix'
SELECT @ISIM

--ya da de�i�keni tan�mlay�p, sonradan de�er atayabiliriz:
DECLARE @ISIM AS VARCHAR(100)
SET @ISIM='matrix'
SELECT @ISIM

--Say�sal bir de�i�ken tan�mlayal�m:

DECLARE @SAYI AS INTEGER
SET @SAYI=15
SELECT @SAYI

--Birden fazla de�i�ken atayal�m

DECLARE 
@SAYI1 AS INTEGER,
@SAYI2 AS INTEGER
SET @SAYI1=10
SET @SAYI2=20
SELECT @SAYI1,@SAYI2

--VEYA

DECLARE @SAYI1 AS INTEGER
SET @SAYI1=10
DECLARE @SAYI2 AS INTEGER
SET @SAYI2=20
SELECT @SAYI1 AS SAYI_1,@SAYI2 AS SAYI_2, @SAYI1 + @SAYI2 AS TOPLAM

--Toplam� da bir de�i�kene atayabiliriz:

DECLARE @SAYI1 AS INTEGER
SET @SAYI1=10
DECLARE @SAYI2 AS INTEGER
SET @SAYI2=20
DECLARE @TOPLAM AS INTEGER
SET @TOPLAM = @SAYI1 + @SAYI2

SELECT @SAYI1 AS SAYI_1,@SAYI2 AS SAYI_2, @TOPLAM AS TOPLAM
--Yukar�daki select ifadesini tek ba��na �al��t�rd���m�zda hata verecektir.

--Birden fazla de�i�ken tan�mlaman�n bir di�er yolu:

DECLARE 
@SAYI1 AS INTEGER,
@SAYI2 AS INTEGER,
@TOPLAM AS INTEGER
SET @SAYI1=10
SET @SAYI2=20
SET @TOPLAM = @SAYI1 + @SAYI2
SELECT @SAYI1 AS SAYI_1,@SAYI2 AS SAYI_2, @TOPLAM AS TOPLAM

--Her seferde declare yazd����m�z gibi tek seferde declare yaz�p de�i�kenlere de�erler atayabiliriz.
--�u ana kadar de�i�kenlere statik de�erler atad�k.
--Ayn� �ekilde veri tablolar�ndan d�nen de�erleri de de�i�kenlere atayabiliriz.

USE SampleRetail
GO

SELECT * FROM sale.customer

DECLARE 
@first_name AS VARCHAR(255), --1 NOLU K���N�N ADINI,SOYADINI VE TELEFON NUMARASINI DE���KENLERE ATAYALIM
@last_name AS VARCHAR(255),
@phone AS VARCHAR(25)

SELECT @first_name=first_name, @last_name = last_name, @phone = phone
FROM sale.customer 
WHERE customer_id = 1
--Buraya kadar sorgu �ekmiyoruz yaln�zca tablodan d�nen bir de�eri de�i�kene at�yoruz.
--�imdi de�i�kenlere atad���m�z de�erleri �ekelim:
SELECT @first_name, @last_name, @phone

--Tablodan birden fazla de�er d�nerse son de�eri al�r:
DECLARE 
@first_name AS VARCHAR(255), --1 NOLU K���N�N ADINI,SOYADINI VE TELEFON NUMARASINI DE���KENLERE ATAYALIM
@last_name AS VARCHAR(255),
@phone AS VARCHAR(25)

SELECT @first_name=first_name, @last_name = last_name, @phone = phone
FROM sale.customer 
--WHERE customer_id = 1

SELECT @first_name, @last_name, @phone


--Bir tane de datetime t�r�nde bir de�i�ken tan�mlayal�m:

DECLARE @TARIH AS DATETIME
SET @TARIH = GETDATE()

SELECT @TARIH










