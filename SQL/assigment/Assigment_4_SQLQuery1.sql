


select	product_id, discount, sum(quantity) quantity1		
from	sale.order_item
GROUP BY 
	GROUPING SETS ((discount, product_id))
order by product_id




WITH T1 AS
(
SELECT	product_id,
		discount,
		LEAD(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY discount) Top_Sales,
		CASE
			WHEN ((LEAD(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY discount)) - SUM(quantity)) < 0 THEN 'NEGATIVE'
			WHEN ((LEAD(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY discount)) - SUM(quantity)) = 0 THEN 'NEUTRAL'
			WHEN ((LEAD(SUM(quantity)) OVER (PARTITION BY product_id ORDER BY discount)) - SUM(quantity)) > 0 THEN 'POSITIVE'
			END Dis_Effect
FROM sale.order_item
GROUP BY product_id, discount

) 

SELECT product_id, discount,Dis_Effect
FROM T1
ORDER BY product_id

