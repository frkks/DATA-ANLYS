


--------------------------------------
-- DS 10/22 EU -- DAwSQL Session 13 --
----------- 19.03.2022 ---------------
--------------------------------------


-- Product tablosunun sütun isimlerini ve özelliklerini listeleyiniz.
exec sys.sp_columns 'product', 'product';

-- Orter_item tablosunun sütun isimlerini ve özelliklerini listeleyiniz.
exec sys.sp_columns 'order_item' 
;

-- user defined procedures
-- En güncel sipariþ bilgisini getiriniz
select	top 1 *
from	sale.orders
order by order_id desc
;

-- Yukarýdaki sorguyu döndüren prosedürü oluþturup exec komutu ile çalýþtýrýnýz
create or alter procedure usp_thelastorder -- or alter diye ekleyerek yazarsak böyle isimde prosedör varsa deðiþtitir.

AS

select	top 1 *
from	sale.orders
order by order_id desc
;

exec usp_thelastorder
;
usp_thelastorder
;

-- Bugünün tarihi: '2020-04-29'
-- Bugün yapýlan toplam sipariþ sayýsýný getiren prosedür

create procedure usp_datecount

AS

select  order_date, count(order_id)
from    sale.orders
WHERE order_date = '2020-04-29'
GROUP by    order_date
;


exec usp_datecount
;

-- Girdiðimiz tarihte yapýlan toplam sipariþ sayýsýný getiren bir prosedür yazýnýz.

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

-- ÝKi tarih arasýndaki sipariþ sayýlarýný günlük olarak listeleyiniz
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

-- parametre tanýmlama
DECLARE @param1 DATE
-- parametrelere deðer atama
SET @param1 = '2020-04-29'
-- parametreleri sorgu içinde kullanma
select	*
from	sale.orders
where	order_date = @param1

-- Select bloðu içinde parametrelerin atanmasý
DECLARE @param1 DATE, @param2 INT

SET @param1 = '2020-04-02'

select	@param2 = count(*)
from	sale.orders
where	order_date = @param1

print @param2
;


-- Girdiðimiz tarihte yapýlan toplam sipariþ sayýsýný getiren bir prosedür yazýnýz.
-- Print komutunu kullanýnýz.

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

-- Bir harfin sesli mi sessiz mi olduðunu döndüren fonksiyon yazýnýz.
-- Mehmet Emin arkadaþýmýza teþekkür ediyoruz (hem bu kodun yazýmýnda hem de diðer desteklerinde)

DECLARE @harf char(1)

SET @harf = 'a'

if @harf in ('a', 'e', 'ý', 'i', 'o', 'ö', 'u', 'ü')
	print 'sesli harf'
else if @harf in ('b', 'c', 'ç', 'd', 'f', 'g', 'ð', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'r', 's', 'þ', 't', 'v', 'y', 'z')
	print 'sessiz harf'
else
	print 'Lütfen Türkçe bir harf yazýnýz.'



CREATE FUNCTION udf_sesli
(@harf NVARCHAR(MAX))

RETURNS NVARCHAR(MAX)

BEGIN

    if @harf in ('a', 'e', 'ý', 'i', 'o', 'ö', 'u', 'ü')
       SET @harf =   'sesli harf'
    else if @harf in ('b', 'c', 'ç', 'd', 'f', 'g', 'ð', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'r', 's', 'þ', 't', 'v', 'y', 'z')
       SET @harf =  'sessiz harf'
    else
       SET @harf =   'Lütfen Türkçe bir harf yazýnýz.'

    RETURN @harf
END;

-- 1 2 3 4 5 6 7 8 9 
-- Girdiðimiz rakama kadar tüm rakamlarýn toplamýný döndüren bir kod yazýnýz.

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

