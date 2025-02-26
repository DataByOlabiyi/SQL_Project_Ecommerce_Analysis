-- Customer distribution by state
SELECT customer_state, COUNT(*) AS customer_count
FROM Customers
GROUP BY customer_state
ORDER BY customer_count DESC;

-- Top 10 cities with the most customers
SELECT customer_city, COUNT(*) AS customer_count
FROM Customers
GROUP BY customer_city
ORDER BY customer_count DESC
LIMIT 10;