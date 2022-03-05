------- Built-in Function -----

------- March 3, 2022 ------

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	);

	select * from t_date_time;

	SELECT GETDATE(); --- þu anýn bigisini döndürüyor.

	INSERT t_date_time 
	VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE());

	select * from t_date_time;

	INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
	VALUES ('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' ); 

	select * from t_date_time;

	------------- 


	SELECT CONVERT(varchar, GETDATE(), 7);

	SELECT CONVERT(DATE, '25 OCT 21', 6);

	--------------------

	SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2]
	FROM	t_date_time;


	SELECT	A_date,
		DATENAME(DW, A_date) [DAY],
		DAY (A_date) [DAY2],
		MONTH(A_date),
		YEAR (A_date),
		A_time,
		DATEPART (NANOSECOND, A_time),
		DATEPART (MONTH, A_date)
FROM	t_date_time;


------------------DATEDIFF


SELECT	A_date,	
		A_datetime, A_smalldatetime
FROM	t_date_time;

SELECT	A_date
		A_datetime,
	DATEDIFF (DAY, A_date, A_datetime) Diff_day,
	DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour
FROM	t_date_time

SELECT	A_date,	
		A_datetime,
		DATEDIFF (DAY, A_date, A_datetime) Diff_day,
		DATEDIFF (MONTH, A_date, A_datetime) Diff_month,
		DATEDIFF (YEAR, A_date, A_datetime) Diff_month,
		DATEDIFF (HOUR, A_smalldatetime, A_datetime) Diff_Hour,
		DATEDIFF (MINUTE, A_smalldatetime, A_datetime) Diff_Hour
FROM	t_date_time;



SELECT * FROM sale.orders;

SELECT  
order_date,shipped_date, 
DATEDIFF(day, order_date, shipped_date) as DaysToShip
FROM [sale].[orders];

		SET DATEFORMAT DMY –FORMATI ÝSTEDÝÐÝMÝZ GÝBÝ AYARLIYORUZ;

----------DATEADD EOMONTH


SELECT * 
FROM sale.orders;

SELECT order_date,
	dateadd(year, 3, order_date) new_year,
	dateadd(day, -5, order_date) new_day
FROM sale.orders;


---EOMONTH


select EOMONTH(order_date) last_day, order_date
from sale.orders;

select EOMONTH(order_date) last_day, order_date, EOMONTH(order_date,2) after_2
from sale.orders;



--------------ISDATE

select isdate ('123456');

SELECT ISDATE ('2022-03-03');


--------LEN / CHARINDEX / PATHINDEX

SELECT LEN (123456)

SELECT LEN ('WELCOME')
SELECT LEN (WELCOME)
SELECT LEN ('welcome')
SELECT LEN (welcome)

------ 

select CHARINDEX('C', 'CHARACTER')

select CHARINDEX('C', 'CHARACTER',2)

select CHARINDEX('CT', 'CHARACTER')

-----------


select PATINDEX('%R', 'CHARACTER')

select PATINDEX('R%', 'CHARACTER')

select PATINDEX('___R%', 'CHARACTER')


---------LEFT  - RIGHT - SUBSTRING


select LEFT('CHARACTER',3)
select LEFT(' CHARACTER',3)


select RIGHT('CHARACTER',3)
select RIGHT('CHARACTER ',3)


select SUBSTRING('CHARACTER',3, 5)
select SUBSTRING('CHARACTER',-1, 5) --CHA DÖNDÜRÜR.


------------ LOWER - UPPER  - STRING-SPLIT

select LOWER('CHARACTER')

select UPPER('character')

select UPPER(LEFT('character', 1)) + LOWER(RIGHT('character',8))
SELECT UPPER(LEFT('character',1)) + LOWER (RIGHT('character', LEN ('character')-1))


SELECT 'A'+'B'



SELECT * FROM string_split('Jhon, jeremy, jack, George', ',')


------------ltrim/ rtrim / trim

SELECT TRIM('   CHARACTER')


SELECT TRIM('   CHARACTER     ')

SELECT TRIM('   CHAR   ACTER   ')


SELECT TRIM('?, ' FROM '    ?SQL Server,    ') AS TrimmedString;

SELECT LTRIM('   CHARACTER     ')

SELECT RTRIM('   CHARACTER     ')


------------REPLACE / STR

SELECT   REPLACE('CHARACTER STRING', '','/')

SELECT STR(5454) --DEFALTU 10 ON KARAKTER BOÞLUK BIRAKIYOR.
      5454
SELECT STR(1234567891)
1234567891

SELECT STR(5454, 10, 5) --TOTALDE 10 KARAKTER DÖNDÜR NOKTADAN SONRA 5 DÖNDÜR.

SELECT STR (133215.654645, 11, 3)


--------------CAST / CONVERT / COALESCE / NULLIF / ROUND

SELECT CAST (456123 AS CHAR)  --CHAR DÖNÜÞTÜRDÜ


SELECT CAST (456.123 AS INT) --INT DÖNÜÞTÜRDÜ

SELECT CONVERT (INT , 30.60)  --INT DÖNÜÞTÜRDÜ

SELECT CONVERT (varchar(10),  '2020-10-10')

SELECT COALESCE (NULL, NULL , 'Hi','HELLO', NULL) result;

select NULLIF (10,10)

select NULLIF ('Hi','HELLO') result;

SELECT ROUND (432.368,2,0)

SELECT ROUND (432.368,1,0)

SELECT ROUND (432.368,2,1)

SELECT ROUND (432.368,2)