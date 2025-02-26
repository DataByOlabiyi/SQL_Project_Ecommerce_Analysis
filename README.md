# Introduction
This project analyzes sales data from a Brazilian e-commerce company using SQL. The dataset, provided by Olist, Instead of including all nine files, I narrowed it down to four: `customers`, `orders`, `order_items`, and `products`. This keeps the scope manageable but still allows for more in-depth analysis, with over 100,000 records. The goal was to clean, analyze, and derive insights from the data to understand customer behavior, sales trends, and product performance.

I created a MySQL database ecommerce_analysis and imported the selected datasets using MySQL Workbench's Import Wizard. After verifying the data was imported correctly, I connected MySQL Workbench with Visual Studio Code using SQLTools and SQLTools MySQL/MariaDB/TiDB extensions. This allows me to query the database directly from VS Code.

# Background
The dataset consists of four main tables:
- **Customers**: Contains customer information, including unique IDs, zip codes, cities, and states.
- **Orders**: Includes order details such as order status, purchase timestamp, and delivery dates.
- **Products**: Provides product details like category, weight, dimensions, and description length.
- **Order_Items**: Links orders to products and includes details like price and quantity.

The dataset contained approximately 120,000 records across the four tables, with some missing values and inconsistencies that required cleaning. This analysis aims to help the company understand customer behavior, identify popular products, and optimize sales strategies.

# Tools I Used
- **SQL:** The backbone of my analysis, allowing me to query the database.
- **MySQL Workbench**: For database management system.
- **Visual Studio Code**: For writing, data cleaning, querying, analysis and organizing SQL scripts and documentation.
- **Git & GitHub:** Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.


# The Analysis

## **Data Cleaning**
The dataset required cleaning to handle missing values, duplicates, and inconsistencies. Here are the steps I took:

SQL queries? Check them out here: [Data_Cleaning_sql folder](/project_sql/Data_Cleaning_sql/)

1. **Handling Missing Values**: No missing values were found in critical columns, so no replacements were needed.  
2. **Removing Duplicates**: No duplicate records were found, so no removals were necessary.
3. **Standardizing Data**: Date columns were converted to a consistent format, and text columns were standardized.

## **Exploratory Data Analysis (EDA)**
The exploratory analysis revealed several insights:

SQL queries? Check them out here: [Exploratory_Data_Analysis(EDA) folder](/project_sql/Exploratory_Data_Analysis_(EDA)/)

## 1. **Customer Distribution** 
SQL queries? Check them out here: [1_Customer_distribution file](/project_sql/Exploratory_Data_Analysis_(EDA)/1_Customer_distribution)

**Customer distribution by state**

Most customers are concentrated in `São Paulo` (SP) and `Rio de Janeiro` (RJ), the latter with the greatest number by far. The distribution shows that these states are key markets, likely due to higher population density and economic activity.

**SQL Query**:
```sql
    SELECT customer_state, 
    COUNT(*) AS customer_count
    FROM Customers
    GROUP BY customer_state
    ORDER BY customer_count DESC;
```
| Customer State | Customer Count |
|---------------|---------------|
| SP            | 41746         |
| RJ            | 12852         |
| MG            | 11635         |
| RS            | 5466          |
| PR            | 5045          |

**Top 10 cities with the most customers**

São Paulo has the largest number of customers (15,540), more than twice that of Rio de Janeiro (6,882). The pattern shows a high concentration of customers in large cities, with a sharp drop-off after the first two.

**SQL Query**:
```sql
    SELECT customer_city, 
    COUNT(*) AS customer_count
    FROM Customers
    GROUP BY customer_city
    ORDER BY customer_count DESC
    LIMIT 10;
```
| Customer City          | Customer Count |
|------------------------|---------------|
| sao paulo             | 15540         |
| rio de janeiro        | 6882          |
| belo horizonte        | 2773          |
| brasilia              | 2131          |
| curitiba              | 1521          |
| campinas              | 1444          |
| porto alegre          | 1379          |
| salvador              | 1245          |
| guarulhos             | 1189          |
| sao bernardo do campo | 938           |


### 2. **Order Patterns**
SQL queries? Check them out here: [2_Order_Patterns file](/project_sql/Exploratory_Data_Analysis(EDA)/2_Order_Patterns)

**Percentage of Delivered Orders**

