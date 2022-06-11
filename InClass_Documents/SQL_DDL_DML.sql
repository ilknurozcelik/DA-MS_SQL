CREATE DATABASE LibDatabase;

USE LibDatabase;

--Create Two Schemas

CREATE SCHEMA Book;
--
CREATE SCHEMA Person;


--create Book.Book table

CREATE TABLE [Book].[Book](
	[Book_ID] [int] PRIMARY KEY NOT NULL,
	[Book_Name] [nvarchar] (50) NOT NULL,
	Author_ID INT NOT NULL,
	Publisher_ID INT NOT NULL
	);

--create Book.Author table

CREATE TABLE [Book].[Author](
	[Author_ID] [int],
	[Author_FirstName] [nvarchar](50) Not NULL,
	[Author_LastName] [nvarchar](50) Not NULL
	);
	
--create Publisher Table

CREATE TABLE [Book].[Publisher](
	[Publisher_ID] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Publisher_Name] [nvarchar] (100) NULL
	);

--create Person.Person table

CREATE TABLE [Person].[Person](
	[SSN][bigint] PRIMARY KEY NOT NULL,  --SSN: social security number
	[Person_FirstName] [nvarchar](50) NULL,
	[Person_LastName] [nvarchar](50) NULL
	);

--create Person.Loan table

CREATE TABLE [Person].[Loan](
	[SSN] BIGINT NOT NULL,
	[Book_ID] INT NOT NULL,
	PRIMARY KEY ([SSN], [Book_ID])  --Composite Key
	);

--create Person.Person_Phone table

CREATE TABLE [Person].[Person_Phone](
	[Phone_Number][bigint] PRIMARY KEY NOT NULL,
	[SSN] [bigint] NOT NULL
	);

--cretae Person.Person_Mail table

CREATE TABLE [Person].[Person_Mail](
	[Mail_ID] INT PRIMARY KEY IDENTITY(1,1),
	[Mail] NVARCHAR(MAX) NOT NULL,
	[SSN] BIGINT UNIQUE NOT NULL
	);

--INSERT : tabloya veri girilmesini sa�lar

INSERT Person.Person(SSN, Person_FirstName, Person_LastName)
VALUES(75056659595,'Zehra', 'Tekin')

--INSERT INTO �eklinde de yaz�labilirdi

INSERT INTO Person.Person  -- Kolon ismi verilmeden veri eklemek istedi�imizde t�m kolonlara veri eklendi�ini anlayarak hareket eder.
VALUES(889623212466,'Kerem','Y�lmaz')

INSERT Person.Person  --Kolon ismi belirtmeden eksik veri girmeye �al��t���m�zda hata verir.
VALUES(889623218866,'Kerem')


-- Sadece iki kolona veri girmek istedi�imizde kolon isimlerini mutlaka belirtmeliyiz.
-- Ayr�ca veri girmedi�imiz kolonun da null de�er alabiliyor olmas� gerekir. Aksi takdirde hata verir.
-- Bunlara ek olarak her kolona girdi�imiz verinin o kolonun alabilece�i veri tipine uygun olmas� gerekir.

INSERT Person.Person(SSN, Person_FirstName)
VALUES(889623218866,'Kerim')

SELECT *
FROM Person.Person

-- kolon isimleri tablodaki s�ras�ndan farkl� bir �ekilde yaz�l�rsa, verilerin de bu s�raya uygun olmas� gerekir.
INSERT Person.Person(Person_LastName, SSN, Person_FirstName) 
VALUES('Yaln�z', 639623218866,'Ahmet')

-- De�eri bilinmeyen kolonlar i�in veri girerken null yazabilirsiniz. Ancak bu kolon null de�er alabilmeli.

INSERT Person.Person VALUES(55556698752, 'Esra', Null)

--Ayn� anda birden fazla kay�t eklemek i�in

