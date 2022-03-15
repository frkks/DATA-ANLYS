


-------------------------------------
-- DS 10/22 EU -- DAwSQL Session 9 --
----------- 12.03.2022 --------------
-------------------------------------



-- Ürünlerin stock sayýlarýný bulunuz

select	product_id, sum(quantity) total_stock
from	product.stock
group by product_id
order by product_id
;

select	*, sum(quantity) over (partition by product_id) total_stock
from	product.stock
order by product_id
;

-- Markalara göre ortalama ürün fiyatlarýný hem Group By hem de Window Functions ile hesaplayýnýz.

select	brand_id, avg(list_price) avg_price
from	product.product
group by brand_id
;

select	distinct brand_id, avg(list_price) over(partition by brand_id) avg_price
from	product.product
order by 1 desc
;


-- Windows frame i anlamak için birkaç örnek:
-- Herbir satýrda iþlem yapýlacak olan frame in büyüklüðünü (satýr sayýsýný) tespit edip window frame in nasýl oluþtuðunu aþaðýdaki sorgu sonucuna göre konuþalým.


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

;


-- en ucuz ürünün fiyatý

select	top 1 list_price
from	product.product
order by list_price
;

-- en ucuz ürünlerin isimlerini vi fiyatlarýný getiriniz.

SELECT distinct min(list_price) over()
from product.product
;

select	*
from	(
		select	product_name, list_price, min(list_price) over() cheapest
		from	product.product
		) A
where	A.list_price = A.cheapest
;

-- Herbir kategorideki en ucuz ürünün fiyatý

select	distinct category_id, min(list_price) over(partition by category_id) cheapest_by_cat
from	product.product
;

-- Product tablosunda toplam kaç faklý product bulunduðu

select count(model_year)
from product.product
;

select	distinct count(*) over()
from	product.product
;

-- Order_item tablosunda kaç farklý ürün bulunmaktadýr?

select	count(distinct product_id)
from	sale.order_item
;

-- Ayný sorguyu Window Functions ile yaptýðýnýz hata alýrsýnýz.
-- Çünkü windows functions içinde count(distinct ...) kullanamazsýnýz
select	count(distinct product_id) over ()
from	sale.order_item
;

-- Her sipariþte kaç farklý ürün olduðunu döndüren bir sorgu yazýn?
select	distinct order_id, count(item_id) over(partition by order_id) cnt_product
from	sale.order_item
;

-- Herbir kategorideki herbir markada kaç farklý ürünün bulunduðu
select	distinct category_id, brand_id, count(*) over(partition by brand_id, category_id) num_of_prod
from	product.product
order by brand_id, category_id
;

-- Müþterilerin sipariþ tarihini ve ayrýca tüm sipariþler içinde en eski sipariþ tarihini getiriniz
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date, b.order_id) min_order_date
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

-- Müþterilerin sipariþ tarihini ve ayrýca tüm sipariþler içinde en yeni sipariþ tarihini getiriniz
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date desc, b.order_id desc) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

-- Bu sorguyu LAST_VALUE ile yaptýðýmýzda window frame i belirlememiz gerekiyor.
-- Aksi taktirde order by kullandýðýmýzda default window frame UNBOUNDED PRECEDING AND CURRENT ROW oluyor.
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date desc, b.order_id desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;


-- Liste fiyatý en düþük olan ürünün adýný getiriniz.
select	distinct first_value(product_name) over (order by list_price, model_year DESC) cheapest_product
from	product.product
;

-- Liste fiyatý en düþük olan ürünün adýný e fiyatýný getiriniz.
select	distinct
		first_value(product_name) over (order by list_price, model_year DESC) cheapest_product_name,
		first_value(list_price) over (order by list_price, model_year DESC) cheapest_product_price
from	product.product
;

-- Çalýþanlarýn satýþ yaptýklarý tarihleri listeleyin ve ayrýca bir önceki satýþ tarihlerini de yanýna yazdýrýnýz.
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- Çalýþanlarýn satýþ yaptýklarý tarihleri listeleyin ve ayrýca bir sonraki satýþ tarihlerini de yanýna yazdýrýnýz.
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lead(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- Lead ve lag fonksiyonlarý ile yapabileceðiniz baþka örnekler:
-- Çalýþanlarýn 2 önceki satýþ tarihi, bir önceki satýþ tarihi, bir sonraki satýþ tarihi ve 2 sonraki satýþ tarihi
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lag2,
		lag(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lag1,
		lead(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lead1,
		lead(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lead2
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;