97% of orders were successfully delivered, and only a negligible portion (1.1%) are in transit. Unavailable items and cancellations collectively represent approximately 1.2% of all orders. All other statuses, such as invoiced and processing, have a very small effect on total order flow.

**SQL Query**:
```sql
    SELECT 
        order_status, 
        COUNT(*) AS order_count, 
        (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()) AS status_percentage
    FROM orders
    GROUP BY order_status
    ORDER BY order_count DESC;
```

| order_status  | order_count | status_percentage |
|--------------|------------|------------------|
| delivered    | 96478      | 97.02034        |
| shipped      | 1107       | 1.11322         |
| canceled     | 625        | 0.62851         |
| unavailable  | 609        | 0.61242         |
| invoiced     | 314        | 0.31577         |
| processing   | 301        | 0.30269         |
| created      | 5          | 0.00503         |
| approved     | 2          | 0.00201         |


**Average Delivery Time by State**

Delivery times vary significantly between states, with `São Paulo` (SP) having the fastest average delivery (8 days, 16 hours, 49 min) and `Roraima` (RR) the slowest (29 days, 8 hours, 12 min). Variations reflect potential logistical issues in certain regions.

**SQL Query**:
```sql
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
```

| State | Average Delivery Time      |
|---------------|----------------------|
| São Paulo            | 8 days, 16 hours, 49 min  |
| Roraima            | 29 days, 8 hours, 12 min  |



### 3. **Product Performance**
SQL queries? Check them out here: [3_Product_Performance file](/project_sql/Exploratory_Data_Analysis(EDA)/3_Product_Performance)

**Most popular product categories.**

The top-selling category is `cama_mesa_banho` with 11,115 orders, followed by `beleza_saude` with 9,670. Home-related and personal care products dominate the sales, indicating strong consumer demand in these areas.

**SQL Query**:
```sql
    SELECT p.product_category_name, 
        COUNT(*) AS order_count
    FROM Order_Items oi
    JOIN Products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
    ORDER BY order_count DESC;
```


**Average Price per Product Category**

The average price of products varies significantly across categories. The most expensive categories are `computers_accessories` and `electronics`, while the least expensive are `office_furniture` and `home_comfort`.

**SQL Query**:
```sql
    SELECT p.product_category_name, AVG(oi.price) AS avg_price
    FROM Order_Items oi
    JOIN Products p ON oi.product_id = p.product_id
    GROUP BY p.product_category_name
    ORDER BY avg_price DESC;
```

## Other Analysis

**Deeper analyses included:**

SQL queries? Check them out here: [other_analysis file](/project_sql/Other_Analysis/other_analysis.sql)

**High-Value Customers (Top 10 by Spending)**

The 10 highest-spending customers have total spending ranging from 4,590 to 13,440. There is one customer who spends far more than the rest, with over 13,000 in total spending. Targeted marketing and loyalty programs can be assisted by recognizing these high-value customers.


**SQL Query**:
```sql
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
```
**Repeat Customers (More than 1 Order)**

The most loyal repeat customer has purchased 17 times, while several customers have made 4 to 9 purchases. This reflects a loyal customer base with repeat purchases. Their interests can be used to target loyalty programs and promotions.


**SQL Query**:
```sql
    SELECT 
        customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
    HAVING order_count > 1
    ORDER BY order_count DESC;
```

**Top 10 Product Categories by Revenue**

The top product category by revenue is "beleza_saude" with over 1.25 million in total revenue. "cama_mesa_banho" has the highest order count, indicating high demand. Other top categories include "relogios_presentes," "esporte_lazer," and "informatica_acessorios," suggesting strong interest in health, home, and tech-related products.

**SQL Query**:
```sql
SELECT 
    p.product_category_name,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;
```
| product_category_name  | total_revenue      | total_orders |
|------------------------|--------------------|--------------|
| beleza_saude          | 1258681.33         | 8836         |
| relogios_presentes    | 1205005.68         | 5624         |
| cama_mesa_banho       | 1036988.68         | 9417         |
| esporte_lazer         | 988048.97          | 7720         |

**Monthly Sales Trends**

The data shows a significant spike in the number of orders for the protein in late 2016, peaking in late 2017 and early 2018, then suddenly declining in late 2018. This is a sign of a period of peak demand or popularity that soon dissipated. The highest order number was in November 2017 at 7,544 orders.

**SQL Query**:
```sql
SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month, 
       COUNT(*) AS order_count
FROM Orders o
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY month;
```
![Monthly Sales Trends](assets/Monthly%20Sales%20Trends.png)


