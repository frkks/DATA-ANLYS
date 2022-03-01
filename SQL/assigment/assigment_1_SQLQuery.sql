CREATE DATABASE Manufacturer;

CREATE TABLE Product (
   prod_id INTEGER PRIMARY KEY,
   prod_name varchar(50),
   quantity INTEGER);

CREATE TABLE Product_Comd (
   prod_id INTEGER PRIMARY KEY,
    comd_id INTEGER PRIMARY KEY,
   quantity_comd INTEGER
   PRIMARY KEY CLUSTERED 
(
	prod_id ASC,
	comd_id ASC
);
ALTER TABLE Product_Comd  WITH CHECK ADD FOREIGN KEY(prod_id)
REFERENCES Product.Product (prod_id)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE Product_comd   WITH CHECK ADD FOREIGN KEY(comd_id)
REFERENCES Component (comd_id)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

CREATE TABLE Component (
    comd_id INTEGER PRIMARY KEY,
   comd_name varchar(50),
   description varchar(50),
   quantity_comd INTEGER);

CREATE TABLE Comp_Supp (
   supp_id INTEGER PRIMARY KEY,
    comd_id INTEGER PRIMARY KEY,
	order_date date,
   quantity INTEGER,
   PRIMARY KEY CLUSTERED 
(
	supp_id ASC,
	comd_id ASC,
);
ALTER TABLE Comp_Supp  WITH CHECK ADD FOREIGN KEY(supp_id)
REFERENCES Suppiler.Suppiler (supp_id)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE Comp_Supp   WITH CHECK ADD FOREIGN KEY(comd_id)
REFERENCES Component (comd_id)
ON UPDATE CASCADE
ON DELETE CASCADE
GO

CREATE TABLE Suppiler (
    supp_id INTEGER PRIMARY KEY,
   supp_name varchar(50),
    supp_location varchar(50),
	supp_country varchar(50),
   is_active bit);