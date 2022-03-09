----- march 5, 2022 JOIN


-- List products with category names
-- Select product ID, product name, category ID and category names


SELECT a.product_id, a.product_name, b.category_id,b.category_id
from product.product a
inner join product.category b  on a.brand_id = b.category_id;


--List employees of stores with their store information
--Select employee name, surname, store names
SELECT a.first_name, a.last_name, b.store_name
from sale.staff a
inner join sale.store b  on a.store_id = b.store_id;


--Write a query that returns count of orders of the states by months.

select A.[state], year(B.order_date) years1, month(B.order_date) month1, COUNT(distinct order_id) num_count
from sale.customer A, sale.orders B
where A.customer_id = B.customer_id
group by A.[state], year(B.order_date), month(B.order_date);

select A.[state], year(B.order_date) years1, month(B.order_date) month1, COUNT(distinct order_id) num_count
from sale.customer A 
INNER JOIN sale.orders B
ON A.customer_id = B.customer_id
group by A.[state], year(B.order_date), month(B.order_date);

------ LEFT JOIN

-- Write a query that returns products that have never been ordered
--Select product ID, product name, orderID
--(Use Left Join)
SELECT A.product_id, A.product_name, B.order_id
FROM product.product A
LEFT JOIN sale.order_item B ON A.product_id = B.product_id
WHERE order_id IS NULL

--Report the stock status of the products that product id greater than 310 in the stores.
--Expected columns: Product_id, Product_name, Store_id, quantity

SELECT A.product_id, A.product_name, B.store_id, B.quantity
from product.product A
LEFT join product.stock B  on A.product_id = B.product_id
where A.product_id >310; 

-------- RIGHT JOIN
--Report (AGAIN WITH RIGHT JOIN) the stock status of the products that product id greater than 310 in the stores.

SELECT B.product_id, B.product_name, A.*
from product.stock A
RIGHT join product.product B  on A.product_id = B.product_id
where B.product_id >310;

-------Report the orders information made by all staffs.
--Expected columns: Staff_id, first_name, last_name, all the information about orders

SELECT B.staff_id, B.first_name, B.last_name,A.*
from sale.orders A
RIGHT join sale.staff B  on A.staff_id = B.staff_id;



-------- FULL OUTER JOIN

--Write a query that returns stock and order information together for all products . (TOP 100)
--Expected columns: Product_id, store_id, quantity, order_id, list_price


SELECT TOP 100 A.product_id, B.quantity, C.order_id, C.list_price -- TOP 100 / ilk yüz satýr
FROM [product].[product] A
FULL OUTER JOIN [product].[stock] B ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C on A.product_id = C.product_id;

SELECT TOP 100 A.product_id, B.quantity, C.order_id, C.list_price 
FROM [product].[product] A
FULL OUTER JOIN [product].[stock] B ON A.product_id = B.product_id
FULL OUTER JOIN sale.order_item C on A.product_id = C.product_id
ORDER BY B.store_id;



------------ CROSS JOIN 

/*
In the stocks table, there are not all products held on the product table and you 
want to insert these products into the stock table.

You have to insert all these products for every three stores with "0" quantity.

Write a query to prepare this data.
*/
select product_id, quantity
from product.stock;


select B.store_id, A.product_id, 0 QATTIY 
from product.product A
cross join sale.store B
where A.product_id not in (
select product_id
from product.stock)
order by A.product_id, B.store_id;


--------- SELF COIN

--Write a query that returns the staffs with their managers.
--Expected columns: staff first name, staff last name, manager name

SELECT *
FROM sale.staff;



SELECT A.first_name, B.first_name MANAGER_NAME
FROM sale.staff A
JOIN sale.staff B ON A.manager_id = B.staff_id;

-------Write a query that returns the 1st and 2nd degree managers of all staff

SELECT A.first_name STAFF_NAME, B.first_name MANAGER1_NAME, C.first_name MANAGER2_NAME
FROM sale.staff A
JOIN sale.staff B ON A.manager_id = B.staff_id
JOIN sale.staff C ON B.manager_id = C.staff_id
ORDER BY C.first_name, B.first_name;

SELECT A.first_name, B.first_name MANAGER1_NAME, C.first_name MANAGER2_NAME, D.first_name MANAGER3_NAME
FROM sale.staff A
JOIN sale.staff B ON A.manager_id=B.staff_id
JOIN sale.staff C ON B.manager_id=C.staff_id
JOIN sale.staff D ON C.manager_id=D.staff_id;

------- VIEW OLUSTURMA

CREATE VIEW CUSTUMER_PRODUCT -- SANAL TABLO OLUÞTURMA
AS

SELECT	distinct D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';


SELECT * 
FROM [dbo].[CUSTUMER_PRODUCT]




