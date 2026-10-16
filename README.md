# 🏬 Superstore Sales & Profitability Analysis Using MySQL

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Database](https://img.shields.io/badge/Database-MySQL%208.0+-blue.svg)](https://www.mysql.com/)
[![SQL Queries](https://img.shields.io/badge/SQL-25%20Analytical%20Queries-orange.svg)](#-sql-analysis--business-questions)
[![Domain](https://img.shields.io/badge/Domain-Retail%20%26%20E--Commerce-green.svg)](#-project-overview)

An end-to-end relational database analytics project evaluating the performance, profitability, customer behavior, and logistics operations of a retail Superstore. Powered by **MySQL 8.0+**, this repository contains database schema definitions (`DDL`) and 25 business-focused SQL queries (`DQL`) ranging from core financial KPIs to multi-level window functions and subqueries.

---

## 📌 Project Overview

Understanding the levers of revenue, operating margin, customer lifetime value, and logistics efficiency is vital for modern retail operations.

This repository features:
- **`Sample - Superstore-selected-columns.csv`**: Transaction-level retail records covering orders, shipping dates, customer segments, regional demographics, product categories, sales, discounts, and profits.
- **`superstore_data_analyst.sql`**: Full MySQL script setting up the database, building the structured schema, and providing 25 categorized queries for deep business insights.

---

## 📊 Database Schema & Data Architecture

All analytical operations run against the **`SuperstoreDB`** database and the central **`Orders`** table:

```sql
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
```

### Data Dictionary

| Field | Type | Description |
| :--- | :--- | :--- |
| `Row ID` | `INT` | Unique identifier for each transaction line item (Primary Key) |
| `Order ID` | `VARCHAR(30)` | Identifier for the customer order |
| `Order Date` | `DATE` | Date when the order was placed |
| `Ship Date` | `DATE` | Date when the order was dispatched |
| `Ship Mode` | `VARCHAR(50)` | Shipping class (Standard Class, Second Class, First Class, Same Day) |
| `Customer ID` | `VARCHAR(30)` | Unique customer reference identifier |
| `Customer Name` | `VARCHAR(100)` | Full name of the customer |
| `Segment` | `VARCHAR(100)` | Customer market segment (Consumer, Corporate, Home Office) |
| `Country` | `VARCHAR(100)` | Country where the transaction occurred |
| `City` / `State` | `VARCHAR(100)` | Geographic city and state of the customer |
| `Postal Code` | `VARCHAR(20)` | Postal / ZIP code |
| `Region` | `VARCHAR(50)` | Sales territory (East, West, Central, South) |
| `Product ID` | `VARCHAR(30)` | Unique product stock keeping unit (SKU) |
| `Category` | `VARCHAR(100)` | High-level product category (Furniture, Office Supplies, Technology) |
| `Sub-Category` | `VARCHAR(100)` | Detailed sub-classification of the item |
| `Product Name` | `VARCHAR(255)` | Full descriptive title of the product |
| `Sales` | `DECIMAL(12,2)` | Gross transaction value in USD |
| `Quantity` | `INT` | Number of units purchased |
| `Discount` | `DECIMAL(5,2)` | Discount percentage applied (0.00 to 1.00) |
| `Profit` | `DECIMAL(12,2)` | Net profit or loss realized on the transaction |

---

## 🔍 SQL Analysis & Business Questions

The 25 SQL queries in [`superstore_data_analyst.sql`](superstore_data_analyst.sql) are structured into 6 strategic analytical domains:

### 1. Executive Business Metrics & KPIs
* **Q1. Full Transaction Inspection:** Query all fields to verify schema and data formatting.
* **Q2. Total Record Count:** Quantify total order line items.
* **Q3. Order Volume:** Compute total unique transactions (`COUNT(DISTINCT \`Order ID\`)`).
* **Q4. Customer Base:** Compute total unique customer headcount (`COUNT(DISTINCT \`Customer ID\`)`).
* **Q5. Cumulative Sales:** Calculate gross platform revenue rounded to 2 decimal places.
* **Q6. Cumulative Profit:** Determine total net profit across all lines.
* **Q7. Total Units Sold:** Aggregate total volume of goods shipped.
* **Q8. Average Order Line Value:** Benchmark typical transaction basket size (`AVG(Sales)`).
* **Q25. Comprehensive Business Dashboard KPI:** Single consolidated query compiling total records, orders, customers, revenue, profit, quantity, and overall net profit margin (`ROUND(SUM(Profit) * 100 / SUM(Sales), 2)`).

### 2. Geographic & Regional Market Performance
* **Q9. Sales Distribution by Region:** Identify top-grossing geographical territories.
* **Q10. Regional Profitability:** Evaluate bottom-line contributions per region.
* **Q13. Top 10 Revenue Generating Cities:** Rank top performing metropolitan hubs.

### 3. Product & Merchandising Insights
* **Q11. Category Sales Breakdown:** Revenue contribution across Furniture, Office Supplies, and Technology.
* **Q12. Category Profit Margin:** Net profit realization across each major category.
* **Q20. Loss-Making Products:** Filter items generating negative net margins (`HAVING SUM(Profit) < 0`) to inform discount and product phase-out strategies.
* **Q22. High-Performance Outliers:** Identify products generating sales strictly above the company-wide average product sales benchmark via subquery.
* **Q24. Category Revenue Share (%):** Windowed revenue contribution percentage per category:
  ```sql
  ROUND(SUM(Sales) * 100 / NULLIF(SUM(SUM(Sales)) OVER (), 0), 2) AS sales_percentage
  ```

### 4. Customer Demographics & Segmentation
* **Q14. Top 10 High-Value Customers:** Identify highest grossing spenders by cumulative sales.
* **Q21. Segment Financial Health:** Compare gross sales, net profit, and profit margin % across `Consumer`, `Corporate`, and `Home Office` segments.
* **Q23. Customer Sales Ranking:** Apply window function `DENSE_RANK() OVER (ORDER BY SUM(Sales) DESC)` to rank the entire customer base.

### 5. Fulfillment & Logistics Efficiency
* **Q15. Shipping Mode Utilization:** Analyze order volumes and total sales per shipping class (`Standard Class`, `Second Class`, `First Class`, `Same Day`).
* **Q18. Average Transit Duration:** Measure average transit turnaround time using `DATEDIFF(\`Ship Date\`, \`Order Date\`)`.
* **Q19. Delayed Fulfillment Flag (> 4 Days):** Identify and inspect orders taking more than 4 days to ship to uncover supply chain bottlenecks.

### 6. Time-Series & Trend Analysis
* **Q16. Annual Revenue Trajectory:** Year-over-year revenue grouping using `YEAR(\`Order Date\`)`.
* **Q17. Monthly Revenue Run-Rate:** Month-by-month sales trajectory via `DATE_FORMAT(\`Order Date\`, '%Y-%m')`.

---

## 🚀 Getting Started

### Prerequisites
- [MySQL Server 8.0+](https://dev.mysql.com/downloads/mysql/)
- [MySQL Workbench](https://dev.mysql.com/downloads/workbench/) (or DBeaver / DataGrip / MySQL CLI)

### Setup & Execution Steps

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/technicalabinesh/Superstore-Dataset-Analysis-Using-MYSQL.git
   cd Superstore-Dataset-Analysis-Using-MYSQL
   ```

2. **Initialize Database and Schema:**
   - Launch MySQL Workbench and open [`superstore_data_analyst.sql`](superstore_data_analyst.sql).
   - Execute the `CREATE DATABASE SuperstoreDB;` and `CREATE TABLE Orders (...);` blocks.

3. **Import Data:**
   - In MySQL Workbench's **Navigator** pane, expand `SuperstoreDB` > right-click **Tables** > select **Table Data Import Wizard**.
   - Select [`Sample - Superstore-selected-columns.csv`](Sample%20-%20Superstore-selected-columns.csv).
   - Select the target table `Orders` and verify date formats match (`YYYY-MM-DD`).
   - Run the import wizard to populate the table.

4. **Run Analysis:**
   - Execute queries 1 through 25 to reproduce all business metrics and generate analytical reports!

---

## 💡 Key Analytical Findings

* **Category Disparities:** While `Technology` delivers higher margin yields, heavy discounts in certain sub-categories (like Tables and Binders) lead to significant profit erosion.
* **Logistics Dynamics:** Orders shipped via `Standard Class` represent the highest revenue volume, but orders exceeding the 4-day shipping threshold highlight areas for SLA improvements.
* **Customer Pareto Principle:** A small cohort of repeat high-value customers accounts for a disproportionate percentage of total sales.

---

## 🛠️ SQL Techniques Demonstrated

* **Data Aggregation & Grouping:** `SUM`, `AVG`, `COUNT(DISTINCT ...)`, `GROUP BY`, `HAVING`
* **Date & Time Functions:** `DATEDIFF`, `YEAR`, `DATE_FORMAT`
* **Window Functions:** `DENSE_RANK() OVER (...)`, `SUM(...) OVER ()`
* **Mathematical & Safe Division:** `ROUND()`, `NULLIF()` to avoid zero-division errors
* **Subqueries & Derived Tables:** Nested multi-level aggregations

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 👤 Author

* **Abinesh** - [GitHub Profile](https://github.com/technicalabinesh)
