


--------------------------------------
-- DS 10/22 EU -- DAwSQL Session 13 --
----------- 19.03.2022 ---------------
--------------------------------------


-- Product tablosunun s�tun isimlerini ve �zelliklerini listeleyiniz.
exec sys.sp_columns 'product', 'product';

-- Orter_item tablosunun s�tun isimlerini ve �zelliklerini listeleyiniz.
exec sys.sp_columns 'order_item' 
;

-- user defined procedures
-- En g�ncel sipari� bilgisini getiriniz
select	top 1 *
from	sale.orders
order by order_id desc
;

-- Yukar�daki sorguyu d�nd�ren prosed�r� olu�turup exec komutu ile �al��t�r�n�z
create or alter procedure usp_thelastorder -- or alter diye ekleyerek yazarsak b�yle isimde prosed�r varsa de�i�titir.

AS

select	top 1 *
from	sale.orders
order by order_id desc
;

exec usp_thelastorder
;
usp_thelastorder
;

-- Bug�n�n tarihi: '2020-04-29'
-- Bug�n yap�lan toplam sipari� say�s�n� getiren prosed�r

create procedure usp_datecount

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date = '2020-04-29'
GROUP by    order_date
;


exec usp_datecount
;

-- Girdi�imiz tarihte yap�lan toplam sipari� say�s�n� getiren bir prosed�r yaz�n�z.

create procedure usp_datecount2 
(@tarih DATE)

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date = @tarih
GROUP by    order_date
;

exec usp_datecount2 '2020-04-04'
;

-- �Ki tarih aras�ndaki sipari� say�lar�n� g�nl�k olarak listeleyiniz
create procedure usp_datecount3 
(@tarih1 DATE, @tarih2 DATE)

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date between @tarih1 and @tarih2
GROUP by    order_date
;

exec usp_datecount3 '2020-04-04', '2020-04-06'



-- Parametreler

-- parametre tan�mlama
DECLARE @param1 DATE
-- parametrelere de�er atama
SET @param1 = '2020-04-29'
-- parametreleri sorgu i�inde kullanma
select	*
from	sale.orders
where	order_date = @param1

-- Select blo�u i�inde parametrelerin atanmas�
DECLARE @param1 DATE, @param2 INT

SET @param1 = '2020-04-02'

select	@param2 = count(*)
from	sale.orders
where	order_date = @param1

print @param2
;


-- Girdi�imiz tarihte yap�lan toplam sipari� say�s�n� getiren bir prosed�r yaz�n�z.
-- Print komutunu kullan�n�z.

create procedure usp_datecount4
(@tarih DATE)

AS

DECLARE @param INT

select  @param = count(order_id)
from    sale.orders
WHERE order_date = @tarih
GROUP by    order_date

print @param
;

exec usp_datecount4 '2020-04-04'
;

-- Fonksiyonlar

select len('abc');

select Ascii('a');

print len('abc');


create function udf_upper 

(@param nvarchar(max))

RETURNS nvarchar(max)

AS

BEGIN
	return upper(@param)
END
;

select	dbo.udf_upper('abc')
;


---print upper('abc')

-- Bir harfin sesli mi sessiz mi oldu�unu d�nd�ren fonksiyon yaz�n�z.
-- Mehmet Emin arkada��m�za te�ekk�r ediyoruz (hem bu kodun yaz�m�nda hem de di�er desteklerinde)

DECLARE @harf char(1)

SET @harf = 'a'

if @harf in ('a', 'e', '�', 'i', 'o', '�', 'u', '�')
	print 'sesli harf'
else if @harf in ('b', 'c', '�', 'd', 'f', 'g', '�', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'r', 's', '�', 't', 'v', 'y', 'z')
	print 'sessiz harf'
else
	print 'L�tfen T�rk�e bir harf yaz�n�z.'



CREATE FUNCTION udf_sesli
(@harf NVARCHAR(MAX))

RETURNS NVARCHAR(MAX)

BEGIN

    if @harf in ('a', 'e', '�', 'i', 'o', '�', 'u', '�')
       SET @harf =   'sesli harf'
    else if @harf in ('b', 'c', '�', 'd', 'f', 'g', '�', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'r', 's', '�', 't', 'v', 'y', 'z')
       SET @harf =  'sessiz harf'
    else
       SET @harf =   'L�tfen T�rk�e bir harf yaz�n�z.'

    RETURN @harf
END;

-- 1 2 3 4 5 6 7 8 9 
-- Girdi�imiz rakama kadar t�m rakamlar�n toplam�n� d�nd�ren bir kod yaz�n�z.

DECLARE @input INT, @counter INT, @sonuc INT

SET @input = 3
SET @counter = 1
SET @sonuc = 0

while @counter <= @input
	BEGIN
		set @sonuc = @sonuc + @counter
		set @counter = @counter + 1
	END;

print @sonuc



DECLARE @input INT, @counter INT, @sonuc INT

SET @input = 3
SET @counter = 1
SET @sonuc = 0

while @counter <= @input
	BEGIN
		SET @ix = 1
		set @sonuc = @input *( @input-1)
		set @input = @input - 1
	END;

print @sonuc

