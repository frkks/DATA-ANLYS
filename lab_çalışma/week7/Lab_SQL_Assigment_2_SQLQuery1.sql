--SELECT NULLIF(1,1)
--SELECT NULLIF(0,1)


select E.*,
		isnull(nullif(isnull(str(F.customer_id), 'No'), str(F.customer_id)), 'Yes') First_product,
		isnull(nullif(isnull(str(G.customer_id), 'No'),str(G.customer_id)), 'Yes') Second_product,
		isnull(nullif(isnull(str(H.customer_id), 'No'),str(H.customer_id)), 'Yes') Third_product
from
(
select distinct A.customer_id, A.first_name, A.last_name 
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
) AS E
left join
(
select distinct A.customer_id, A.first_name, A.last_name 
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = 'Polk Audio - 50 W Woofer - Black'
) AS F
ON E.customer_id = F.customer_id
left join
(
select distinct A.customer_id, A.first_name, A.last_name 
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
) AS G
ON E.customer_id = G.customer_id
left join
(
select distinct A.customer_id, A.first_name, A.last_name 
from sale.customer A, sale.orders B, sale.order_item C, product.product D
where A.customer_id = B.customer_id
and B.order_id = C.order_id
and C.product_id = D.product_id
and D.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'
) AS H
ON E.customer_id = H.customer_id
order by  E.customer_id;
