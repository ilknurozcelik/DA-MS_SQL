
select *
from Actions.Actions

select *
from sale.orders

SELECT * 
FROM sale.customer
WHERE CONCAT(first_name, last_name) LIKE '%D%'

select first_name, last_name
from sale.customer
except
select first_name, last_name
from sale.customer
where city = 'Boston'  -- customer_id �zerinden except yapmak daha do�ru sonu� verir.
