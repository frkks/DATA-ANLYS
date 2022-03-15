



--Herbir kategori i�inde �r�nlerin fiyat s�ralamas�n� yap�n�z (artan fiyata g�re 1'den ba�lay�p birer birer artacak)


SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num
FROM	product.product
order by category_id, list_price
;


--Ayn� soruyu ayn� fiyatl� �r�nler ayn� s�ra numaras�n� alacak �ekilde yap�n�z (RANK fonksiyonunu kullan�n�z)

SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num,
		RANK () OVER(PARTITION BY category_id ORDER BY list_price) Rank_num
FROM	product.product
order by category_id, list_price
;



SELECT	category_id, list_price,
		ROW_NUMBER() OVER(PARTITION BY category_id ORDER BY list_price) Row_num,
		RANK () OVER(PARTITION BY category_id ORDER BY list_price) Rank_num,
		DENSE_RANK () OVER(PARTITION BY category_id ORDER BY list_price) Dense_Rank_num
FROM	product.product
order by category_id, list_price
;


/*SELECT	product_id,
		NTILE(16) OVER(PARTITION BY list_price ORDER BY list_price) Row_num
		
FROM product.product
order by product_id*/

-------------------------------------------- CUME_DIST-----------------------------

SELECT	brand_id, list_price, 
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST
FROM	product.product
;

----------------------------------------------PERCENT_RANK------------------------------------

SELECT	brand_id, list_price, 
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST,
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS PERCENT_RANK
FROM	product.product
;

---------------------------------------------NT�LE()----------------------------------------

SELECT	brand_id, list_price, 
		ROUND (CUME_DIST() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS CUM_DIST,
		ROUND (PERCENT_RANK() OVER (PARTITION BY brand_id ORDER BY list_price) , 3) AS PERCENT_RANK,
		NTILE(4) OVER (PARTITION BY brand_id ORDER BY list_price) AS NTILE_,
		COUNT(*) OVER (PARTITION BY brand_id) AS URUNSAYISI
FROM	product.product
;

---Herbir sipari�in toplam fiyat�
---�r�nler liste fiyat� �zerinden sat�lm�� olsayd� sipari�lerin toplam fiyat� ne olurdur?

SELECT  a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
		(b.list_price * (1 - b.discount)) * b.quantity
FROM sale.orders a, sale.order_item b
where a.order_id = b.order_id
order by a.order_id, b.item_id



-- 1- Herbir sipari�in toplam fiyat�
with tbl as (
	select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
			(b.list_price * (1 - b.discount)) * b.quantity ara_toplam,
			sum((b.list_price * (1 - b.discount)) * b.quantity) over(partition by a.order_id) siparis_toplami,
			sum(b.list_price * b.quantity) over(partition by a.order_id) siparis_toplami_liste_fiyati,
			sum(quantity) over(partition by a.order_id) urun_adedi
	from	sale.orders a, sale.order_item b
	where	a.order_id = b.order_id
)
select	distinct order_id, siparis_toplami, siparis_toplami_liste_fiyati, urun_adedi,
		1 - (siparis_toplami / siparis_toplami_liste_fiyati) discount_ratio_order,
		cast(100 * (1 - (siparis_toplami / siparis_toplami_liste_fiyati)) as INT) discount_ratio_order_INT
from	tbl
order by 1 - (siparis_toplami / siparis_toplami_liste_fiyati) desc
;

-- Herbir ay i�in �u alanlar� hesaplay�n�z:
--  O aydaki toplam sipari� say�s�
--  Bir �nceki aydaki toplam sipari� say�s�
--  Bir sonraki aydaki toplam sipari� say�s�
--  Aylara g�re y�l i�indeki k�m�latif sipari� y�zdesi

select	convert(NVARCHAR(6), getdate(), 112) ay


with tbl as (
		select	distinct
				year(order_date) yil,
				convert(nvarchar(6), order_date, 112) ay,
				count(*) over(partition by convert(nvarchar(6), order_date, 112)) toplam_siparis
		from	sale.orders
)
select	*,
		lag(toplam_siparis) over(order by ay) onceki_toplam_siparis,
		lead(toplam_siparis) over(order by ay) sonraki_toplam_siparis,
		CUME_DIST() over(partition by yil order by ay) kumulatif_yuzde
from	tbl


