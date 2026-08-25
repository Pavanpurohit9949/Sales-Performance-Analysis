select * from orders

-- 1. Monthly sales & profit trend

select order_month,sum(sales) as total_sales,
				   sum(profit) as total_profit
from orders
group by order_month
order by order_month

-- 2. Top 10 sub-categories by profit margin

select top 10 sub_category,
	   sum(sales) as total_sales,
	   sum(profit) as total_profit,
	   round(sum(profit)/sum(sales)*100,2) as profit_margin_pct
from orders
group by sub_category
order by profit_margin_pct desc

-- 3. Which sub-categories LOSE money?

select sub_category,sum(profit) as total_profit
from orders
group by sub_category
having sum(profit)<0
order by total_profit

-- 4. Does discount kill profit? Bucket discount and compare

select 
	case
		when discount=0 then '0%'
		when discount<= 0.2 then '1-20%'
		when discount<=0.4 then '21-40%'
		else '40%+'
	end as discount_band,
	sum(sales) as total_sales,
	sum(profit) as total_profit,
	count(*) as num_orders
from orders
group by case
		when discount=0 then '0%'
		when discount<= 0.2 then '1-20%'
		when discount<=0.4 then '21-40%'
		else '40%+'
	end
order by discount_band

-- 5. Top 10 customers by lifetime sales

select top 10 customer_name,
			  sum(sales) as lifetime_sales,
			  sum(profit) as lifetime_profit
from orders
group by customer_name
order by lifetime_sales desc

-- 6. Year-over-year growth by region

select region,order_year,sum(sales) as sales
from orders
group by region,order_year
order by region,order_year

-- 7. RFM-style recency: customers who haven't ordered in the last 12 months

select customer_name,max(order_date) as last_order_date,
	   datediff(day,max(order_date),'2017-01-01') as days_since_last_order
from orders
group by customer_name
having datediff(day,max(order_date),'2017-01-01')>365
order by days_since_last_order

-- 8. Shipping performance by mode

select ship_mode,avg(shipping_days) as avg_shipping_days
from orders
group by ship_mode