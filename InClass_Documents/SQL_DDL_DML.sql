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

--INSERT : tabloya veri girilmesini saðlar

INSERT Person.Person(SSN, Person_FirstName, Person_LastName)
VALUES(75056659595,'Zehra', 'Tekin')

--INSERT INTO þeklinde de yazýlabilirdi

INSERT INTO Person.Person  -- Kolon ismi verilmeden veri eklemek istediðimizde tüm kolonlara veri eklendiðini anlayarak hareket eder.
VALUES(889623212466,'Kerem','Yýlmaz')

INSERT Person.Person  --Kolon ismi belirtmeden eksik veri girmeye çalýþtýðýmýzda hata verir.
VALUES(889623218866,'Kerem')


-- Sadece iki kolona veri girmek istediðimizde kolon isimlerini mutlaka belirtmeliyiz.
-- Ayrýca veri girmediðimiz kolonun da null deðer alabiliyor olmasý gerekir. Aksi takdirde hata verir.
-- Bunlara ek olarak her kolona girdiðimiz verinin o kolonun alabileceði veri tipine uygun olmasý gerekir.

INSERT Person.Person(SSN, Person_FirstName)
VALUES(889623218866,'Kerim')

SELECT *
FROM Person.Person

-- kolon isimleri tablodaki sýrasýndan farklý bir þekilde yazýlýrsa, verilerin de bu sýraya uygun olmasý gerekir.
INSERT Person.Person(Person_LastName, SSN, Person_FirstName) 
VALUES('Yalnýz', 639623218866,'Ahmet')

-- Deðeri bilinmeyen kolonlar için veri girerken null yazabilirsiniz. Ancak bu kolon null deðer alabilmeli.

INSERT Person.Person VALUES(55556698752, 'Esra', Null)

--Ayný anda birden fazla kayýt eklemek için

INSERT Person.Person VALUES(45356698752, 'Zeki', Null)
INSERT Person.Person VALUES(45367498752, 'Metin', Null)

--veya tek VALUES kullanýlarak aþaðýdaki gibi de birden fazla kayýt eklenebilir.

INSERT Person.Person 
VALUES(45356571752, 'Aslý', Null),
		(45269571752, 'Kerem', Null)


-- Person_Mail tablosuna birden fazla veri eklemek için aþaðýdaki syntax kullanýlabilir.
-- Ancak burada 3 sütun olmasýna raðmen sadece 2 sütuna veri ekliyoruz.
-- Bunun nedeni Mail_ID sütunu tablo oluþturulurken identity olarak tanýmlanmýþtýr.
-- Bu nedenle bu kolon otomatik artan deðerler içerir.

INSERT INTO Person.Person_Mail (Mail, SSN) 
VALUES ('zehtek@gmail.com', 75056659595),
	   ('meyet@gmail.com', 15078893526),
	   ('metsak@gmail.com', 35532558963)

-- ÖNEMLÝ NOT:

SELECT @@IDENTITY--last process last identity number
SELECT @@ROWCOUNT--last process row count

-- SELECT ... INTO metodu ile daha önce oluþturduðunuz bir tablodaki deðerleri baþka bir tabloya ekleyebiliriz.
-- Burada da sütun sýrasý, tipi, constraintler ve diðer kurallar yine önemli.

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

-- Bir tabloya default deðer girilmesi için aþaðýdaki syntax kullanýlýr.
-- Bunun için tablo constraintlerinin buna uygun olmasý gerekir.
-- Otomatik artan sütunlara deðerler otomatik verilir.
-- Daha önce tanýmlanmýþ default deðerler varsa deðer belirtilmediðinde bu deðerler eklenir.
-- Default deðer belirtilmemiþse null girer.

INSERT Book.Publisher
DEFAULT VALUES

SELECT *
FROM Book.Publisher


-----UPDATE komutu var olan bir tablonun verilerini güncellemek için kullanýlýr.

UPDATE Person.person_2
SET Person_FirstName = 'Default_name'

SELECT *
FROM Person.person_2

-- UPDATE genellikle WHERE ile yani bir koþul ile kullanýlýr.
UPDATE Person.person_2
SET Person_FirstName = 'Ahmet'
WHERE Person_LastName ='Yalnýz'


-- DELETE komutu ile bir tablodan veri silebiliriz.

insert Book.Publisher values ('Ýþ Bankasý Kültür Yayýncýlýk'), ('Can Yayýncýlýk'), ('Ýletiþim Yayýncýlýk')

SELECT *
FROM Book.Publisher

DELETE FROM Book.Publisher

insert Book.Publisher values ('ÝLETÝÞÝM')

DELETE FROM Book.Publisher
WHERE Publisher_Name='ÝLETÝÞÝM'

--DROP komutu ile bir tablo tamamen silinir.