# What I Learned

## Technical Skills
- **Advanced SQL**: I mastered complex SQL queries, including window functions (`CUME_DIST`, `DATEDIFF`), joins, and aggregations. I also learned to handle large datasets efficiently.
- **Data Cleaning**: I gained experience in identifying and handling missing values, standardizing data formats, and ensuring data consistency.
- **Data Visualization**: I used SQL to generate insights and prepared visualizations to communicate findings effectively.

## Problem-Solving
- **Handling Real-World Data**: I tackled challenges like inconsistent data formats, missing values, and large datasets. For example, I standardized date formats and ensured data integrity across tables.

## Business Insights
- **Customer Behavior**: I identified high-value customers and repeat purchasers, which can help the company focus on customer retention and loyalty programs.
- **Product Performance**: I uncovered the most popular and profitable product categories, such as `beleza_saude` and `cama_mesa_banho`, providing insights into consumer preferences.
- **Sales Trends**: I analyzed monthly sales trends and identified seasonal peaks, such as the spike in November 2017, which can inform marketing and inventory strategies.
- **Delivery Performance**: I evaluated delivery times across states, identifying regions with delays and opportunities for logistical improvements.


# Conclusions (Insights and Recommendations)

## Key Insights
1. **Customer Distribution**: 
   - São Paulo (SP) and Rio de Janeiro (RJ) account for the majority of customers, with São Paulo alone representing over 40% of the customer base.
   - The top 10 cities, led by São Paulo and Rio de Janeiro, account for a significant portion of total customers, indicating high market concentration in urban areas.

2. **Order Patterns**:
   - 97% of orders are successfully delivered, with only 1.1% in transit and 1.2% canceled or unavailable.
   - Delivery times vary significantly by state, with São Paulo having the fastest average delivery time (8 days, 16 hours) and Roraima the slowest (29 days, 8 hours).

3. **Product Performance**:
   - The most popular product categories are `cama_mesa_banho` (bed, table, and bath) and `beleza_saude` (health and beauty), with over 11,000 and 9,600 orders, respectively.
   - The highest-revenue category is `beleza_saude`, generating over 1.25 million in revenue, followed by `relogios_presentes` (watches and gifts).

4. **Customer Behavior**:
   - High-value customers (top 10 by spending) contribute significantly to revenue, with the top spender exceeding 13,000 in total purchases.
   - Repeat customers, some with up to 17 orders, demonstrate strong loyalty and represent a key segment for retention strategies.

5. **Sales Trends**:
   - Sales peaked in November 2017, with 7,544 orders, indicating a seasonal trend that could be leveraged for future marketing campaigns.
   - The overall sales trend shows growth in late 2016 and early 2017, followed by a decline in late 2018, suggesting a need to investigate external factors affecting demand.

## Recommendations
1. **Target High-Demand Categories**:
   - Focus on promoting and stocking popular product categories like `cama_mesa_banho` and `beleza_saude` to maximize revenue.
   - Introduce new products or variations in these categories to meet consumer demand.

2. **Improve Delivery Efficiency**:
   - Investigate and address delays in states with slower delivery times, such as Roraima (RR) and Amazonas (AM).
   - Optimize logistics and distribution networks to reduce delivery times and improve customer satisfaction.

3. **Enhance Customer Experience**:
   - Implement loyalty programs and personalized recommendations for high-value and repeat customers to increase retention.
   - Offer incentives, such as discounts or free shipping, to encourage repeat purchases.

4. **Leverage Seasonal Trends**:
   - Plan marketing campaigns and inventory stocking around peak sales periods, such as November and December, to capitalize on increased demand.
   - Analyze the factors behind the 2017 sales spike and replicate successful strategies.

5. **Reduce Order Cancellations**:
   - Investigate the reasons for cancellations and unavailable orders (1.2% of total orders) and implement strategies to reduce them.
   - Improve product descriptions, stock availability, and customer support to minimize cancellations.

6. **Expand Market Reach**:
   - Explore opportunities to expand into underrepresented regions, such as the northern states, to diversify the customer base.
   - Tailor marketing strategies to target customers in these regions effectively.

7. **Monitor Sales Trends**:
   - Continuously analyze sales data to identify emerging trends and adjust strategies accordingly.
   - Investigate the decline in sales in late 2018 and address potential issues affecting demand.