INSERT Person.Person VALUES(45356698752, 'Zeki', Null)
INSERT Person.Person VALUES(45367498752, 'Metin', Null)

--veya tek VALUES kullan�larak a�a��daki gibi de birden fazla kay�t eklenebilir.

INSERT Person.Person 
VALUES(45356571752, 'Asl�', Null),
		(45269571752, 'Kerem', Null)


-- Person_Mail tablosuna birden fazla veri eklemek i�in a�a��daki syntax kullan�labilir.
-- Ancak burada 3 s�tun olmas�na ra�men sadece 2 s�tuna veri ekliyoruz.
-- Bunun nedeni Mail_ID s�tunu tablo olu�turulurken identity olarak tan�mlanm��t�r.
-- Bu nedenle bu kolon otomatik artan de�erler i�erir.

INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)

-- �NEML� NOT:

SELECT @@IDENTITY--last process last identity number
SELECT @@ROWCOUNT--last process row count

-- SELECT ... INTO metodu ile daha �nce olu�turdu�unuz bir tablodaki de�erleri ba�ka bir tabloya ekleyebiliriz.
-- Burada da s�tun s�ras�, tipi, constraintler ve di�er kurallar yine �nemli.

SELECT *
FROM Person.Person

SELECT *
INTO Person.person_2
FROM Person.Person

SELECT *
FROM Person.person_2

--INSERT INTO SELECT komutu ile bir sorgu sonucu elde edilen verileri mevcut bir tabloya ekleyebiliriz.

INSERT Person.person_2
SELECT *
FROM Person.Person
WHERE Person_FirstName = 'Zeki'

INSERT Person.Person_2 (SSN, Person_FirstName, Person_LastName)
SELECT * FROM Person.Person where Person_FirstName like 'A%'

-- Bir tabloya default de�er girilmesi i�in a�a��daki syntax kullan�l�r.
-- Bunun i�in tablo constraintlerinin buna uygun olmas� gerekir.
-- Otomatik artan s�tunlara de�erler otomatik verilir.
-- Daha �nce tan�mlanm�� default de�erler varsa de�er belirtilmedi�inde bu de�erler eklenir.
-- Default de�er belirtilmemi�se null girer.

INSERT Book.Publisher
DEFAULT VALUES

SELECT *
FROM Book.Publisher


-----UPDATE komutu var olan bir tablonun verilerini g�ncellemek i�in kullan�l�r.

UPDATE Person.person_2
SET Person_FirstName = 'Default_name'

SELECT *
FROM Person.person_2

-- UPDATE genellikle WHERE ile yani bir ko�ul ile kullan�l�r.
UPDATE Person.person_2
SET Person_FirstName = 'Ahmet'
WHERE Person_LastName ='Yaln�z'


-- DELETE komutu ile bir tablodan veri silebiliriz.

insert Book.Publisher values ('�� Bankas� K�lt�r Yay�nc�l�k'), ('Can Yay�nc�l�k'), ('�leti�im Yay�nc�l�k')

SELECT *
FROM Book.Publisher

DELETE FROM Book.Publisher

insert Book.Publisher values ('�LET���M')

DELETE FROM Book.Publisher
WHERE Publisher_Name='�LET���M'

--DROP komutu ile bir tablo tamamen silinir.

DROP TABLE Person.person_2  --VER�LER� �LE B�RL�KTE TAMAMEN S�L�ND�

--TRUNCATE komutu ile bir tabloya format at�l�r. Yani indeksi ile birlikte t�m verileri silinir.

SELECT * FROM Book.Publisher

TRUNCATE TABLE Person.Person_Mail

TRUNCATE TABLE Person.Person

TRUNCATE TABLE Book.Publisher

--ALTER TABLE komutu ile tablo yap�s�nda de�i�iklik yap�labilir.
-- Mesela daha �nce olu�turdu�umuz tablolar�m�za costraint ekleyebiliriz.

