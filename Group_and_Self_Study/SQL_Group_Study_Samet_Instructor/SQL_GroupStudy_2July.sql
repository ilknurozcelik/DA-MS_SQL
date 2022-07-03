select *
from [dbo].[nyc_sample_data_for_sql_sep_2015]

select Total_amount
from [dbo].[nyc_sample_data_for_sql_sep_2015]

/*Question 1 : En yüksek ödeme yapmýþ kiþi bilgilerini getiren bir sorgu yazýnýz. */

select max(Total_amount)
from [dbo].[nyc_sample_data_for_sql_sep_2015]

select top 1 *
from [dbo].[nyc_sample_data_for_sql_sep_2015]
order by Total_amount desc

select *
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where Total_amount = (select max(Total_amount)
						from [dbo].[nyc_sample_data_for_sql_sep_2015])

/*Question 2 : Most expensive trip per mile */


select max(Total_amount/Trip_distance)
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where Trip_distance!= 0

select max(Total_amount/nullif(Trip_distance,0))
from [dbo].[nyc_sample_data_for_sql_sep_2015]


select top 1 *, Total_amount/Trip_distance as A
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where Trip_distance!= 0
order by Total_amount/Trip_distance desc

select *
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where Total_amount = (select max(Total_amount)
						from [dbo].[nyc_sample_data_for_sql_sep_2015])

select *
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where Trip_distance!= 0 and Total_amount/Trip_distance = (select max(Total_amount/Trip_distance)
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where Trip_distance!= 0)

/* Q3: Most generous trip : highest tip */

select max(Tip_amount)
from [dbo].[nyc_sample_data_for_sql_sep_2015]

select top 1 *
from [dbo].[nyc_sample_data_for_sql_sep_2015]
order by Tip_amount desc

select *
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where Tip_amount = (select max(Tip_amount)
from [dbo].[nyc_sample_data_for_sql_sep_2015])


/* Q4 : Longest trip duration */

select MAX(DATEDIFF(MS, lpep_pickup_datetime, Lpep_dropoff_datetime))
from [dbo].[nyc_sample_data_for_sql_sep_2015]

select MAX(DATEDIFF(MI, lpep_pickup_datetime, Lpep_dropoff_datetime))
from [dbo].[nyc_sample_data_for_sql_sep_2015]

select *
from [dbo].[nyc_sample_data_for_sql_sep_2015]
where DATEDIFF(MS, lpep_pickup_datetime, Lpep_dropoff_datetime) = (
																select MAX(DATEDIFF(MS, lpep_pickup_datetime, Lpep_dropoff_datetime))
																from [dbo].[nyc_sample_data_for_sql_sep_2015])


/* Q5 : Mean tip by hour */

select DATEPART(HOUR, lpep_pickup_datetime), AVG(Tip_amount)
from nyc_sample_data_for_sql_sep_2015
group by DATEPART(HOUR, lpep_pickup_datetime)


select DISTINCT DATEPART(hh, lpep_pickup_datetime),
	ROUND(AVG(Tip_amount) OVER(PARTITION BY DATEPART(hh, lpep_pickup_datetime)) ,2, 2)
from nyc_sample_data_for_sql_sep_2015

/* Q6 : Average total trip by day of week */


with T1 AS(
	select distinct CAST(lpep_pickup_datetime AS DATE) DATE_, DATENAME(DW, lpep_pickup_datetime) DAY_OF_WEEK,
		count(trip_id) over (partition by DATEPART(DD, lpep_pickup_datetime)) tot_trip
	from nyc_sample_data_for_sql_sep_2015
)

select distinct DATENAME(DW, DATE_) DAY_OF_WEEK,
	avg(tot_trip) over(partition by DATENAME(DW, DATE_)) avg_trip
from T1


/* Q7 : Count of trips by hour*/

select DATEPART(HOUR, lpep_pickup_datetime), COUNT(*)
from nyc_sample_data_for_sql_sep_2015
group by DATEPART(HOUR, lpep_pickup_datetime)
order by 1

select distinct DATEPART(HOUR, lpep_pickup_datetime),
	COUNT(trip_id) over (partition by DATEPART(HOUR, lpep_pickup_datetime)) count_trip
from nyc_sample_data_for_sql_sep_2015

/* Q8 : Average passenger count per trip */

select round(avg(Passenger_count), 2, 2)
from nyc_sample_data_for_sql_sep_2015

/* Average passenger count per trip by hour */

select distinct datepart(hh, lpep_pickup_datetime),
	avg(Passenger_count) over (partition by datepart(hh, lpep_pickup_datetime))
from nyc_sample_data_for_sql_sep_2015
order by 1

/*Q11 Which airport welcomes more passengers : JFK or EWR? */

select distinct case 
					when RateCodeID = 2 then 'JFK'
					when RateCodeID = 3 then 'Newark'
				end as RateCodeName,
	sum(Passenger_count) over (partition by RateCodeID) total_passenger
from nyc_sample_data_for_sql_sep_2015
where RateCodeID = 2 or RateCodeID= 3

/* Q12 :How many nulls are there in the Total_amount? */

select sum(case when Total_amount is null then 1 else 0 end) total_null
from nyc_sample_data_for_sql_sep_2015


select count(Total_amount)
from nyc_sample_data_for_sql_sep_2015
where Total_amount is null

/*Q13 : How many values are there in Trip_distance?(count of non-missing values) */

select sum(case when Trip_distance is not null then 1 else 0 end) total_not_null
from nyc_sample_data_for_sql_sep_2015

select count(Trip_distance)
from nyc_sample_data_for_sql_sep_2015
where Trip_distance is not null

/* Q14 : How many nulls are there in Ehail Fee?*/

select sum(case when Ehail_fee is null then 1 else 0 end) total__null
from nyc_sample_data_for_sql_sep_2015

select count(Ehail_fee)  -- COUNT does not include NULL values in column counts
from nyc_sample_data_for_sql_sep_2015
where Ehail_fee is null

select count(*)
from nyc_sample_data_for_sql_sep_2015
where Ehail_fee is null

/*Q15 : Find the tirps of which trip distance is greater than 15 miles (included)
or less than 0.1 mile (included)*/

select *
from nyc_sample_data_for_sql_sep_2015
where Trip_distance <= 0.1 or Trip_distance >= 15

select *
from nyc_sample_data_for_sql_sep_2015
where Trip_distance <= 0.1
UNION ALL
select *
from nyc_sample_data_for_sql_sep_2015
where Trip_distance >= 15