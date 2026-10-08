# Retail Sales Analysis with SQL

This project analyzes retail sales data using SQL to identify sales trends, customer behavior, category performance, and operational patterns. The analysis is implemented in the SQL script located in this folder and is supported by a CSV dataset containing transactional retail records.

## 1. Project Overview

The goal of this project is to use sales transaction data to answer business questions such as:

- Which sales categories generate the most revenue?
- Which customers are the highest-value buyers?
- What are the busiest periods in the sales calendar?
- How do sales vary by gender, time of day, and month?
- How can data cleaning and segmentation improve reporting quality?

The analysis helps convert raw sales data into actionable business insights for inventory planning, marketing decisions, and customer targeting.

## 2. Dataset Description

The project uses the file:

- `SQL - Retail Sales Analysis_utf .csv`

This dataset contains 2,000 retail transactions across multiple product categories and customer segments. Each record represents a single sales transaction and includes information such as transaction ID, date, time, customer ID, demographic attributes, sales quantity, pricing, and total sales.

### Dataset fields

- `transactions_id`
- `sale_date`
- `sale_time`
- `customer_id`
- `gender`
- `age`
- `category`
- `quantity`
- `price_per_unit`
- `cogs`
- `total_sale`

### Dataset summary

- Total transactions: 2,000
- Total customers: 155
- Categories: Beauty, Clothing, Electronics
- Gender distribution: 980 male, 1,020 female
- Total net sales: 911,720
- Average sale value: 456.54

## 3. Objective of the Project

The main objective is to perform a structured SQL-based data analysis to:

1. Clean and validate retail sales records.
2. Explore sales patterns by category, period, and customer segment.
3. Answer common business questions with SQL queries.
4. Summarize findings in a clear reporting format.
5. Provide decision-support information for sales and marketing teams.

## 4. Project Structure

This folder contains:

- `sales-analysis.sql` – SQL script with table creation, data cleaning, and business queries.
- `SQL - Retail Sales Analysis_utf .csv` – source retail sales dataset.
- `README.md` – project documentation.

## 5. SQL Analysis Workflow

The SQL analysis follows a step-by-step process:

### Step 1: Create the retail sales table

A raw sales table is created with the main transactional fields needed for reporting.

```sql
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
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
```

This stage establishes the database structure to receive and analyze the sales data.

### Step 2: Review the dataset and check for missing values

Before analysis, the data is checked for null or incomplete records. This helps ensure reliable calculations.

```sql
SELECT * FROM retail_sales
WHERE
transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
```

Records with critical missing values in quantity, price, COGS, or total sales are removed to maintain data quality.

```sql
DELETE FROM retail_sales
WHERE
quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
```

### Step 3: Basic exploratory analysis

The project begins with high-level summary checks to understand the size and scale of the dataset.

```sql
SELECT COUNT(*) AS total_sales
FROM retail_sales;
```

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customer
FROM retail_sales;
```

```sql
SELECT DISTINCT category
FROM retail_sales;
```

These queries provide quick insight into how many records and unique customers exist and which categories are represented.

---

## 6. Key Business Questions and SQL Queries

Below are the main business questions addressed in this project, with example SQL snippets from the analysis.

### Question 1: Show all sales on a specific date

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

Purpose: This helps review the exact transactions made on a single day for audit or promotions analysis.

### Question 2: Find beauty sales with quantity greater than or equal to 3 in November 2022

```sql
SELECT *
FROM retail_sales
WHERE category = 'Beauty'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantiy >= 3;
```

Purpose: This identifies high-volume beauty sales during a defined time period and supports campaign analysis.

### Question 3: Calculate total sales per category

```sql
SELECT
  category,
  SUM(total_sale) AS net_sale,
  COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;
```

Purpose: Shows which product categories generate the most revenue and volume.

### Question 4: Find the average age of customers in the Electronics category

```sql
SELECT 
  ROUND(AVG(age), 1) AS Average_Age
FROM retail_sales
WHERE category = 'Electronics';
```

Purpose: Helps understand the age profile of buyers in a category.

### Question 5: Find high-value transactions above 1500

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1500;
```

Purpose: This identifies premium sales transactions for further review and customer analysis.

### Question 6: Compare transactions by gender and category

