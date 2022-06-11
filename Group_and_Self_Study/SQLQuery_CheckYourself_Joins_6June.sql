SELECT *
FROM product.product

SELECT *
FROM sale.orders

SELECT *
FROM sale.order_item

-- Adý 'Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black' olan
-- ürünlerin order datelerini getiren bir sorgu yazalým.

SELECT SO.order_date
FROM sale.orders AS SO
INNER JOIN sale.order_item AS SOI
ON SO.order_id = SOI.order_id
INNER JOIN product.product AS PP
ON SOI.product_id = PP.product_id
WHERE PP.product_name ='Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black'


/* Write a query that returns orders of the products branded "Seagate".
It should be listed Product names and order IDs of all the products ordered or not ordered.
(order_id in ascending order) */

SELECT *
FROM product.product

SELECT *
FROM product.brand

SELECT *
FROM sale.orders

SELECT *
FROM sale.order_item

SELECT PP.product_name, SOI.order_id
FROM sale.orders AS SO
FULL OUTER JOIN sale.order_item AS SOI
ON SO.order_id = SOI.order_id
FULL OUTER JOIN product.product AS PP
ON SOI.product_id = PP.product_id
FULL OUTER JOIN product.brand AS PB
ON PP.brand_id = PB.brand_id
WHERE brand_name = 'Seagate'
ORDER BY SOI.order_id ASC