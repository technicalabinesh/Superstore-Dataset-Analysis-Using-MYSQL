-- Sample Superstore Data Analyst Project
-- MySQL 8.0+
-- Save this script as superstore_data_analyst.sql and run it in MySQL Workbench.
--
-- IMPORTANT:
-- This script creates the table and analysis queries. Import your CSV into the
-- Orders table after creating it. The CSV must contain matching columns.
-- If your CSV only has the first 10 columns, remove the extra columns below
-- or use a table matching your actual CSV headers.

CREATE DATABASE IF NOT EXISTS SuperstoreDB;
USE SuperstoreDB;

CREATE TABLE IF NOT EXISTS Orders (
    `Row ID` INT PRIMARY KEY,
    `Order ID` VARCHAR(30),
    `Order Date` DATE,
    `Ship Date` DATE,
    `Ship Mode` VARCHAR(50),
    `Customer ID` VARCHAR(30),
    `Customer Name` VARCHAR(100),
    Segment VARCHAR(100),
    Country VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    `Postal Code` VARCHAR(20),
    Region VARCHAR(50),
    `Product ID` VARCHAR(30),
    Category VARCHAR(100),
    `Sub-Category` VARCHAR(100),
    `Product Name` VARCHAR(255),
    Sales DECIMAL(12,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(12,2)
);

-- Import your CSV using MySQL Workbench:
-- Right-click SuperstoreDB > Tables > Table Data Import Wizard > select CSV.
-- Ensure the CSV headers and data types match the table above.

-- 1. View all records
SELECT * FROM Orders;

-- 2. Total records
SELECT COUNT(*) AS total_records
FROM Orders;

-- 3. Total unique orders
SELECT COUNT(DISTINCT `Order ID`) AS total_orders
FROM Orders;

-- 4. Total unique customers
SELECT COUNT(DISTINCT `Customer ID`) AS total_customers
FROM Orders;

-- 5. Total sales
SELECT ROUND(SUM(Sales), 2) AS total_sales
FROM Orders;

-- 6. Total profit
SELECT ROUND(SUM(Profit), 2) AS total_profit
FROM Orders;

-- 7. Total quantity sold
SELECT SUM(Quantity) AS total_quantity
FROM Orders;

-- 8. Average order-line sales
SELECT ROUND(AVG(Sales), 2) AS average_sales
FROM Orders;

-- 9. Sales by region
SELECT Region, ROUND(SUM(Sales), 2) AS total_sales
FROM Orders
GROUP BY Region
ORDER BY total_sales DESC;

-- 10. Profit by region
SELECT Region, ROUND(SUM(Profit), 2) AS total_profit
FROM Orders
GROUP BY Region
ORDER BY total_profit DESC;

-- 11. Sales by category
SELECT Category, ROUND(SUM(Sales), 2) AS total_sales
FROM Orders
GROUP BY Category
ORDER BY total_sales DESC;

-- 12. Profit by category
SELECT Category, ROUND(SUM(Profit), 2) AS total_profit
FROM Orders
GROUP BY Category
ORDER BY total_profit DESC;

-- 13. Top 10 cities by sales
SELECT City, ROUND(SUM(Sales), 2) AS total_sales
FROM Orders
GROUP BY City
ORDER BY total_sales DESC
LIMIT 10;

-- 14. Top 10 customers by sales
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM Orders
GROUP BY `Customer ID`, `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;

-- 15. Sales by shipping mode
SELECT
    `Ship Mode`,
    ROUND(SUM(Sales), 2) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM Orders
GROUP BY `Ship Mode`
ORDER BY total_sales DESC;

-- 16. Yearly sales
SELECT
    YEAR(`Order Date`) AS order_year,
    ROUND(SUM(Sales), 2) AS total_sales
FROM Orders
GROUP BY YEAR(`Order Date`)
ORDER BY order_year;

-- 17. Monthly sales
SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS order_month,
    ROUND(SUM(Sales), 2) AS total_sales
FROM Orders
GROUP BY DATE_FORMAT(`Order Date`, '%Y-%m')
ORDER BY order_month;

-- 18. Average shipping days
SELECT
    ROUND(AVG(DATEDIFF(`Ship Date`, `Order Date`)), 2) AS average_shipping_days
FROM Orders
WHERE `Ship Date` IS NOT NULL
  AND `Order Date` IS NOT NULL;

-- 19. Orders shipped after more than 4 days
SELECT
    `Order ID`,
    `Order Date`,
    `Ship Date`,
    DATEDIFF(`Ship Date`, `Order Date`) AS shipping_days
FROM Orders
WHERE `Order Date` IS NOT NULL
  AND `Ship Date` IS NOT NULL
  AND DATEDIFF(`Ship Date`, `Order Date`) > 4
ORDER BY shipping_days DESC;

-- 20. Products generating losses
SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM Orders
GROUP BY `Product Name`
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;

-- 21. Sales and profit by customer segment
SELECT
    Segment,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) / NULLIF(SUM(Sales), 0) * 100, 2) AS profit_margin_percentage
FROM Orders
GROUP BY Segment
ORDER BY total_sales DESC;

-- 22. Products with total sales above the average total sales per product
SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM Orders
GROUP BY `Product Name`
HAVING SUM(Sales) > (
    SELECT AVG(product_sales)
    FROM (
        SELECT SUM(Sales) AS product_sales
        FROM Orders
        GROUP BY `Product Name`
    ) AS product_totals
)
ORDER BY total_sales DESC;

-- 23. Rank customers by total sales (MySQL 8.0+)
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(Sales) DESC) AS sales_rank
FROM Orders
GROUP BY `Customer ID`, `Customer Name`;

-- 24. Sales contribution by category
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Sales) * 100 / NULLIF(SUM(SUM(Sales)) OVER (), 0), 2) AS sales_percentage
FROM Orders
GROUP BY Category
ORDER BY total_sales DESC;

-- 25. Overall business KPIs
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    COUNT(DISTINCT `Customer ID`) AS total_customers,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Profit) * 100 / NULLIF(SUM(Sales), 0), 2) AS profit_margin_percentage
FROM Orders;