```sql
SELECT
  category,
  gender,
  COUNT(*) AS total_sales
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1;
```

Purpose: Helps understand product demand across demographic groups and category preferences.

### Question 7: Determine the best-selling month for each year

```sql
SELECT * FROM
(
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (
      PARTITION BY EXTRACT(YEAR FROM sale_date)
      ORDER BY AVG(total_sale) DESC
    ) AS rank
  FROM retail_sales
  GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

Purpose: Identifies the strongest monthly sales period and helps prioritize seasonal campaigns.

### Question 8: Find the top 5 customers by total sales

```sql
SELECT 
  customer_id,
  SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

Purpose: Shows which customers produce the highest revenue, useful for loyalty and retention strategies.

### Question 9: Count unique customers per category

```sql
SELECT 
  category,
  COUNT(DISTINCT customer_id) AS unique_customer
FROM retail_sales
GROUP BY 1;
```

Purpose: Measures how many distinct shoppers buy from each category.

### Question 10: Group transactions into time-of-day shifts

```sql
WITH hourly_sale AS (
  SELECT *,
    CASE
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'MORNING'
      WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
      ELSE 'EVENING'
    END AS shift
  FROM retail_sales
)
SELECT
  shift,
  COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

Purpose: This allows operational review of when most sales occur across the day.

### Question 11: Fill null age values with the average age

```sql
UPDATE retail_sales
SET age = (
  SELECT ROUND(AVG(age))
  FROM retail_sales
)
WHERE age IS NULL;
```

Purpose: Ensures missing demographic information does not distort customer analysis.

### Question 12: Find customers older than 50

```sql
SELECT customer_id, age
FROM retail_sales
WHERE age > 50;
```

Purpose: Helps isolate senior customer segments for promotions or product-specific targeting.

### Question 13: Find minimum and maximum transaction amounts

```sql
SELECT 
  MIN(total_sale) AS minimum_transaction,
  MAX(total_sale) AS maximum_transaction
FROM retail_sales;
```

Purpose: Useful for understanding the range of transaction values in the business.

### Question 14: Calculate average sales by category

```sql
SELECT
  category,
  ROUND(AVG(total_sale)::numeric, 1) AS avg_sale
FROM retail_sales
GROUP BY 1;
```

Purpose: Measures category-level average order value and compares store performance.

### Question 15: Find customers with total units purchased above 20

```sql
SELECT customer_id,
  SUM(quantiy) AS total_unit
FROM retail_sales
GROUP BY 1
HAVING SUM(quantiy) >= 20
ORDER BY 2 DESC;
```

Purpose: Identifies high-volume buyers, which can be useful for loyalty and repeat-purchase campaigns.

---

## 7. Findings, Reports, and Outcomes

The SQL analysis reveals several important business insights:

- The dataset contains 2,000 transactions and 155 unique customers.
- Sales are spread across three categories: Beauty, Clothing, and Electronics.
- Total revenue across all transactions is 911,720.
- Average transaction value is 456.54.
- Category revenue distribution:
  - Electronics: 313,810
  - Clothing: 311,070
  - Beauty: 286,840
- The highest-yielding category is Electronics, followed closely by Clothing.
- The most active sales month is December 2022, with 157 transactions, followed by November 2022 and October 2022 with 146 transactions each.
- Customer and category segmentation can support targeted campaigns and inventory planning.

### Business interpretation

The dataset suggests that sales are generally stable across categories, but Electronics slightly leads in total revenue, while Clothing remains highly competitive. The year-end spike in December indicates strong seasonal demand, making it a good time to focus on promotions, cross-selling, and stock planning.

### Project outcome

This project demonstrates how SQL can turn sales data into a clear business story. It provides an example of professional retail analytics by combining:

- Data cleaning and validation
- Exploratory analysis
- Business segmentation
- Product and customer performance review
- Revenue and seasonal trend reporting

The final output is a reusable SQL workflow that can be adapted to larger retail datasets and expanded for dashboards, executive reporting, or forecasting.

## 8. Conclusion

The sales analysis project provides a practical example of using SQL for retail business intelligence. It highlights data quality checks, key performance metrics, and business questions that help understand customer behavior and sales performance.
I will also add new findings in the future.
This project can be extended with dashboard tools like Power BI, Tableau, or Excel for visual reporting and decision-making.