ALTER TABLE Book.Book ADD CONSTRAINT FK_Author FOREIGN KEY(Author_ID)
	REFERENCES Book.Author (Author_ID)
--Yukar�daki komut �al��mad� ve �u hatay� verdi:
-- There are no primary or candidate keys in the referenced table 'Book.Author'
-- that match the referencing column list in the foreign key 'FK_Author'.

-- Bu hatay� ��zmek i�in �nce Book.Author tablosuna primary key eklemeliyiz.

ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)
--Bu komutta a�a��daki hatay� vererek 
-- Cannot define PRIMARY KEY constraint on nullable column in table 'Author'.
--Bunu d�zeltmek i�in:

ALTER TABLE Book.Author ALTER COLUMN Author_ID INT NOT NULL
-- Bu komut ile Book.Author tablosunun primer key olacak kolonu(Author_ID) nun k�s�tlar�n� de�i�tirdik.
-- �imdi Author_ID kolonunu PRIMARY KEY olarak tan�mlayabiliriz.

ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY(Author_ID)
-- Primary key tan�mlamas� yapt�ktan sonra da 
-- Book tablosu ile Author aras�ndaki ba�lant�y� kuracak olan Foreign Key k�s�tlamas�n� ekleyebiliriz.

ALTER TABLE Book.Book ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID)
REFERENCES Book.Author (Author_ID)
--Yukar�daki komut ile Book tablosundaki Author_ID s�tununu Author tablosundaki Author_ID referans alarak Foreign Key yapt�k.

-- Book tablosundaki Publisher_ID s�tununu da Foreign Key yapal�m:
ALTER TABLE Book.Book ADD CONSTRAINT FK_Publisher FOREIGN KEY (Publisher_ID)
REFERENCES Book.Publisher (Publisher_ID)

-- Person.Loan tablosuna SSN s�tununu fore�gn Key olarak ekleyelim:

ALTER TABLE Person.Loan ADD CONSTRAINT FK_PERSON FOREIGN KEY (SSN)
REFERENCES Person.Person (SSN)
ON UPDATE NO ACTION
ON DELETE NO ACTION

-- Person.Loan tablosuna bu sefer de Book_ID s�tununu Foreign Key olarak ekleyelim:

ALTER TABLE Person.Loan ADD CONSTRAINT FK_Boook FOREIGN KEY (Book_ID)
REFERENCES Book.Book (Book_ID)
ON UPDATE NO ACTION
ON DELETE NO ACTION

--CHECK CONSTRAINTS

SELECT *
FROM Person.Person

--Person tablosundaki SSN s�tununa almas� gerekenden az veya fazla basamakl� bir say� girilmesini �nlemek i�in

ALTER TABLE Person.Person ADD CONSTRAINT CHECK_SSN CHECK (SSN > 9999999999 AND SSN <= 99999999999)

INSERT Person.Person(SSN) VALUES (123456789) -- Burada Check constrainte tak�ld��� i�in hata verdi

INSERT Person.Person(SSN) VALUES (12345678912) -- Burada belirtilen basamak de�erleri i�inde kald��� i�in hata vermedi.

INSERT Person.Person(SSN) VALUES (123456789456789) --Burada da �st s�n�r� a�t��� i�in hata verdi.

-- Person_Phone tablosuna Foreign Key ekleyelim.

ALTER TABLE Person.Person_Phone ADD CONSTRAINT FK_Person2 FOREIGN KEY (SSN)
REFERENCES Person.Person (SSN)

--Phone Number i�in CHECK CONSTRAINT ekelyelim:

ALTER TABLE Person.Person_Phone ADD CONSTRAINT CHECK_Phone CHECK (Phone_Number > 999999999 AND Phone_Number <= 9999999999)

-- Person_Mail tablosuna Foreign Key ekleyelim.

ALTER TABLE Person.Person_Mail ADD CONSTRAINT FK_Person4 FOREIGN KEY(SSN)
REFERENCES Person.Person(SSN)


