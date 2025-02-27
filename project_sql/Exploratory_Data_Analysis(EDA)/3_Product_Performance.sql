-- Most popular product categories
SELECT p.product_category_name, 
COUNT(*) AS order_count
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY order_count DESC;


-- Average price per product category
SELECT p.product_category_name, AVG(oi.price) AS avg_price
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_price DESC;