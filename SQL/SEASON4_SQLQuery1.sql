------- ADNVANCED GROUP OPERATTION

--Write a query that checks if any product id is repeated in more than one row in the product table.

SELECT *
FROM product.product;


SELECT product_id, COUNT(product_id) NUM_OF_ROWS
FROM product.product
GROUP BY product_id
HAVING COUNT(product_id) > 1

--Write a query that returns category ids with a maximum list price above 4000 or a minimum list price below 500.

select category_id, max(list_price) max_list_price,min(list_price) min_list_price
from product.product
group by category_id
having max(list_price) > 4000 or
min(list_price) < 500

--Find the average product prices of the brands.
--As a result of the query, the average prices should be displayed in descending order.
--Markalara ait ortalama ürün fiyatlarýný bulunuz.
--ortalama fiyatlara göre azalan sýrayla gösteriniz.

select B.brand_name, avg(list_price) avg_list_price
from product.product A
join product.brand B on A.brand_id = B.brand_id
group by  B.brand_name
order by avg_list_price desc

SELECT B.brand_name,B.brand_id,AVG(list_price) avg_list_price
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
GROUP BY B.brand_name, B.brand_id
ORDER BY avg_list_price DESC

--Write a query that returns BRANDS with an average product price of more than 1000.

SELECT B.brand_name,AVG(list_price) avg_list_price
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
GROUP BY B.brand_name
having AVG(list_price) > 1000
order by avg_list_price asc

--Write a query that returns the net price paid by the customer for each order. (Don't neglect discounts and quantities)


--bir sipariþin toplam net tutarýný getiriniz. (müþterinin sipariþ için ödediði tutar)
--discount' ý ve quantity' yi ihmal etmeyiniz.

---quantity * list_price * (1-discount) 


----GROUPING SETS  


-------SUMMARY TABLE OLUSTURMA

SELECT	C.brand_name as Brand, D.category_name as Category, B.model_year as Model_Year, 
		ROUND (SUM (A.quantity * A.list_price * (1 - A.discount)), 0) total_sales_price
INTO	sale.sales_summary

FROM	sale.order_item A, product.product B, product.brand C, product.category D
WHERE	A.product_id = B.product_id
AND		B.brand_id = C.brand_id
AND		B.category_id = D.category_id
GROUP BY
		C.brand_name, D.category_name, B.model_year




----GROUPING SETS 
SELECT * 
FROM [sale].[sales_summary]

-- 1. Calculate the total sales price

select sum(total_sales_price)
from [sale].[sales_summary]


-- 2 . Calculate the total sales price of the brands

select Brand, sum(total_sales_price) total
from [sale].[sales_summary]
group by Brand

-- 3. Calculate the total sales price of the categories

select *
from [sale].[sales_summary]

select Category,sum(total_sales_price) total
from [sale].[sales_summary]
group by Category

-- 4. Calculate the total sales price by brand and categories

select Brand, Category,sum(total_sales_price) total
from [sale].[sales_summary]
group by Brand, Category


------GROUPING SETS  ile yukarýdaki 4 kode birleþtirme

select Brand, Category, sum(total_sales_price) total
from [sale].[sales_summary]
group by
	GROUPING sets((),
	(Brand),
	(Category),
	(Brand, Category)
	)
order by Brand, Category;


                         ---------- ROLLUP ---------

--Generate different grouping variations that can be produced with the brand and category columns using 'ROLLUP'.
-- Calculate sum total_sales_price
--brand, category, model_year sütunlarý için Rollup kullanarak total sales hesaplamasý yapýn.
--üç sütun için 4 farklý gruplama varyasyonu üretiyor

select Brand, Category, Model_Year, sum(total_sales_price)
from sale.sales_summary
group by 
	rollup (Brand, Category, Model_Year)
order by Model_Year, Category ;


----------- CUBE ---------------

select Brand, Category, Model_Year, sum(total_sales_price)
from sale.sales_summary
group by 
	cube (Brand, Category, Model_Year)
order by Brand, Category ;


---------PÝVOT TABLE ---------

--Write a query that returns total sales amount by categories and model years.

select Category, total_sales_price
from  sale.sales_summary


select * 
from

(select Category, total_sales_price
from  sale.sales_summary) A
pivot
(
			sum(total_sales_price)
			for Category
			in 
			([Audio & Video Accessories]
			,[Bluetooth]
			,[Car Electronics]
			,[Computer Accessories]
			,[Earbud]
			,[gps]
			,[Hi-Fi Systems]
			,[Home Theater]
			,[mp4 player]
			,[Receivers Amplifiers]
			,[Speakers]
			,[Televisions & Accessories])

) piyot_table


