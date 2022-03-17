
--List the products ordered the last 10 orders in Buffalo city.
-- Buffalo þehrinde son 10 sipariþte sipariþ verilen ürünleri listeleyin.

select * 
from sale.order_item a, product.product b
where a.product_id=b.product_id
and a.order_id in (


select top 10 order_id
from sale.customer a, sale.orders b
where a.customer_id=b.customer_id 
and a.city = 'Buffalo'
order by order_date desc
)

--Müþterilerin sipariþ sayýlarýný, sipariþ ettikleri ürün sayýlarýný ve ürünlere ödedikleri toplam net miktarý raporlayýnýz.

SELECT	A.customer_id, A.first_name, A.last_name, C.*, B.product_id, B.quantity, B.list_price, B.discount, quantity*list_price*(1-discount)
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
AND A.customer_id = 1


select a.customer_id, a.first_name, a.last_name, 
		count (distinct c.order_id) as cnt_order,
		sum(b.quantity) cnt_product,
		sum(quantity*list_price*(1-discount)) net_amount
from sale.customer a, sale.order_item b, sale.orders c
where a.customer_id=c.customer_id
and b.order_id=c.order_id
group by a.customer_id, a.first_name, a.last_name

-- Hiç sipariþ vermemiþ müþterilerde rapora dahil olsun.

select a.customer_id, a.first_name, a.last_name, 
		count (distinct c.order_id) as cnt_order,
		sum(c.quantity) cnt_product,
		sum(quantity*list_price*(1-discount)) net_amount
from sale.customer a
left join sale.orders b on a.customer_id=b.customer_id
left join sale.order_item c on b.order_id=c.order_id
group by a.customer_id, a.first_name, a.last_name
order by 1 desc;


--Þehirlerde verilen sipariþ sayýlarýný, sipariþ edilen ürün sayýlarýný ve ürünlere ödenen toplam net miktarlarý raporlayýnýz.

select a.state,a.city, 
		count (distinct c.order_id) as cnt_order,
		sum(b.quantity) cnt_product,
		sum(quantity*list_price*(1-discount)) net_amount
from sale.customer a, sale.order_item b, sale.orders c
where a.customer_id=c.customer_id
and b.order_id=c.order_id
group by a.city, a.state
order by 1



--Eyaletlerde verilen sipariþ sayýlarýný, sipariþ edilen ürün sayýlarýný ve ürünlere ödenen toplam net miktarlarý raporlayýnýz.



select a.state, 
		count (distinct c.order_id) as cnt_order,
		sum(b.quantity) cnt_product,
		sum(quantity*list_price*(1-discount)) net_amount
from sale.customer a, sale.order_item b, sale.orders c
where a.customer_id=c.customer_id
and b.order_id=c.order_id
group by a.state
order by 1


----State ortalamasýnýn altýnda ortalama ciroya sahip þehirleri listeleyin.

with t1 as
(
select distinct a.state, a.city,
		avg(quantity*list_price*(1-discount)) over (partition by a.state) avg_turnover_ofstate,
		avg(quantity*list_price*(1-discount)) over (partition by a.state, a.city) avg_turnover_ofcity
from sale.customer a, sale.orders b, sale.order_item c
where a.customer_id=b.customer_id
and b.order_id=c.order_id
)
select * 
from t1
where avg_turnover_ofcity < avg_turnover_ofstate


--Create a report shows daywise turnovers of the BFLO Store.
--BFLO Store Maðazasýnýn haftanýn günlerine göre elde ettiði ciro miktarýný gösteren bir rapor hazýrlayýnýz.

select DATENAME(WEEKDAY, order_date) dayofweek_, sum(quantity*list_price*(1-discount)) daywise_turnower
from sale.store a, sale.orders b, sale.order_item c
where a.store_name='The BFLO Store'
and a.store_id = b. store_id
and b.order_id=c.order_id
group by DATENAME(WEEKDAY, order_date)


SELECT *
FROM
(
SELECT	DATENAME(WEEKDAY, order_date) dayofweek_, quantity*list_price*(1-discount) net_amount, datepart(ISOWW, order_date) WEEKOFYEAR
FROM	sale.store A, sale.orders B, sale.order_item C
WHERE	A.store_name = 'The BFLO Store'
AND		A.store_id = B.store_id
AND		B.order_id = C.order_id
AND		YEAR(B.order_date) = 2018
) A
PIVOT
(
SUM (net_amount)
FOR dayofweek_
IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday] )
) AS PIVOT_TABLE
order by WEEKOFYEAR


--Write a query that returns how many days are between the third and fourth order dates of each staff.
--Her bir personelin üçüncü ve dördüncü sipariþleri arasýndaki gün farkýný bulunuz.
WITH T1 AS
(
SELECT staff_id, order_date, order_id,
		LEAD(order_date) OVER (PARTITION BY staff_id ORDER BY order_id) next_ord_date,
		ROW_NUMBER () OVER (PARTITION BY staff_id ORDER BY order_id) row_num
FROM sale.orders
)
SELECT *, DATEDIFF(DAY, order_date, next_ord_date) DIFF_OFDATE
FROM T1
WHERE row_num = 3





--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.