


SELECT *
FROM sale.orders

select * 
from sale.order_item;


SELECT order_id,product_id, list_price, discount
FROM sale.order_item 
order by product_id

SELECT order_id, product_id
FROM sale.order_item 
group by order_id, product_id;




with tbl as (
	select	a.order_id, b.item_id, b.product_id, b.quantity, b.list_price, b.discount,
			(b.list_price * (1 - b.discount)) * b.quantity ara_toplam,
			sum((b.list_price * (1 - b.discount)) * b.quantity) over(partition by a.order_id) siparis_toplami,
			sum(b.list_price * b.quantity) over(partition by a.order_id) siparis_toplami_liste_fiyati,
			sum(quantity) over(partition by a.order_id) urun_adedi
	from	sale.orders a, sale.order_item b
	where	a.order_id = b.order_id
)

select order_id, siparis_toplami, siparis_toplami_liste_fiyati, urun_adedi, product_id,
		1 - (siparis_toplami / siparis_toplami_liste_fiyati) discount_ratio_order,
		cast( 100 * (1 - (siparis_toplami / siparis_toplami_liste_fiyati))
			as INT)
		discount_ratio_order_INT
from	tbl
order by product_id 
;


select	product_id, list_price,
		ROW_NUMBER() OVER(partition by product_id order by list_price ASC) Row_num,
		RANK() OVER(partition by product_id order by list_price ASC) Rank_num,
		DENSE_RANK() OVER(partition by product_id order by list_price ASC) Dense_Rank_num
from	sale.order_item
order by product_id, list_price
;

SELECT	product_id, list_price, 
		ROUND (CUME_DIST() OVER (PARTITION BY product_id ORDER BY list_price) , 3) AS CUM_DIST,
		ROUND (PERCENT_RANK() OVER (PARTITION BY product_id ORDER BY list_price) , 3) AS PERCENT_RANK, 
		NTILE(4) OVER (PARTITION BY product_id ORDER BY list_price) AS NTILE_NUM,
		COUNT(*) OVER(PARTITION BY product_id) AS UrunSayisi
FROM	sale.order_item
;