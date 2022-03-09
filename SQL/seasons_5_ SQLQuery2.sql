-----SET OPERATORS

---UNION-UNIONALL


--List Customer's last names in Charlotte and Aurora


SELECT last_name
from sale.customer
where city = 'Charlotte'
union all
select last_name
from sale.customer
where city = 'Aurora'


SELECT last_name
from sale.customer
where city = 'Charlotte'
union
select last_name
from sale.customer
where city = 'Aurora'

SELECT last_name
from sale.customer
where city in( 'Charlotte','Aurora') -- union all gibi bütün veriler gelir.


--Write a query that returns customers who name is ‘Thomas’ or surname is ‘Thomas’. (Don't use 'OR')


select first_name, last_name
from sale.customer
where first_name='Thomas' 
union all
select first_name, last_name
from sale.customer
where last_name='Thomas'


select *
from  product.brand
union
select * 
from product.category

------ COLUMN SAYIS FARKLI OLMA DURUMU(COLUMN SAYILARI AYNI OLMALI)


---- INTERSECT
-- Write a query that returns brands that have products for both 2018 and 2019.


select * 
from product.brand
where brand_id in
(SELECT brand_id
FROM product.product
where model_year = 2018
intersect
SELECT brand_id
FROM product.product
where model_year = 2019)


------- Write a query that returns customers who have orders for both 2018, 2019, and 2020
SELECT first_name, last_name
FROM sale.customer
WHERE customer_id IN
(
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2018-01-01' AND '2018-12-31'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31'
INTERSECT
SELECT customer_id
FROM sale.orders
WHERE order_date BETWEEN '2020-01-01' AND '2020-12-31'
)



-------EXCPT

-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.

select * 
from product.brand
where brand_id in 
(
select brand_id
from product.product
where model_year = 2018
except
select brand_id
from product.product
where model_year = 2019)

-- Write a query that returns only products ordered in 2019 (not ordered in other years).





----------CASE EXPRESSION

-----SIMPLE CASE EXPRESSION

-- Generate a new column containing what the mean of the values in the Order_Status column.
--Order_Status isimli alandaki deðerlerin ne anlama geldiðini içeren yeni bir alan oluþturun.


-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_id, order_status
FROM sale.orders


SELECT order_id, order_status,
		CASE order_status
					WHEN 1 THEN 'Pending'
					WHEN 2 THEN 'Processing'
					WHEN 3 THEN 'Rejected'
					WHEN 4 THEN 'Completed'
		END ORDER_STATUS_DESC
FROM sale.orders

-- Add a column to the sales.staffs table containing the store names of the employees.

SELECT  first_name,last_name, store_id,
		CASE store_id
					WHEN 1 THEN 'Davi techno Retail'
					WHEN 2 THEN 'The BFLO Store'
					WHEN 3 THEN 'Burkes Outlet'
					
		END Store_name
FROM sale.staff

SELECT  first_name,last_name, store_id,
		CASE store_id
					WHEN 1 THEN 'Davi techno Retail'
					WHEN 2 THEN 'The BFLO Store'
					ELSE 'Burkes Outlet'
					
		END Store_name
FROM sale.staff

-- Generate a new column containing what the mean of the values in the Order_Status column. (use searched case ex.)
-- 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

SELECT order_id, order_status,
		CASE 
					WHEN order_status = 1 THEN 'Pending'
					WHEN order_status = 2 THEN 'Processing'
					WHEN order_status = 3 THEN 'Rejected'
					WHEN order_status = 4 THEN 'Completed'
		END ORDER_STATUS_NEWS
FROM sale.orders




SELECT first_name, first_name, email,
		CASE 
					WHEN email like '%gmail%' THEN 'Gmail'
					WHEN email like '%hotmail%' THEN 'Hotmail'
					WHEN email like '%yaho%' THEN 'Yaho'
					WHEN email is not null THEN 'Yaho'
					ELSE 'other'
		END email_service_provider
FROM sale.customer