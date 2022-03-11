------- SUB QERY

--David Thomas

select * 
from sale.staff
where store_id = (
          select store_id 
          from sale.staff
            where first_name = 'Davis' and last_name = 'Thomas' 
			);

--- Charles Cussona

select * 
from sale.staff
where manager_id = (
		select staff_id 
		from sale.staff
		where first_name = 'Charles' and last_name = 'Cussona');



----The BFLO Store

select * 
from sale.customer
where city = (
		select city 
		from sale.store
		where store_name = 'The BFLO Store');


-----Pro-Series 49-Class Full HD Outdoor LED TV (Silver)

select *
from product.product
where list_price > (
			select list_price
			from product.product
			where product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)');

select *
from product.product
where list_price > (
			select list_price
			from product.product
			where product_name = 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'
			) and 
			category_id = (
			select category_id 
			from product.category
			where category_name = 'Televisions & Accessories');


------Laurel Goldammer


select b.first_name, b.last_name, a.order_date 
from sale.orders a, sale.customer b
where a.customer_id = b.customer_id and
		a.order_date in (
select a.order_date
 from sale.orders a, sale.customer b
 where a.customer_id = b.customer_id and
		b.first_name = 'Laurel' and
		b.last_name = 'Goldammer');


------- 2021 ürünlerinden game, gps, theater olmayanlar

select * 
from product.product
where model_year = 2021 and 
category_id not in (
			select category_id 
			from product.category
			where category_name in ('Game', 'gps', 'Home Theater')
			);

/*ANY operator:
Boolean deðer döndürür.
Eðer subquery'nin deðerlerinden herhangi biri koþulu karþýlýyorsa TRUE döndürür. Yani aralýktaki deðerlerden herhangi biri TRUE ise koþulun TRUE olacaðý anlamýna gelir.
ALL operator:
Boolean deðer döndürür.
Ancak tüm subquery deðerleri koþulu saðlýyorsa TRUE döndürür. Yani aralýktaki tüm deðerler için iþlem TRUE ise þart o zaman TRUE olacaktýr.
SELECT, WHERE ve HAVING statement'larý ile birlikte kullanýlýr.*/

--------Receivers Amplifiers (ALL)

select product_name, model_year, list_price
from product.product
where model_year = 2020 and 
list_price > all ( --- buradaki ürünlerden tamamýndan pahalý olanlar için all hepsinden pahalý olanlar için any 
			select b.list_price 
			from product.category a, product.product b
			where category_name = 'Receivers Amplifiers' and
			a.category_id = b.category_id
			)
order by list_price desc;
-------------------------------------------------------------- ikinci yol
select product_name, model_year, list_price
from product.product
where model_year = 2020 and 
list_price > (
			select max(b.list_price)
			from product.category a, product.product b
			where category_name = 'Receivers Amplifiers' and
			a.category_id = b.category_id
			)
order by list_price desc;

--------Receivers Amplifiers (ANY)


select product_name, model_year, list_price
from product.product
where model_year = 2020 and 
list_price > ANY (  --- hepsinden pahalý olanlar için any 
			select b.list_price 
			from product.category a, product.product b
			where category_name = 'Receivers Amplifiers' and
			a.category_id = b.category_id
			)
order by list_price desc;


------- CORRELETED SUB QUERÝES
-------------------EXISTS---------------
----Apple - Pre-Owned iPad 3 - 32GB - White----

select distinct[state]
from  sale.customer d
where not exists (


select * 
from sale.orders a, sale.order_item b, product.product c, sale.customer e
where a.order_id = b.order_id and
		b.product_id = c.product_id and
		c.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
		a.customer_id = e.customer_id and
		d.state = e. state
		)

---------2020-01-01

select	distinct b.customer_id, b.first_name, b.last_name
from	sale.orders a, sale.customer b
where	a.customer_id = b.customer_id and
		NOT EXISTS (
			select	*
			from	sale.orders c
			where	c.order_date < '2020-01-01' and
					b.customer_id = c.customer_id
		)




----------------------WITH---------------

--------- Jerald Berray-----------

WITH table_name AS (
		SELECT	MAX(B.order_date) last_order_date
		FROM	sale.customer A, sale.orders B
		WHERE	A.first_name = 'Jerald' AND
					A.last_name = 'Berray' AND
					A.customer_id = B.customer_id
	)
SELECT	*
FROM	table_name


------ Recursive CTE
/*CTE‘ler (Common Table Expressions) nedir ?
CTE (Common Table Expression), geçici olarak var olan ve genelde yinelemeli(recursive) ve büyük 
sorgu ifadelerinde kullaným için olan bir sorgunun sonuç kümesi olarak düþünebiliriz.
Veritabaný görünümleri(views) ne benzetebiliriz, ancak hiç bir þekilde alanlarýn (field&column) 
deklare edilmesi gerekmez. CTE’lerin sonuçlarý depolanmaz ve yalnýzca iþlem süresince var olur.*/

/*CTE’leri nasýl oluþtururuz ?
“WITH” keyword’ü ile baþlatýn.
Tablo olarak kullanacaðýmýz, geçici bir “isim” atamasý yapýn.
Ýsim atamasý yaptýktan sonra, “AS” ile devam edin.
Ýsteðe baðlý olarak, field’larýn isimlerini yazabilirsiniz (field1,field2)
Sonuç için bir sorgu yazýn.
Birden fazla CTE’yi bir araya getirmek için, her CTE’den sonra “,” ekleyerek 2–4. adýmlarý tekrarlayýn.
“CTE” dizilimi bittikten sonra, CTE’den referans alacak þekilde sorgunuzu yazýn.*/
;
with tablorakam as (
		select	1 rakam
		
		union all
		select	rakam + 1
		from	tablorakam
		where	rakam < 10
)
select	*
from	tablorakam