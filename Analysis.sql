USE DATABASE SNOWFLAKE_SAMPLE_DATA;
USE SCHEMA TPCH_SF1;

SHOW TABLES;

-- overview of three tables
SELECT * FROM CUSTOMER LIMIT 10; -- one row per customer
SELECT * FROM ORDERS LIMIT 10; -- one row per order
SELECT * FROM LINEITEM LIMIT 10; -- one row per product line on an order

-- how big is each table
SELECT COUNT(*) AS customers FROM CUSTOMER;
SELECT COUNT(*) AS orders FROM ORDERS;
SELECT COUNT(*) AS lineitems FROM LINEITEM;


-- Q1 Who are the top 10 customers by total spend?
SELECT
    c.C_NAME AS customer_name,
    ROUND(SUM(o.O_TOTALPRICE),2) AS total_spend
FROM CUSTOMER c
JOIN ORDERS o ON o.O_CUSTKEY = c.C_CUSTKEY
GROUP BY customer_name
ORDER BY total_spend DESC
LIMIT 10;

-- Q2 — How does revenue trend by year?
SELECT
    YEAR(o.O_ORDERDATE) AS order_year,
    COUNT(*) AS num_orders,
    ROUND(SUM(o.O_TOTALPRICE),2) as revenue
FROM ORDERS o
GROUP BY order_year
ORDER BY order_year

-- Q3 — Which market segments drive the most revenue?**
SELECT
    c.C_MKTSEGMENT                 AS segment,
    COUNT(DISTINCT o.O_ORDERKEY)   AS orders,
    ROUND(SUM(o.O_TOTALPRICE), 2)  AS revenue,
    ROUND(AVG(o.O_TOTALPRICE), 2)  AS avg_order_value
FROM CUSTOMER c
JOIN ORDERS   o ON o.O_CUSTKEY = c.C_CUSTKEY
GROUP BY segment
ORDER BY revenue DESC;

-- Q4 — Revenue concentration (a Pareto check): what share of revenue comes from the top 5% of orders?
WITH RANKED AS(
    SELECT
        O_ORDERKEY,
        O_TOTALPRICE,
        NTILE(20) OVER (ORDER BY O_TOTALPRICE DESC) AS price_bucket
    FROM ORDERS
)
SELECT
    CASE WHEN price_bucket = 1 THEN 'Top 5% of orders' ELSE 'Other 95%' END AS tier,
    COUNT(*) AS num_orders,
        ROUND(SUM(O_TOTALPRICE), 2) AS revenue,
    ROUND(100 * SUM(O_TOTALPRICE)
          / SUM(SUM(O_TOTALPRICE)) OVER (), 1) AS pct_of_total_revenue
FROM RANKED
GROUP BY tier
ORDER BY revenue DESC
