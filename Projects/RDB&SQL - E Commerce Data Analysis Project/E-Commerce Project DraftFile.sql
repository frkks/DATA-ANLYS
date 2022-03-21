

--DAwSQL Session -8 

--E-Commerce Project Solution
select * 
from [dbo].[cust_dimen]

select * 
from [dbo].[market_fact]

select * 
from [dbo].[orders_dimen]

select * 
from [dbo].[prod_dimen]

select * 
from [dbo].[shipping_dimen]


--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

select * into combined_table from
(select a.Sales,a.Discount,a.Order_Quantity,a.Product_Base_Margin, b.*,c.*,d.*,e.*
from [dbo].[market_fact] a
full outer join [dbo].[orders_dimen] b on b.Ord_id = a.Ord_id
full outer join [dbo].[prod_dimen] c on a.Prod_id = c.Prod_id
full outer join [dbo].[cust_dimen] d on d.Cust_id = a.Cust_id
full outer join [dbo].[shipping_dimen] e on e.Ship_id = a.Ship_id
) S ;

select *
from combined_table



--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.
select Top 3 Cust_id, count(Ord_id) Total_order
from combined_table
group by Cust_id
order by Total_order desc;



--/////////////////////////////////



--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.
alter table combined_table
add DaysTakenForDelivery INT;

update combined_table
SET DaysTakenForDelivery = DATEDIFF(day, Order_Date, Ship_Date)



--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"

select top 1 Cust_id, Customer_Name, max(DaysTakenForDelivery) max_day
from combined_table
group by Cust_id, Customer_Name
order by max_day desc


--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use date functions and subqueries
select MONTH(Order_Date) Month_ord, COUNT(DISTINCT Cust_id) Mount_Num_cust 
from combined_table
where Cust_id in
			(select Cust_id
			from combined_table
			where year(Order_Date) = 2011
			and MONTH(Order_Date) = 1
			) 
			and year(Order_Date) = 2011
group by MONTH(Order_Date)
order by Month_ord
			




--////////////////////////////////////////////


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions
 WITH T1 AS
 (SELECT Cust_id, Order_Date,
			MIN (Order_Date) OVER (PARTITION BY Cust_id) FIRST_ORDER_DATE,
			DENSE_RANK () OVER (PARTITION BY Cust_id ORDER BY Order_Date) dense_number
FROM combined_table)

SELECT DISTINCT Cust_id,
		Order_Date,
		dense_number,
		FIRST_ORDER_DATE,
		DATEDIFF(day, FIRST_ORDER_DATE, Order_Date) DAYS_ELAPSED
FROM T1
WHERE	dense_number = 3
ORDER BY Cust_id



--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions




--/////////////////

WITH T1 AS (
SELECT Cust_id, 
		SUM(CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) P11,
		SUM(CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) P14,
		SUM(Order_Quantity) TOTAL_PROD
FROM combined_table
GROUP BY Cust_id 
HAVING 
	    SUM(CASE WHEN Prod_id = 'Prod_11' THEN Order_Quantity ELSE 0 END) >=1 AND
		SUM(CASE WHEN Prod_id = 'Prod_14' THEN Order_Quantity ELSE 0 END) >=1
)
SELECT Cust_id, P11, P14, TOTAL_PROD,
	   ROUND(CAST( P11 as float)/CAST (TOTAL_PROD as float), 2) RATIO_P11,
	   ROUND(CAST( P14 as float)/CAST (TOTAL_PROD as float), 2) RATIO_P14
FROM T1
ORDER BY Cust_id

--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW visit_logs as
select Cust_id, 
	datepart(year, Order_Date) as [YEAR],
	datepart(month, Order_Date) as [MONTH]
from combined_table

--//////////////////////////////////
select *
from visit_logs
order by 1

  --2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

CREATE VIEW visit_num as

select Cust_id, [YEAR], [MONTH], count(*) as Visit
from visit_logs
group by Cust_id, [YEAR], [MONTH]
---------
select *
from visit_num
order by Cust_id, [YEAR], [MONTH]

--//////////////////////////////////



--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

CREATE VIEW nex_visit AS

SELECT *,
		DENSE_RANK () OVER(ORDER BY  [YEAR], [MONTH]) AS THIS_MONTH 
FROM visit_num
------------------------------------
CREATE VIEW nex_visit1 AS
SELECT *,
		LEAD(THIS_MONTH,1) OVER (PARTITION BY Cust_id ORDER BY THIS_MONTH) NEXT_MONTH
FROM nex_visit


select *
from nex_visit1


--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.


CREATE VIEW TIME_DECEMBER AS

select *, NEXT_MONTH - THIS_MONTH AS TIME_DECEMBER
from nex_visit1

-----------------------------

select *
from TIME_DECEMBER


--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as “churn” if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as “regular” if the customer has made a purchase every month.
--Etc.

WITH T2 AS (	
select Cust_id, AVG(TIME_DECEMBER) AVG_TIME_DECEMBER
from TIME_DECEMBER
group by Cust_id)

select *,
		CASE WHEN AVG_TIME_DECEMBER IS NULL THEN 'Churn'
			WHEN AVG_TIME_DECEMBER = 1 THEN 'Regular'
			WHEN AVG_TIME_DECEMBER > 1 THEN 'Irregular' END CUST_LABELS	

from T2
ORDER BY Cust_id





--/////////////////////////////////////




--MONTH-WISE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

select 	[YEAR],
	[MONTH],
	count(DISTINCT Cust_id) as Cust_Number
from visit_logs
group  by [YEAR],[MONTH]
order by [YEAR],[MONTH]




--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.

CREATE VIEW THIS_NUM_OF_CUST AS

SELECT	DISTINCT Cust_id, [YEAR],
		[MONTH],
		THIS_MONTH,
		COUNT (Cust_id)	OVER (PARTITION BY THIS_MONTH) THIS_CUST
FROM	TIME_DECEMBER



CREATE VIEW NEXT_NUM_OF_CUST AS

SELECT	DISTINCT Cust_id, [YEAR],
		[MONTH],
		THIS_MONTH,
		NEXT_MONTH,
		COUNT (Cust_id)	OVER (PARTITION BY THIS_MONTH) NEXT_CUST
FROM	TIME_DECEMBER
WHERE TIME_DECEMBER = 1 AND THIS_MONTH>1


-----1--------

SELECT DISTINCT B.[YEAR],B.[MONTH], ROUND(CAST ( B.NEXT_CUST AS FLOAT)/A.THIS_CUST,2) AS RETENTION_RATE
FROM THIS_NUM_OF_CUST A INNER JOIN NEXT_NUM_OF_CUST B
ON A.THIS_MONTH+1 =B.NEXT_MONTH

--------2-----------

select*, lag(RETENTION_RATE,1) OVER(ORDER BY [YEAR],[MONTH]) AS THEN_RETENTION_RATE
FROM 
	(SELECT DISTINCT B.[YEAR],
				B.[MONTH],
				B.THIS_MONTH,
				ROUND(CAST(B.NEXT_CUST AS FLOAT)/A.THIS_CUST,2) AS RETENTION_RATE
	FROM THIS_NUM_OF_CUST A INNER JOIN NEXT_NUM_OF_CUST B
	ON A.THIS_MONTH+1 = B.NEXT_MONTH) C





---///////////////////////////////////
--Good luck!