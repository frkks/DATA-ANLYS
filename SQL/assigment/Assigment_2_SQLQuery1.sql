
CREATE VIEW CUSTMOER_PRODUCT1
AS

SELECT	distinct D.customer_id, D.first_name, D.last_name,A.product_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'

SELECT * FROM [dbo].[CUSTMOER_PRODUCT1]

CREATE VIEW Polk_Audio1 
AS

SELECT	distinct D.customer_id, D.first_name, D.last_name,A.product_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Polk Audio - 50 W Woofer - Black'

SELECT * FROM [dbo].[Polk_Audio1]

CREATE VIEW SB_20001 
AS

SELECT	distinct D.customer_id, D.first_name, D.last_name,A.product_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'

SELECT * FROM [dbo].[SB_20001]

CREATE VIEW Virtually1
AS

SELECT	distinct D.customer_id, D.first_name, D.last_name,A.product_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id=B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'

SELECT * FROM [dbo].[Virtually1]

CREATE VIEW SONUC
AS
SELECT A.customer_id,A.first_name,A.last_name, REPLACE(B.[product_name],'Polk Audio - 50 W Woofer - Black','YES') First_Product,
REPLACE(C.[product_name], 'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'YES') Second_Product,
REPLACE(D.[product_name],'Virtually Invisible 891 In-Wall Speakers (Pair)', 'YES') Third_Product
FROM [dbo].[CUSTMOER_PRODUCT1] A
LEFT JOIN [dbo].[Polk_Audio1] B ON A.customer_id = B.customer_id
LEFT JOIN [dbo].[SB_20001] C ON A.customer_id = C.customer_id
LEFT JOIN [dbo].[Virtually1] D ON A.customer_id = D.customer_id

---------------------SONUC------------------------------------------

SELECT [customer_id], [first_name],[last_name],ISNULL(First_Product, 'NO') First_Product,
ISNULL(Second_Product, 'NO') Second_Product,ISNULL(First_Product, 'NO') First_Product FROM [dbo].[SONUC]
order by customer_id;
