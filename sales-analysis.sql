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


