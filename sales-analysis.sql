--Create Table

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
 (
  transactions_id int PRIMARY KEY,
  sale_date date,
  sale_time time,
  customer_id int,
  gender varchar(15),
  age int,
  category varchar(15),
  quantiy int,
  price_per_unit float,
  cogs float,
  total_sale float
);
SELECT * FROM retail_sales
LIMIT 10;


SELECT COUNT(*) FROM retail_sales;


--DATA CLEANING

SELECT * FROM retail_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

DELETE FROM retail_sales
WHERE
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;