---- C-10 WEEKLY AGENDA-8 RD&SQL SOLUTIONS

---- 1. List all the cities in the Texas and the numbers of customers in each city.----

SELECT city, COUNT(customer_id) AS number_of_customer
FROM sale.customer
WHERE state = 'TX'
GROUP BY city;

---- Alternative----

SELECT A.city, COUNT(A.city) AS number_of_customer
FROM sale.customer AS A
WHERE A.state = 'TX'
GROUP BY A.city
ORDER BY A.city



---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.---

SELECT city, COUNT(customer_id) AS 'number of customer'
FROM sale.customer
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(customer_id) > 5
ORDER BY 'number of customer' DESC;



---- 3. List the top 10 most expensive products----

SELECT TOP 10 product_name, list_price
FROM product.product
ORDER BY list_price DESC;



---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----

SELECT B.store_id, A.product_name, A.list_price, B.quantity
FROM product.product AS A, product.stock AS B
WHERE A.product_id = B.product_id
	  AND B.store_id = 2 
      AND B.quantity > 25
ORDER BY A.product_name;



---- 5. Find the sales order of the customers who lives in Boulder order by order date----

SELECT 
	A.order_id, 
	A.order_date,
	B.customer_id,
	B.first_name,
	B.last_name
FROM sale.orders A
INNER JOIN sale.customer B
	ON A.customer_id = B.customer_id
WHERE B.city = 'Boulder'
ORDER BY order_date ASC;



---- 6. Get the sales by staffs and years using the AVG() aggregate function.

SELECT s.first_name, s.last_name, YEAR(o.order_date) AS year, AVG((i.list_price-i.discount)*i.quantity) AS avg_amount
FROM sale.staff s
INNER JOIN sale.orders o
	ON s.staff_id=o.staff_id
INNER JOIN sale.order_item i
	ON o.order_id=i.order_id
GROUP BY s.first_name, s.last_name, YEAR(o.order_date)
ORDER BY first_name, last_name, YEAR(o.order_date)



---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----

SELECT B.brand_name, P.product_name, COUNT(O.quantity) AS Sales_Quantitiy_of_Product
FROM product.brand B
INNER JOIN product.product P
	ON B.brand_id = P.brand_id
INNER JOIN sale.order_item O
	ON P.product_id = O.product_id
GROUP BY B.brand_name, P.product_name
ORDER BY Sales_Quantitiy_of_Product DESC;



---- 8. What are the categories that each brand has?----

SELECT B.brand_name, C.category_name
FROM product.brand B
INNER JOIN product.product P
	ON B.brand_id = P.brand_id
INNER JOIN product.category C
	ON P.category_id = C.category_id
GROUP BY B.brand_name, C.category_name



---- 9. Select the avg prices according to brands and categories----

SELECT B.brand_name, C.category_name, AVG(P.list_price) AS Avg_Price
FROM product.brand B
INNER JOIN product.product P
	ON B.brand_id = P.brand_id
INNER JOIN product.category C
	ON P.category_id = C.category_id
GROUP BY B.brand_name, C.category_name



---- 10. Select the annual amount of product produced according to brands----

SELECT P.model_year, B.brand_name, COUNT(P.product_name) AS annual_amount
FROM product.brand B
INNER JOIN product.product P
	ON B.brand_id = P.brand_id
GROUP BY P.model_year, B.brand_name
ORDER BY P.model_year



---- 11. Select the store which has the most sales quantity in 2016.----

SELECT TOP 1 S.store_name, SUM(Ý.quantity)
FROM sale.store S
INNER JOIN sale.orders O
	ON s.store_id = o.store_id
INNER JOIN sale.order_item Ý
	ON O.order_id = Ý.order_id
WHERE  DATENAME(YEAR, O.order_date) = '2020' -- year(o.[order_date])
GROUP BY S.store_name 
ORDER BY SUM(Ý.quantity) DESC;



---- 12 Select the store which has the most sales amount in 2018.----

SELECT TOP 1 S.store_name, SUM(Ý.list_price) AS sales_amount_2018
FROM sale.store S
INNER JOIN sale.orders O
	ON s.store_id = o.store_id
INNER JOIN sale.order_item Ý
	ON O.order_id = Ý.order_id
WHERE DATENAME(YEAR, O.order_date) = '2018' -- year(o.[order_date])
GROUP BY S.store_name 
ORDER BY SUM(Ý.list_price) DESC;



---- 13. Select the personnel which has the most sales amount in 2019.----

SELECT TOP 1 S.first_name, S.last_name, SUM(Ý.list_price) AS sales_amount_2019
from sale.staff S
INNER JOIN sale.orders O
	ON S.staff_id = O.staff_id
INNER JOIN sale.order_item Ý
	ON O.order_id = i.order_id
WHERE DATENAME(YEAR, O.order_date) = '2019'
GROUP BY S.first_name, S.last_name 
ORDER BY SUM(Ý.list_price) DESC;