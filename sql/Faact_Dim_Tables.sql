select * from orders

-- 1. Dim_Customer

select distinct
	customer_id,
	customer_name,
	segment
into Dim_Customer
from orders

-- 2. Dim_Product

SELECT 
    product_id,
    MAX(product_name) AS product_name,
    MAX(category) AS category,
    MAX(sub_category) AS sub_category
INTO Dim_Product
FROM orders
GROUP BY product_id


-- 3. Dim_Geography

select distinct
	postal_code,
	city,
	state,
	region
into Dim_Geography
from orders

ALTER TABLE Dim_Geography ADD geo_id INT IDENTITY(1,1) PRIMARY KEY

-- 4. Dim_Date

-- easy to create in power bi

-- 5. Fact_orders

SELECT
    o.row_id,
    o.order_id,
    o.order_date,
    o.ship_date,
    o.ship_mode,
    o.customer_id,
    o.product_id,
    g.geo_id,
    o.sales,
    o.quantity,
    o.discount,
    o.profit
INTO Fact_Orders
FROM orders o
JOIN Dim_Geography g
    ON o.postal_code = g.postal_code
    AND o.city = g.city
    AND o.state = g.state
    AND o.region = g.region

select * from Fact_Orders
