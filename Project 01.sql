SELECT transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, total_sale
	FROM retail_sales;

SELECT * FROM retail_sales;

--Data Cleaning

-- To count rows 
SELECT 
	COUNT(*)
FROM retail_sales

SELECT * FROM retail_sales
WHERE 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;


-- 
DELETE FROM retail_sales
WHERE 
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantity IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;


-- Data Exploration

-- How many sales we have
SELECT COUNT (*) as total_sale FROM retail_sales

--How many customers we have
SELECT COUNT ( DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business Key Problem & Answers

--Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a 	SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE 
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') ='2022-11'
	AND
	quantity >= 4

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category

SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(total_sale) as total_orders
	
FROM retail_sales
GROUP BY 1

-- Q4. Write a SQL query to find the average age of customer who purchased items from the 'Beauty' category.

SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- Q6. Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category

SELECT 
	category,
	gender,
	COUNT(*) AS total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 1

-- Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT 
		year,
		month,
		avg_sale
FROM
(
SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) AS t1
WHERE rank = 1


-- Q8. Write a SQL query to find the top 5 customer based on the highest total sales.

SELECT 
	customer_id,
	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS cnt_unique_cust
FROM retail_sales
GROUP BY category

-- Q9. Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12& 17, Evening > 17)

WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders 
FROM hourly_sale
GROUP BY shift


-- End of Project


