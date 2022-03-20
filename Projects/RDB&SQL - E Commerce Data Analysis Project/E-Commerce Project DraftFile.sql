

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



--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.



--//////////////////////////////////



  --2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.





--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.



--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.







--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as “churn” if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as “regular” if the customer has made a purchase every month.
--Etc.
	







--/////////////////////////////////////




--MONTH-WISE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps





--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.







---///////////////////////////////////
--Good luck!