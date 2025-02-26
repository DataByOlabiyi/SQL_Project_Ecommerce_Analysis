SELECT * FROM orders LIMIT 1000;

-- Calculate the percentage of delivered orders
SELECT 
    order_status, 
    COUNT(*) AS order_count, 
    (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()) AS status_percentage
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Calculate average delivery time by state
SELECT 
    c.customer_state, 
    CONCAT(
        FLOOR(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp))), ' days, ', 
        FLOOR((AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) - 
               FLOOR(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)))) * 24), ' hours, ',
        ROUND((((AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) - 
               FLOOR(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)))) * 24) - 
               FLOOR((AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) - 
               FLOOR(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)))) * 24)) * 60), ' min'
    ) AS avg_delivery_time
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY avg_delivery_time DESC;


-- Distribution of order
SELECT order_status, 
COUNT(*) AS order_count
FROM Orders
GROUP BY order_status
ORDER BY order_count DESC;


-- Calculate total revenue for each seller
SELECT oi.seller_id, SUM(oi.price) AS total_revenue
FROM Order_Items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

