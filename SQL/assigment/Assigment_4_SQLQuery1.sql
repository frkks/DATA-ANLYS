


with t1 as
(

select	product_id, discount, sum(quantity) quantity1		
from	sale.order_item
GROUP BY 
	GROUPING SETS ((discount, product_id))
order by product_id
)

select product_id, discount,
	lead(quantity1) over (partition by product_id order by dicount) lead_,
	row_number () over (partition by product_id order by dicount) rows_
from t1
order by  product_id, discount
