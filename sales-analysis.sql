--Retail-Sales Analysis using SQL

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

-- DATA EXPLORATION

--How many sales do we have?

SELECT COUNT(*) as total_sales from retail_sales;

--How many unique customers we have?

SELECT COUNT(DISTINCT customer_id) as total_customer from retail_sales;

--How many categories we have?

SELECT DISTINCT category from retail_sales;

-- Business Key Problems and Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * FROM retail_sales
wHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 3 in the month of NOV-2022
SELECT *
FROM retail_sales 
retail_sales
WHERE category = 'Beauty'
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantiy >= 3

--Q.3 Write a SQL query to calculate the total sales for each category

SELECT
category,
sum(total_sale) as net_sale,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Electroics' category.

SELECT 
ROUND(AVG(age),1)AS Average_Age
FROM retail_sales
WHERE category='Electronics'

--Q.5 Write a SQL query to find all the transaction where total_sale is greater than 1500.

SELECT * from retail_sales
WHERE total_sale > 1500


--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT
category,
gender,
COUNT(*) as total_sales
FROM retail_sales
GROUP BY 1,2
ORDER BY 1

--Q.7 Write a SQL query to calculate the average sale for each month, find out the best selling month in each year
SELECT * FROM
(
SELECT 
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE rank = 1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
customer_id,
SUM(total_sale) as total_sales
from retail_sales
GROUP BY 1
ORDER BY 2 DESC limit 5
--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
category,
COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY 1

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning<=12, Afternoon Between 12 & 17, Evening > 17)

WITH hourly_sale
AS
(
SELECT *,
CASE
   WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
   WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
   ELSE 'EVENING'
  END as shift
FROM retail_sales
)
SELECT 
shift,
COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

--Q.11 Write a SQL query to populate the null age values

UPDATE retail_sales
SET age = (
    SELECT ROUND(AVG(age))
    FROM retail_sales
)
WHERE age IS NULL

--Q.12 Write a SQL query to Find all customers whose age is greater than 50.

Select customer_id,
age
FROM retail_sales
Where age > 50

--Q.13 Write a SQL Query to Find the maximum and minimum transaction amount. 

SELECT 
MIN(total_sale) as minimum_transaction,
MAX(total_sale) as maximum_transaction
FROM 
retail_sales

--Q.14 Write a SQL Query to Find the average total_sale for each category.
SELECT
category,
ROUND(AVG(total_sale)::numeric,1) as avg_sale
FROM retail_sales
GROUP BY 1

--Q.15 Write a SQL Query to Find customers who have purchased more than 20 total unit.
SELECT customer_id,
SUM(quantiy) as total_unit
FROM retail_sales
GROUP BY 1 
HAVING SUM(quantiy) >= 20
ORDER BY 2 DESC