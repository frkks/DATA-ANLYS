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


------- 2021 �r�nlerinden game, gps, theater olmayanlar

select * 
from product.product
where model_year = 2021 and 
category_id not in (
			select category_id 
			from product.category
			where category_name in ('Game', 'gps', 'Home Theater')
			);

/*ANY operator:
Boolean de�er d�nd�r�r.
E�er subquery'nin de�erlerinden herhangi biri ko�ulu kar��l�yorsa TRUE d�nd�r�r. Yani aral�ktaki de�erlerden herhangi biri TRUE ise ko�ulun TRUE olaca�� anlam�na gelir.
ALL operator:
Boolean de�er d�nd�r�r.
Ancak t�m subquery de�erleri ko�ulu sa�l�yorsa TRUE d�nd�r�r. Yani aral�ktaki t�m de�erler i�in i�lem TRUE ise �art o zaman TRUE olacakt�r.
SELECT, WHERE ve HAVING statement'lar� ile birlikte kullan�l�r.*/

--------Receivers Amplifiers (ALL)

select product_name, model_year, list_price
from product.product
where model_year = 2020 and 
list_price > all ( --- buradaki �r�nlerden tamam�ndan pahal� olanlar i�in all hepsinden pahal� olanlar i�in any 
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
list_price > ANY (  --- hepsinden pahal� olanlar i�in any 
			select b.list_price 
			from product.category a, product.product b
			where category_name = 'Receivers Amplifiers' and
			a.category_id = b.category_id
			)
order by list_price desc;


------- CORRELETED SUB QUER�ES
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
/*CTE�ler (Common Table Expressions) nedir ?
CTE (Common Table Expression), ge�ici olarak var olan ve genelde yinelemeli(recursive) ve b�y�k 
sorgu ifadelerinde kullan�m i�in olan bir sorgunun sonu� k�mesi olarak d���nebiliriz.
Veritaban� g�r�n�mleri(views) ne benzetebiliriz, ancak hi� bir �ekilde alanlar�n (field&column) 
deklare edilmesi gerekmez. CTE�lerin sonu�lar� depolanmaz ve yaln�zca i�lem s�resince var olur.*/

/*CTE�leri nas�l olu�tururuz ?
�WITH� keyword�� ile ba�lat�n.
Tablo olarak kullanaca��m�z, ge�ici bir �isim� atamas� yap�n.
�sim atamas� yapt�ktan sonra, �AS� ile devam edin.
�ste�e ba�l� olarak, field�lar�n isimlerini yazabilirsiniz (field1,field2)
Sonu� i�in bir sorgu yaz�n.
Birden fazla CTE�yi bir araya getirmek i�in, her CTE�den sonra �,� ekleyerek 2�4. ad�mlar� tekrarlay�n.
�CTE� dizilimi bittikten sonra, CTE�den referans alacak �ekilde sorgunuzu yaz�n.*/
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