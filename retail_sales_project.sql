
-- RETAIL SALES ANALYSIS PROJECT
-- Database: retail_sales_project
-- Total Records: 300
-- Tools: MySQL Workbench
-- =========================================

-- 1. DATABASE SELECTION
USE retail_sales_project;

-- 2. DATA EXPLORATION
SHOW TABLES;

-- 3. PRODUCT-WISE REVENUE ANALYSIS
SELECT
    product_name,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_revenue DESC;

-- 4. CITY-WISE REVENUE ANALYSIS
SELECT
    city,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- 5. CATEGORY-WISE REVENUE ANALYSIS
SELECT category,
       SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;

-- 6. FILTERING CATEGORIES USING HAVING
SELECT category,
       SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY category
HAVING SUM(quantity * price) > 20000
ORDER BY total_revenue DESC;

-- 7. FILTERING SALES USING WHERE AND AND/OR
SELECT *
FROM sales
WHERE category = 'Electronics'
  AND (city = 'Salem' OR city = 'Coimbatore');
  
-- 8. PRODUCTS TABLE CREATION AND DATA INSERTION
CREATE TABLE IF NOT EXISTS products (
    product_name VARCHAR(100) PRIMARY KEY,
    category VARCHAR(50)
);
SHOW TABLES;
INSERT INTO products (product_name, category)
VALUES
('Laptop', 'Electronics'),
('Mouse', 'Accessories'),
('Keyboard', 'Accessories'),
('Phone', 'Electronics'),
('Headphones', 'Accessories'),
('Monitor', 'Electronics')
ON DUPLICATE KEY UPDATE
    category = VALUES(category);
SELECT * FROM products;

-- 9. JOIN ANALYSIS
SELECT
    sales.sale_id,
    sales.product_name,
    products.category
FROM sales
INNER JOIN products
ON sales.product_name = products.product_name;

SELECT
    sales.sale_id,
    sales.product_name,
    products.category
FROM sales
LEFT JOIN products
ON sales.product_name = products.product_name;

    SELECT
    sales.sale_id,
    COALESCE(sales.product_name, products.product_name) AS product_name,
    COALESCE(products.category, sales.category) AS category
FROM sales
LEFT JOIN products
    ON sales.product_name = products.product_name

UNION

SELECT
    sales.sale_id,
    COALESCE(sales.product_name, products.product_name) AS product_name,
    COALESCE(products.category, sales.category) AS category
FROM sales
RIGHT JOIN products
    ON sales.product_name = products.product_name;

-- 10. FINDING UNMATCHED RECORDS
SELECT
    sales.sale_id,
    sales.product_name
FROM sales
LEFT JOIN products
    ON sales.product_name = products.product_name
WHERE products.product_name IS NULL;

-- 11. DATE FUNCTIONS
SELECT
    sale_date,
    YEAR(sale_date) AS sale_year
FROM sales;

SELECT
	sale_date,
    MONTH(sale_date) AS sale_month
FROM sales;

SELECT
	sale_date,
    DAY(sale_date) AS sale_day
    FROM SALES;
    
 SELECT CURDATE();  
 
 SELECT
    sale_id,
    sale_date,
    DATEDIFF(CURDATE(), sale_date) AS days_since_sale
FROM sales;

SELECT
    sale_id,
    sale_date,
    DATE_ADD(sale_date, INTERVAL 7 DAY) AS date_after_7_days
FROM sales;

SELECT
    sale_id,
    sale_date,
    DATE_SUB(sale_date, INTERVAL 7 DAY) AS previous_date
FROM sales;

SELECT
    sale_date,
    LAST_DAY(sale_date) AS month_end_date
FROM sales;

-- 12. MONTHLY REVENUE ANALYSIS
SELECT
    sale_date,
    DATE_FORMAT(sale_date, '%M %Y') AS sale_month
FROM sales;
    
SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS sales_month,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sales_month;  

-- 13. SUBQUERY ANALYSIS
SELECT AVG(quantity * price) AS average_sale_value
FROM sales;  

SELECT
    sale_id,
    product_name,
    quantity * price AS sale_amount
FROM sales
WHERE quantity * price > (
    SELECT AVG(quantity * price)
    FROM sales
);

-- 14. SUBQUERIES USING IN AND NOT IN
SELECT *
FROM sales
WHERE product_name IN (
    SELECT product_name
    FROM products
    WHERE category = 'Electronics'
);

SELECT *
FROM sales
WHERE product_name NOT IN (
    SELECT product_name
    FROM products
    WHERE category = 'Electronics'
);

-- 15. ADVANCED SUBQUERY ANALYSIS
SELECT
    sale_id,
    product_name,
    quantity * price AS sale_amount
FROM sales
WHERE quantity * price < (
    SELECT AVG(quantity * price)
    FROM sales
);

SELECT
    sale_id,
    product_name,
    quantity * price AS sale_amount
FROM sales
WHERE quantity * price = (
    SELECT MAX(quantity * price)
    FROM sales
);

SELECT *
FROM (
    SELECT
        product_name,
        SUM(quantity * price) AS total_revenue
    FROM sales
    GROUP BY product_name
) AS product_sales;

