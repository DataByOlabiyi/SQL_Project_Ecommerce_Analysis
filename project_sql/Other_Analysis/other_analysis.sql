-- High-value customers (top 10 by spending)
WITH CustomerSpending AS (
    SELECT 
        c.customer_unique_id, 
        SUM(oi.price) AS total_spent,
        CUME_DIST() OVER (ORDER BY SUM(oi.price) DESC) AS spending_percentile
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)
SELECT customer_unique_id, total_spent
FROM CustomerSpending
ORDER BY total_spent DESC
LIMIT 10; 

-- Repeat customers (customers with more than 1 order).
SELECT 
    customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY customer_unique_id
HAVING order_count > 1
ORDER BY order_count DESC;

-- Top 10 product categories by revenue
SELECT 
    p.product_category_name,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;
















-- Monthly sales trends
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month, COUNT(*) AS order_count
FROM Orders o
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;






























-- Calculate month-over-month sales growth to identify trends.
WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS total_revenue
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
)
SELECT 
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
        ((total_revenue - LAG(total_revenue) OVER (ORDER BY month)) / LAG(total_revenue) OVER (ORDER BY month) * 100, 2
    ) AS revenue_growth_percentage
FROM MonthlySales;

