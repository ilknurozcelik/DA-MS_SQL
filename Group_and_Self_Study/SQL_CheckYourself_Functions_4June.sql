SELECT *
FROM product.product
WHERE product_name LIKE 'SAMSUNG %'
ORDER BY product_name ASC


SELECT *
FROM product.product
WHERE product_name LIKE 'SAMSUNG%'
ORDER BY product_name ASC


--SOLUTION USING WITH SUBSTRING

SELECT *, SUBSTRING(product_name, 1, 7)
FROM product.product
WHERE SUBSTRING(product_name, 1, 7)='Samsung'
ORDER BY product_name ASC

--SOLUTION USING WITH SUBSTRING AND CHARINDEX

SELECT product_name, CHARINDEX('g', product_name, 1)
FROM product.product

SELECT *
FROM product.product
WHERE SUBSTRING(product_name, 1, CHARINDEX('g', product_name, 1))='SAMSUNG'
ORDER BY product_name ASC

SELECT *
FROM product.product
WHERE SUBSTRING(LTRIM(product_name), 1, CHARINDEX(' ', LTRIM(product_name), 1))='SAMSUNG' OR
SUBSTRING(LTRIM(product_name), 1, CHARINDEX('-', LTRIM(product_name), 1))='SAMSUNG'
ORDER BY product_name ASC

SELECT *
FROM product.product
WHERE SUBSTRING(LTRIM(product_name), 1, CHARINDEX('g', LTRIM(product_name), 1))='SAMSUNG' 
ORDER BY product_name ASC

SELECT street
FROM sale.customer
WHERE SUBSTRING(street, CHARINDEX('#', street, 1)+1,LEN(street)) < 5
ORDER BY street ASC


SELECT SUBSTRING(street, CHARINDEX('#', street,1)+1, CHARINDEX('#', street,1)+1)
FROM sale.customer

SELECT RIGHT(street, LEN(street) - PATINDEX('#', street))
FROM sale.customer

SELECT STRING_SPLIT(street,'#')
FROM sale.customer

SELECT CONVERT(INT, SUBSTRING(street, CHARINDEX('#', street,1)+1, CHARINDEX('#', street,1)+1))
FROM sale.customer

SELECT street
FROM sale.customer
WHERE CONVERT(INT, SUBSTRING(street, CHARINDEX('#', street,1)+1, CHARINDEX('#', street,1)+1)) < 5
ORDER BY street ASC

/* Check yourself 2nd question solution: */

SELECT CHARINDEX('#', street) AS POS_#
FROM sale.customer
WHERE CHARINDEX('#', street) > 0

SELECT street
FROM sale.customer
WHERE CHARINDEX('#', street) > 0

SELECT RIGHT(street, LEN(street)-CHARINDEX('#', street))
FROM sale.customer
WHERE CHARINDEX('#', street) > 0

SELECT CONVERT(INT, RIGHT(street, LEN(street)-CHARINDEX('#', street)))
FROM sale.customer
WHERE CHARINDEX('#', street) > 0

SELECT street
FROM sale.customer
WHERE (CHARINDEX('#', street) > 0 AND CONVERT(INT, RIGHT(street, LEN(street)-CHARINDEX('#', street))) < 5)
ORDER BY street

SELECT street
FROM sale.customer
WHERE (CHARINDEX('#', street) > 0 AND RIGHT(street, LEN(street)-CHARINDEX('#', street)) < 5)
ORDER BY street

SELECT street
FROM sale.customer
WHERE street LIKE('%#%') AND RIGHT(street, LEN(street)-CHARINDEX('#', street)) < 5
ORDER BY street