SELECT AVG(total_revenue) AS average_product_revenue
FROM (
    SELECT
        product_name,
        SUM(quantity * price) AS total_revenue
    FROM sales
    GROUP BY product_name
) AS product_sales;

-- 16. DATABASE AND DATA QUALITY CHECKS
SHOW TABLES;
DESCRIBE sales;
DESCRIBE products;
SELECT *
FROM sales
LIMIT 10;
SELECT *
FROM products;
SELECT COUNT(*) AS total_sales
FROM sales;
SELECT COUNT(*) AS total_products
FROM products;

SELECT
    COUNT(*) AS total_rows,
    COUNT(sale_date) AS dates_available,
    COUNT(product_name) AS products_available,
    COUNT(quantity) AS quantities_available,
    COUNT(price) AS prices_available,
    COUNT(city) AS cities_available,
    COUNT(category) AS categories_available
FROM sales;

SELECT
    s.product_name,
    s.category AS sales_category,
    p.category AS products_category
FROM sales s
JOIN products p
    ON s.product_name = p.product_name
WHERE s.category IS NULL
   OR p.category IS NULL
   OR s.category <> p.category;
SELECT
    sale_id,
    COUNT(*) AS occurrence
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1;

-- 17. MINIMUM AND MAXIMUM ANALYSIS
SELECT
    MIN(sale_date) AS first_sale,
    MAX(sale_date) AS last_sale
FROM sales;

SELECT MAX(sale_id) AS highest_sale_id
FROM sales;

-- 18. DATASET PREPARATION
-- 300 sales records have already been loaded into the sales table.
-- Data was prepared separately before running the analysis.  

-- 19. VERIFYING FINAL DATASET
SELECT COUNT(*) AS total_sales
FROM sales;

SELECT *
FROM sales
LIMIT 10;

SELECT
    MIN(sale_date) AS first_sale,
    MAX(sale_date) AS last_sale
FROM sales;

SELECT
    category,
    COUNT(*) AS total_sales
FROM sales
GROUP BY category;

-- 20. SALES PERFORMANCE ANALYSIS
SELECT
    category,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY category;
SELECT
    product_name,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY product_name
ORDER BY total_revenue DESC;

SELECT
    city,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS sales_month,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
ORDER BY sales_month;

SELECT
    product_name,
    SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY product_name
ORDER BY total_quantity_sold DESC;

SELECT
    AVG(quantity * price) AS average_order_value
FROM sales;

SELECT
    city,
    COUNT(*) AS total_orders
FROM sales
GROUP BY city
ORDER BY total_orders DESC;

SELECT
    MAX(quantity * price) AS highest_sale,
    MIN(quantity * price) AS lowest_sale
FROM sales;

SELECT
    SUM(quantity * price) AS overall_revenue
FROM sales;

SELECT
    category,
    SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY category
ORDER BY total_quantity_sold DESC;

SELECT
    COUNT(DISTINCT city) AS unique_cities,
    COUNT(DISTINCT product_name) AS unique_products
FROM sales;

-- 21. JOIN ANALYSIS
SELECT
    s.sale_id,
    s.product_name,
    s.quantity,
    s.price,
    p.category
FROM sales s
INNER JOIN products p
    ON s.product_name = p.product_name
LIMIT 10;

SELECT
    p.category,
    SUM(s.quantity * s.price) AS total_revenue
FROM sales s
INNER JOIN products p
    ON s.product_name = p.product_name
GROUP BY p.category
ORDER BY total_revenue DESC;

SELECT
    s.product_name,
    s.sale_id,
    p.category
FROM sales s
LEFT JOIN products p
    ON s.product_name = p.product_name
LIMIT 10;

SELECT
    s.product_name,
    s.sale_id
FROM sales s
LEFT JOIN products p
    ON s.product_name = p.product_name
WHERE p.product_name IS NULL;

SELECT
    s.city,
    p.category,
    SUM(s.quantity * s.price) AS total_revenue
FROM sales s
INNER JOIN products p
    ON s.product_name = p.product_name
GROUP BY
    s.city,
    p.category
ORDER BY
    s.city,
    total_revenue DESC;
    
-- 22. ADVANCED SALES ANALYSIS
    SELECT
    product_name,
    SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY product_name
HAVING SUM(quantity * price) > 1000000
ORDER BY total_revenue DESC;

SELECT
    sale_id,
    product_name,
    quantity * price AS revenue,
    CASE
        WHEN quantity * price >= 50000 THEN 'High Value'
        ELSE 'Low Value'
    END AS sale_category
FROM sales
LIMIT 10;

SELECT
    CASE
        WHEN quantity * price >= 50000 THEN 'High Value'
        ELSE 'Low Value'
    END AS sale_category,
    COUNT(*) AS total_sales
FROM sales
GROUP BY sale_category;

-- 23. DATA QUALITY VALIDATION
SELECT *
FROM sales
WHERE quantity <= 0
   OR quantity IS NULL
   OR price <= 0
   OR price IS NULL
   OR sale_date IS NULL
   OR product_name IS NULL
   OR city IS NULL
   OR category IS NULL;
 
