


-------------------------------------
-- DS 10/22 EU -- DAwSQL Session 9 --
----------- 12.03.2022 --------------
-------------------------------------



-- �r�nlerin stock say�lar�n� bulunuz

select	product_id, sum(quantity) total_stock
from	product.stock
group by product_id
order by product_id
;

select	*, sum(quantity) over (partition by product_id) total_stock
from	product.stock
order by product_id
;

-- Markalara g�re ortalama �r�n fiyatlar�n� hem Group By hem de Window Functions ile hesaplay�n�z.

select	brand_id, avg(list_price) avg_price
from	product.product
group by brand_id
;

select	distinct brand_id, avg(list_price) over(partition by brand_id) avg_price
from	product.product
order by 1 desc
;


-- Windows frame i anlamak i�in birka� �rnek:
-- Herbir sat�rda i�lem yap�lacak olan frame in b�y�kl���n� (sat�r say�s�n�) tespit edip window frame in nas�l olu�tu�unu a�a��daki sorgu sonucuna g�re konu�al�m.


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


-- en ucuz �r�n�n fiyat�

select	top 1 list_price
from	product.product
order by list_price
;

-- en ucuz �r�nlerin isimlerini vi fiyatlar�n� getiriniz.

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

-- Herbir kategorideki en ucuz �r�n�n fiyat�

select	distinct category_id, min(list_price) over(partition by category_id) cheapest_by_cat
from	product.product
;

-- Product tablosunda toplam ka� fakl� product bulundu�u

select count(model_year)
from product.product
;

select	distinct count(*) over()
from	product.product
;

-- Order_item tablosunda ka� farkl� �r�n bulunmaktad�r?

select	count(distinct product_id)
from	sale.order_item
;

-- Ayn� sorguyu Window Functions ile yapt���n�z hata al�rs�n�z.
-- ��nk� windows functions i�inde count(distinct ...) kullanamazs�n�z
select	count(distinct product_id) over ()
from	sale.order_item
;

-- Her sipari�te ka� farkl� �r�n oldu�unu d�nd�ren bir sorgu yaz�n?
select	distinct order_id, count(item_id) over(partition by order_id) cnt_product
from	sale.order_item
;

-- Herbir kategorideki herbir markada ka� farkl� �r�n�n bulundu�u
select	distinct category_id, brand_id, count(*) over(partition by brand_id, category_id) num_of_prod
from	product.product
order by brand_id, category_id
;

-- M��terilerin sipari� tarihini ve ayr�ca t�m sipari�ler i�inde en eski sipari� tarihini getiriniz
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date, b.order_id) min_order_date
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

-- M��terilerin sipari� tarihini ve ayr�ca t�m sipari�ler i�inde en yeni sipari� tarihini getiriniz
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date desc, b.order_id desc) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

-- Bu sorguyu LAST_VALUE ile yapt���m�zda window frame i belirlememiz gerekiyor.
-- Aksi taktirde order by kulland���m�zda default window frame UNBOUNDED PRECEDING AND CURRENT ROW oluyor.
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date desc, b.order_id desc ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;


-- Liste fiyat� en d���k olan �r�n�n ad�n� getiriniz.
select	distinct first_value(product_name) over (order by list_price, model_year DESC) cheapest_product
from	product.product
;

-- Liste fiyat� en d���k olan �r�n�n ad�n� e fiyat�n� getiriniz.
select	distinct
		first_value(product_name) over (order by list_price, model_year DESC) cheapest_product_name,
		first_value(list_price) over (order by list_price, model_year DESC) cheapest_product_price
from	product.product
;

-- �al��anlar�n sat�� yapt�klar� tarihleri listeleyin ve ayr�ca bir �nceki sat�� tarihlerini de yan�na yazd�r�n�z.
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- �al��anlar�n sat�� yapt�klar� tarihleri listeleyin ve ayr�ca bir sonraki sat�� tarihlerini de yan�na yazd�r�n�z.
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lead(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;

-- Lead ve lag fonksiyonlar� ile yapabilece�iniz ba�ka �rnekler:
-- �al��anlar�n 2 �nceki sat�� tarihi, bir �nceki sat�� tarihi, bir sonraki sat�� tarihi ve 2 sonraki sat�� tarihi
select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lag2,
		lag(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lag1,
		lead(b.order_date, 1) over(partition by a.staff_id order by b.order_date, b.order_id) lead1,
		lead(b.order_date, 2) over(partition by a.staff_id order by b.order_date, b.order_id) lead2
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date
;