DROP TABLE Person.person_2  --VERÝLERÝ ÝLE BÝRLÝKTE TAMAMEN SÝLÝNDÝ

--TRUNCATE komutu ile bir tabloya format atýlýr. Yani indeksi ile birlikte tüm verileri silinir.

SELECT * FROM Book.Publisher

TRUNCATE TABLE Person.Person_Mail

TRUNCATE TABLE Person.Person

TRUNCATE TABLE Book.Publisher

--ALTER TABLE komutu ile tablo yapýsýnda deðiþiklik yapýlabilir.
-- Mesela daha önce oluþturduðumuz tablolarýmýza costraint ekleyebiliriz.

ALTER TABLE Book.Book ADD CONSTRAINT FK_Author FOREIGN KEY(Author_ID)
	REFERENCES Book.Author (Author_ID)
--Yukarýdaki komut çalýþmadý ve þu hatayý verdi:
-- There are no primary or candidate keys in the referenced table 'Book.Author'
-- that match the referencing column list in the foreign key 'FK_Author'.

-- Bu hatayý çözmek için önce Book.Author tablosuna primary key eklemeliyiz.

ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY (Author_ID)
--Bu komutta aþaðýdaki hatayý vererek 
-- Cannot define PRIMARY KEY constraint on nullable column in table 'Author'.
--Bunu düzeltmek için:

ALTER TABLE Book.Author ALTER COLUMN Author_ID INT NOT NULL
-- Bu komut ile Book.Author tablosunun primer key olacak kolonu(Author_ID) nun kýsýtlarýný deðiþtirdik.
-- Þimdi Author_ID kolonunu PRIMARY KEY olarak tanýmlayabiliriz.

ALTER TABLE Book.Author ADD CONSTRAINT pk_author PRIMARY KEY(Author_ID)
-- Primary key tanýmlamasý yaptýktan sonra da 
-- Book tablosu ile Author arasýndaki baðlantýyý kuracak olan Foreign Key kýsýtlamasýný ekleyebiliriz.

ALTER TABLE Book.Book ADD CONSTRAINT FK_Author FOREIGN KEY (Author_ID)
REFERENCES Book.Author (Author_ID)
--Yukarýdaki komut ile Book tablosundaki Author_ID sütununu Author tablosundaki Author_ID referans alarak Foreign Key yaptýk.

-- Book tablosundaki Publisher_ID sütununu da Foreign Key yapalým:
ALTER TABLE Book.Book ADD CONSTRAINT FK_Publisher FOREIGN KEY (Publisher_ID)
REFERENCES Book.Publisher (Publisher_ID)

-- Person.Loan tablosuna SSN sütununu foreýgn Key olarak ekleyelim:

ALTER TABLE Person.Loan ADD CONSTRAINT FK_PERSON FOREIGN KEY (SSN)
REFERENCES Person.Person (SSN)
ON UPDATE NO ACTION
ON DELETE NO ACTION

-- Person.Loan tablosuna bu sefer de Book_ID sütununu Foreign Key olarak ekleyelim:

ALTER TABLE Person.Loan ADD CONSTRAINT FK_Boook FOREIGN KEY (Book_ID)
REFERENCES Book.Book (Book_ID)
ON UPDATE NO ACTION
ON DELETE NO ACTION

--CHECK CONSTRAINTS

SELECT *
FROM Person.Person

--Person tablosundaki SSN sütununa almasý gerekenden az veya fazla basamaklý bir sayý girilmesini önlemek için

ALTER TABLE Person.Person ADD CONSTRAINT CHECK_SSN CHECK (SSN > 9999999999 AND SSN <= 99999999999)

INSERT Person.Person(SSN) VALUES (123456789) -- Burada Check constrainte takýldýðý için hata verdi

INSERT Person.Person(SSN) VALUES (12345678912) -- Burada belirtilen basamak deðerleri içinde kaldýðý için hata vermedi.

INSERT Person.Person(SSN) VALUES (123456789456789) --Burada da üst sýnýrý aþtýðý için hata verdi.

-- Person_Phone tablosuna Foreign Key ekleyelim.

ALTER TABLE Person.Person_Phone ADD CONSTRAINT FK_Person2 FOREIGN KEY (SSN)
REFERENCES Person.Person (SSN)

--Phone Number için CHECK CONSTRAINT ekelyelim:

ALTER TABLE Person.Person_Phone ADD CONSTRAINT CHECK_Phone CHECK (Phone_Number > 999999999 AND Phone_Number <= 9999999999)

-- Person_Mail tablosuna Foreign Key ekleyelim.

ALTER TABLE Person.Person_Mail ADD CONSTRAINT FK_Person4 FOREIGN KEY(SSN)
REFERENCES Person.Person(SSN)


