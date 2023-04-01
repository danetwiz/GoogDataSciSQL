-- *** create a table with a primary key that automatically iterates ***
Create table 
	names
		(
		[id] int identity(1,1) NOT NULL primary key,
		[name] varchar(50) NULL,
		gender varchar(50) Null,
		total numeric(12,0)
		)

-- *** insert values into a table with a primary key that automatically iterates (or not) ***
insert into 
	customers
	(first_name,last_name,age)
Values 
	('Damien','Augustin',40),
	('Michael','Jordan',58),
	('John',null,33)

-- *** limit number of results or records returned in a query top most ***
select top 10 * from names
where gender = 'M'
order by 4 desc

-- *** select the 3rd most popular rank ranking record row ***
SELECT 
	a.* 
FROM  --subquery 'a' dense ranks totals for 'M" gender
	(
	SELECT 
		*, Dense_Rank() OVER (partition by gender order by total desc) as TRANK
	FROM 
		names 
	WHERE 
		gender = 'M'
		--TRANK = 3 --not allowed here
	) a
WHERE --additional condition placed outside sq 'a'
	TRANK = 3

-- *** Count the number of records rows in a table **
Select
	Count(*) As number_of_rows
From
	names

--**JOINS**--
-- *** Join query with subquery aggregate function applied to a group by rollup, which is similar to partition DaNetWiz DB***
SELECT 
	c.*, o.order_num, o.item_id, m.item_name, o.item_quantity, m.price, (m.price * o.item_quantity) as subtotal
	,b.order_total --from subquery b
from 
	customers c 
right join 
	orders o
	on c.id=o.id
left join 
	menu m
	on o.item_id = m.item_id
--So far we've assembled the cusomters info to their ordered items and the pricing
--Next we want to join in the subtotal and order totals
left join --subquery b (calcs order_totals by summing subtotals for each order_num as pkey)
	(
	select 
		a.order_num,sum(a.subtotal) as order_total 
	from --subquery a (calcs subtotal for each item_quantity * price)
		( 
		SELECT 
			c.*, o.order_num, o.item_id, m.item_name, o.item_quantity, m.price, (m.price * o.item_quantity) as subtotal
		from 
			customers c 
		right join 
			orders o
			on c.id=o.id
		left join 
			menu m
			on o.item_id = m.item_id
			) a 
	group by rollup(a.order_num)
	) b
on o.order_num=b.order_num


--substring(start char number,num of char) and len()
Create table customer_address
	(
	customer_id int identity(1,1) NOT NULL primary key,
	country	 varchar(50) NULL
	)
insert into 
	customer_address
	(country)
Values 
	('US'),
	('USA'),
	('US')
	
Select
	customer_id, SUBSTRing(country,1,2) as bichar-d_country, country
from  
	customer_address
where
	len(country) >2

--Case Statements
drop table cust_name
Create table 
	cust_name
		(
		[id] int identity(1,1) NOT NULL primary key,
		cust_num numeric(7,0) NULL,
		first_name varchar(50) Null,
		last_name varchar(50)
		)
insert into 
	cust_name
	(cust_num, first_name,last_name)
Values 
	(5500,'Tnoy','Magnolia'),  --this is intentionally mispelled
	(5501,'Michael','Jordan'),
	(5502,'Tony','Magnolia'),
	(5503,'Jamaal','Proctor')
select * from cust_name

Select
	cust_num,
	Case
		When first_name='Tnoy' Then 'Tony'
		Else first_name
		end as cleaned_name
From
	cust_name

--Calculations (us AS)
--Extraction: in mysql use Extract(year from race_date) as year
--in ms sql looks like a subquery is needed.
Create table 
	citi_bike 
		(
		[id] int identity(1,1) NOT NULL primary key,
		competitor_num numeric(7,0) NULL,
		first_name varchar(50) Null,
		last_name varchar(50),
		race_date date
		)
--drop table citi_bike
--truncate table citi_bike
insert into 
	citi_bike
	(competitor_num, first_name,last_name, race_date)
Values 
	(229,'Troy','McLure','2021-01-22'),  
	(186,'Homer','Simpson','2021-03-03'),
	(112,'Brad','Pitts','2021-02-15'),
	(556,'Lance','Armstrong','2020-04-20')
--select * from citi_bike

Select a.* from 
	(
	Select 
		*,
		YEAR(race_date) As race_year
	from 
		citi_bike
	) a
where a.race_year = '2021'
order by a.race_date desc
  --Remember: when using sub queries, tag a temp table name, then use it as the prefix code in the global select, and where/order etc...
  ---OR----

--Temporary tables with WITH
--WITH is new, and introduced by Oracle9 in 1999
With citi_bike_year
	AS
	(
	Select
		*, YEAR(race_date) as race_year
	from citi_bike
	)
Select 
	*
From
	citi_bike_year
where race_year > 2020
order by race_date desc
;

--Global variables DECLARE
DECLARE @day_now date = current_timestamp
DECLARE @time_now time(0) = current_timestamp
select @day_now as 'Date', @time_now as 'Time'

--Select Into
Select 
	*
Into
	citi_bike_temp
from 
	citi_bike
Where
	race_date > '2021'
;

select * from citi_bike_temp
--drop table citi_bike_temp