--CREATING TABLES FOR IN-CLASS
--CREATE DATABASE departments
--USE departments
CREATE TABLE employees_A
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);
INSERT employees_A VALUES
 (17679,  'Robert'    , 'Gilmore'       ,   110000 ,  'Operations Director', 'Male')
,(26650,  'Elvis'    , 'Ritter'        ,   86000 ,  'Sales Manager', 'Male')
,(30840,  'David'   , 'Barrow'        ,   85000 ,  'Data Scientist', 'Male')
,(49714,  'Hugo'    , 'Forester'    ,   55000 ,  'IT Support Specialist', 'Male')
,(51821,  'Linda'    , 'Foster'     ,   95000 ,  'Data Scientist', 'Female')
,(67323,  'Lisa'    , 'Wiener'      ,   75000 ,  'Business Analyst', 'Female')
CREATE TABLE employees_B
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);
INSERT employees_B VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')
CREATE TABLE employees_C
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job VARCHAR (30),
gender VARCHAR(10),
);
INSERT employees_C VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')

--SET OPERATORS
--GÝRÝÞ
/*
	•	Both SELECT statements must contain the same number of columns.
	•	Her iki SELECT ifadesi de ayný sayýda sütun içermelidir.
	•	In the SELECT statements, the corresponding columns must have the same data type.
	•	SELECT ifadelerinde, karþýlýk gelen sütunlar ayný veri tipine sahip olmalýdýr.
	•	Performans açýsýndan, UNION ALL, UNION'a kýyasla daha iyi performans gösterir, çünkü kaynaklar yinelenenleri filtrelemek ve sonuç kümesini sýralamak için boþa harcanmaz.
	•	Set operatörleri alt sorgularýn bir parçasý olabilir.
*/

SELECT emp_id, first_name, last_name, job_title
  FROM employees_A
UNION
SELECT emp_id, first_name, last_name, job
  FROM employees_C

SELECT emp_id, first_name, last_name, job--sonuçta gelen sütun ismi job, ilk yazýlan TABLOYA göre birleþtirildi
  FROM employees_C --Üçüncü bir tablo oluþturdum
  UNION
 SELECT emp_id, first_name, last_name, job_title
  FROM employees_A

  SELECT *  --ÝKÝ YILDIZ OLURSA KABUL EDÝYOR
  FROM employees_A
UNION
SELECT *
  FROM employees_C

--EXAMPLE 4:
SELECT *
  FROM employees_A
UNION
SELECT emp_id, first_name, last_name, salary, job, gender
  FROM employees_C