/* Group Study_3July*/

/*Q16. We would like to  */
select Payment_Range_in_Dollars, count(Total_amount)
from (select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
					Total_amount
from nyc_sample_data_for_sql_sep_2015) fsa
group by Payment_Range_in_Dollars
order by 1

select Total_amount
from nyc_sample_data_for_sql_sep_2015

with T1 as (
select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
					Total_amount
from nyc_sample_data_for_sql_sep_2015
)
select Payment_Range_in_Dollars, count(Total_amount)
from T1
group by Payment_Range_in_Dollars
order by 1

/*Q17 */

select driver_id, Payment_Range_in_Dollars, count(*)
from (select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
					Total_amount, driver_id
from nyc_sample_data_for_sql_sep_2015) fsa
group by driver_id, Payment_Range_in_Dollars
order by 1, 2


with T1 as (
select CASE WHEN Total_amount < 5 THEN '0 - 5'
                    WHEN Total_amount >= 5 AND Total_amount < 10 THEN '5 - 10'
                    WHEN Total_amount >= 10 AND Total_amount < 15 THEN '10 - 15'
                    WHEN Total_amount >= 15 AND Total_amount < 20 THEN '15 - 20'
                    WHEN Total_amount >= 20 AND Total_amount < 25 THEN '20 - 25'
                    WHEN Total_amount >= 25 AND Total_amount < 30 THEN '25 - 30'
                    WHEN Total_amount >= 30 AND Total_amount < 35 THEN '30 - 35'
                    WHEN Total_amount >= 35 THEN '35+' END as Payment_Range_in_Dollars,
					Total_amount, driver_id
from nyc_sample_data_for_sql_sep_2015
)
select driver_id, Payment_Range_in_Dollars, count(Total_amount)
from T1
group by driver_id, Payment_Range_in_Dollars
order by 1


/*Q18 */
select *
from(
	select driver_id, Total_amount,
		RANK() over (partition by driver_id order by Total_amount desc)rnk
	from nyc_sample_data_for_sql_sep_2015) aaf
where rnk<=3


with T1 as(
	select driver_id, Total_amount,
		RANK() over (partition by driver_id order by Total_amount desc)rnk
	from nyc_sample_data_for_sql_sep_2015
)
select *, sum(Total_amount) over (partition by driver_id)
from T1
where rnk<=3

/* Q19 */

with T1 as(
	select driver_id, Total_amount,
		RANK() over (partition by driver_id order by Total_amount)rnk
	from nyc_sample_data_for_sql_sep_2015
)
select *, sum(Total_amount) over (partition by driver_id)
from T1
where rnk<=3


/*Q20 */

select DISTINCT top 10 Total_amount
from nyc_sample_data_for_sql_sep_2015
where driver_id=1
order by Total_amount asc

--------

with T1 as(
	select driver_id, Total_amount,
		RANK() over (partition by driver_id order by Total_amount)rnk
	from nyc_sample_data_for_sql_sep_2015
)
select *
from T1
where driver_id = 1 and rnk <=10

--------
with T1 as(
	select driver_id, Total_amount,
		DENSE_RANK() over (partition by driver_id order by Total_amount)rnk
	from nyc_sample_data_for_sql_sep_2015
)
select *
from T1
where driver_id = 1 and rnk <=10

/*Q21 */

select lpep_pickup_datetime, Total_amount,
	sum(Total_amount) over(partition by driver_id order by lpep_pickup_datetime) cumulative_sum
from nyc_sample_data_for_sql_sep_2015
where driver_id = 1

/* Q22 */

select lpep_pickup_datetime, Total_amount, Passenger_count
from nyc_sample_data_for_sql_sep_2015
where driver_id = 1 and
	Total_amount = (
					select max(Total_amount)
					from nyc_sample_data_for_sql_sep_2015
					where driver_id = 1 ) or
	Total_amount = (
					select min(Total_amount)
					from nyc_sample_data_for_sql_sep_2015
					where driver_id = 1)

-----
select lpep_pickup_datetime, Total_amount, Passenger_count
from (select top 1 *
	from nyc_sample_data_for_sql_sep_2015
	where driver_id = 1
	order by Total_amount) akk
UNION ALL
select lpep_pickup_datetime, Total_amount, Passenger_count
from (select top 1 *
	from nyc_sample_data_for_sql_sep_2015
	where driver_id = 1
	order by Total_amount desc) dfd

-----

select *
from (
	select Total_amount,
		RANK() OVER (PARTITION BY driver_id order by Total_amount) rnk,
		RANK() OVER (PARTITION BY driver_id order by Total_amount desc) inverse_rnk
	from nyc_sample_data_for_sql_sep_2015
	where driver_id = 1
)dfds
where rnk = 1 or inverse_rnk=1


/* Q23 */


/* Q24 Ekim ayýndaki yeni sürücüleri bulalým */

select distinct driver_id
from nyc_sample_data_for_sql_oct_2015
where driver_id not in (select distinct driver_id
						from nyc_sample_data_for_sql_sep_2015)

----
select distinct driver_id
from nyc_sample_data_for_sql_oct_2015
EXCEPT
select distinct driver_id
from nyc_sample_data_for_sql_sep_2015

-----
select distinct driver_id
from nyc_sample_data_for_sql_oct_2015 as oct
where not exists (select distinct driver_id
				from nyc_sample_data_for_sql_sep_2015
				where driver_id=oct.driver_id)

/* Q25 */


-- WINDOW FUNCTION ÝLE ÇÖZÜM
with T1 as(
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_sep_2015
	UNION ALL
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_oct_2015
)
select distinct 
	sum(case when MONTH(lpep_pickup_datetime) = 9 then Total_amount end) over (partition by MONTH(lpep_pickup_datetime)) sep,
	sum(case when MONTH(lpep_pickup_datetime) = 10 then Total_amount end) over (partition by MONTH(lpep_pickup_datetime)) oct
from T1
group by MONTH(lpep_pickup_datetime)

--GROUP BY ÝLE ÇÖZÜM
with T1 as(
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_sep_2015
	UNION ALL
	select lpep_pickup_datetime, Total_amount
	from nyc_sample_data_for_sql_oct_2015
)
select  
	sum(case when MONTH(lpep_pickup_datetime) = 9 then Total_amount end) sep,
	sum(case when MONTH(lpep_pickup_datetime) = 10 then Total_amount end) oct
from T1
group by MONTH(lpep_pickup_datetime)

--PIVOT ÝLE ÇÖZÜM
select *
from (
	select MONTH(lpep_pickup_datetime) AS DATE_, Total_amount
	from nyc_sample_data_for_sql_sep_2015
	UNION ALL
	select MONTH(lpep_pickup_datetime), Total_amount
	from nyc_sample_data_for_sql_oct_2015
) T1
PIVOT (
	SUM(Total_amount)
	FOR DATE_ IN ([9],[10])) AS PIVOT_TABLE;

--PIVOT ÝLE AY ÝSÝMLERÝNÝ YAZDIRARAK ÇÖZÜM

select *
from (
	select DATENAME(M, lpep_pickup_datetime) AS MONTH_, Total_amount
	from nyc_sample_data_for_sql_sep_2015
	UNION ALL
	select DATENAME(M, lpep_pickup_datetime), Total_amount
	from nyc_sample_data_for_sql_oct_2015
) T1
PIVOT (
	SUM(Total_amount)
	FOR MONTH_ IN ([September],[October])) AS PIVOT_TABLE;




