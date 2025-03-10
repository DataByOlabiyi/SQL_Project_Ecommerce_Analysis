-- Check for null values in customers table base on customer_id
SELECT * 
FROM customers
WHERE customer_id IS NULL
LIMIT 1000;

-- Check for null values in customers table base on customer_state
SELECT * 
FROM customers 
WHERE customer_state IS NULL 
LIMIT 1000;

-- Check for null values in customers table base on customer_city
SELECT * 
FROM customers
WHERE customer_city IS NULL
LIMIT 1000;

-- Check for null values in order_items table
SELECT * 
FROM order_items
WHERE order_item_id IS NULL
LIMIT 1000;

-- Check for null values in orders table
SELECT *
FROM orders
WHERE order_id IS NULL
LIMIT 1000;

-- Check for null values in orders table
SELECT * 
FROM orders 
WHERE order_status IS NULL 
LIMIT 1000;

-- Check for null values in products table
SELECT * 
FROM products
WHERE product_id IS NULL
LIMIT 1000;

-- Check for null values in products table
SELECT * 
FROM products 
WHERE product_category_name IS NULL 
LIMIT 1000;

-- Check for duplicate values in customers table
SELECT customer_id, COUNT(*) 
FROM customers 
GROUP BY customer_id 
HAVING COUNT(*) > 1;

-- Check for duplicate values in order_items table
SELECT order_id, order_item_id, COUNT(*) 
FROM order_items 
GROUP BY order_id, order_item_id 
HAVING COUNT(*) > 1;

-- Check for duplicate values in orders table
SELECT order_id, COUNT(*) 
FROM orders 
GROUP BY order_id 
HAVING COUNT(*) > 1;

-- Check for duplicate values in products table
SELECT product_id, COUNT(product_id) 
FROM products 
GROUP BY product_id 
HAVING COUNT(*) > 1;

-- Count number of rows in products table
SELECT COUNT(product_id)
FROM products;

-- Sample 1000 rows from orders table
SELECT * FROM orders LIMIT 1000;

-- Standardize date formats in orders table
UPDATE Orders 
SET 
    order_purchase_timestamp = STR_TO_DATE(NULLIF(order_purchase_timestamp, ''), '%m/%d/%Y %H:%i'),
    order_approved_at = STR_TO_DATE(NULLIF(order_approved_at, ''), '%m/%d/%Y %H:%i'),
    order_delivered_carrier_date = STR_TO_DATE(NULLIF(order_delivered_carrier_date, ''), '%m/%d/%Y %H:%i'),
    order_delivered_customer_date = STR_TO_DATE(NULLIF(order_delivered_customer_date, ''), '%m/%d/%Y %H:%i'),
    order_estimated_delivery_date = STR_TO_DATE(NULLIF(order_estimated_delivery_date, ''), '%m/%d/%Y %H:%i');

