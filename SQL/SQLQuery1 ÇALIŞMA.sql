/*show database;*/

/*CREATE DATABASE Frkss;*/

/*drop database SampleRetail;*/

/*CREATE TABLE table_name (
   id INTEGER PRIMARY KEY,
   name TEXT,
   age INTEGER);*/
/*DROP TABLE table_name;*/

/*TRUNCATE TABLE tablo_adı ;*/

/*ALTER TABLE table_name ADD column_name datatype;*/

/*ALTER TABLE table_name DROP COLUMN column_name;*/

/*ALTER TABLE table_name MODIFY COLUMN column_name datatype;*/

/*INSERT INTO table_name (column_name) VALUES (values);*/

/*SELECT column1, column2, ...
FROM table_name;*/

/* * FROM table_name;*/

/*SELECT DISTINCT column_name FROM table_name;*/

/*SELECT column_name FROM table_name WHERE condition;*/

/*Following operators can be used in the where clause: =, >, <, ≥, ≤, !=, BETWEEN, LIKE, IN*/

/*SELECT COUNT(column_name) FROM table_name WHERE condition;*/

/*SELECT "column_name" FROM "table_name" WHERE "condition" ORDER BY column_name ASC|DESC*/

/*UPDATE table_name SET name = "new_name" WHERE name = "old_name";*/

/*DELETE FROM table_name WHERE condition;*/

/*SELECT column_name(s) INTO new_table FROM old_table WHERE condition;*/

/*SELECT column_name FROM table_name WHERE condition LIMIT number;
SELECT TOP number|percent column_name FROM table_name WHERE condition;*/

/*CREATE PROCEDURE procedureName AS sqlStatement GO;*/

/*EXEC procedureName;*/

/*SELECT column_name FROM table_name_1 INNER JOIN table_name_2 ON table_name_1.column_name = table_name_2.column.name;*/


/*SELECT column_name FROM table_name_1 LEFT JOIN table_name_2 ON table_name_1.column_name = table_name_2.column.name;
SELECT column_name FROM table_name_1 RIGHT JOIN table_name_2 ON table_name_1.column_name = table_name_2.column.name;
SELECT column_name FROM table_name_1 FULL OUTER JOIN table_name_2 ON table_name_1.column_name = table_name_2.column.name;*/

/*SELECT column_name FROM table_name_1 T1, table_name_1 T2 WHERE condition;*/

/*SELECT MIN(column_name) FROM table_name WHERE condition;
SELECT MAX(column_name) FROM table_name WHERE condition;*/

/*CREATE TABLE Students ( ID int NOT NULL,
    LastName varchar(64) NOT NULL,
    FirstName varchar(64),
    Age int,
    PRIMARY KEY (ID));*/

/*CREATE TABLE Students  (
    ID int NOT NULL,
    LastName varchar(64) NOT NULL,
    FirstName varchar(64),
    Age int,
    CONSTRAINT S_Student PRIMARY KEY (ID,LastName)*/


/*ALTER TABLE Students ADD PRIMARY KEY (ID);
ALTER TABLE Students ADD CONSTRAINT S_Student PRIMARY KEY (ID,LastName);*/

/*ALTER TABLE Students DROP PRIMARY KEY;*/

/*CREATE TABLE Scores(
    SubjectID int NOT NULL,
    Scores int NOT NULL,
    ID int,
    PRIMARY KEY (SubjectID),
    FOREIGN KEY (ID) REFERENCES Students(ID));*/

/*CREATE TABLE Students (
    Student_id int NOT NULL AUTO_INCREMENT,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    PRIMARY KEY (Student_id));*/

/*ALTER TABLE Students AUTO_INCREMENT=50;*/

/*select 50 +2 , 51 * 2;*/

