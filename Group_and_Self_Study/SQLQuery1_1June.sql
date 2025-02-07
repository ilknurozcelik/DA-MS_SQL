USE ETRADE


SELECT *
FROM CUSTOMERS

SELECT ID, CITY
FROM CUSTOMERS

SELECT [ID], CITY
FROM CUSTOMERS

SELECT [ID], CITY, FATHERS NAME
FROM CUSTOMERS

-- YORUM SATIRI
/* YORUM SATIRI*/

--KOLON �S�MLER� �K� KEL�MEDEN OLU�UYORSA K��EL� PARANTEZ ���NDE YAZILMALIDIR.
SELECT [ID], CITY, [FATHERS NAME]  
FROM CUSTOMERS

--INSERT KOMUTU ile tabloya RECORD/KAYIT eklenir ve syntax� a�a��daki gibidir.

/*
INSERT INTO TABLENAME
(KOLON1, KOLON2, KOLON3,...)
VALUES
(DEGER1, DEGER2, DEGER3,...)


not: otomatik artan alan/kolon ad� buraya yaz�lmaz.
*/



SELECT *
FROM CUSTOMERS

-- UPDATE KOMUTU ile s�tun bilgileri de�i�tirilir.KO�UL kullan�larak belirli de�erleri de�i�tirme �eklinde de kullan�labilir.
-- UPDATE syntax� a�a��daki gibidir.

/*
UPDATE TABLENAME
SET COLUMN1=VALUE1, COLUMN2 = VALUE2....
WHERE CONDITIONS
*/

SELECT *
FROM CUSTOMERS

UPDATE CUSTOMERS
SET NATION = 'TR'

UPDATE CUSTOMERS
SET AGE = 35

UPDATE CUSTOMERS
SET NATION = 'US', AGE = 40

SELECT DATEDIFF(YEAR, '1980-12-11', '2020-01-01')
SELECT DATEDIFF(YEAR, '1980-12-11', GETDATE())

UPDATE CUSTOMERS
SET NATION = 'US', AGE = DATEDIFF(YEAR, BIRTHDATE, GETDATE())


SELECT *
FROM CUSTOMERS


-- DELETE KOMUTU �LE KO�UL BEL�RTEREK S�LME ��LEM� YAPILAB�L�R.KO�UL BEL�RT�LMEZSE TABLONUN TAMAMI S�L�N�R.
-- ANCAK �NDEX B�LG�S� S�L�NMEZ.
-- TABLOYU S�LD�KTEN SONRA YEN� VER� EKLED���N�ZDE EN SON ID DEN BA�LAYARAK YEN� ID VER�R.
/*
DELETE
FROM TABLENAME
WHERE CONDITIONS
*/

DELETE FROM CUSTOMERS

-- TRUNCATE KOMUTU �LE TABLOYU �NDEX DE�ERLER� �LE B�RL�KTE S�LER. YEN� KAYIT EKLED���N�ZDE �NDEX 1 DEN BA�LAYARAK OLU�TURULUR.
-- YAN� TRUNCATE TABLOYU TAMAMEN BO�ALTIR. �OK HIZLI B�R ��LEMD�R.
-- syntax� a�a��daki gibidir.

/*
TRUNCATE TABLE TABLENAME
*/

