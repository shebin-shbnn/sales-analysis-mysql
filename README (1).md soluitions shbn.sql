## Requests from management

-- 1. Marketing wants to know which cities our orders come from and which payment methods customers use. Give me each as a separate list.

use shopeasy_db;
select*from orders;

select distinct city from orders;
select distinct payment_mode from orders;

-- 2. The catalogue team needs a clean product list showing the product name, category and price, with proper headings.

select distinct product_name as Product, category as Category ,unit_price as Price from orders;


-- 3. Finance is auditing the April to June 2026 quarter. Show me all delivered orders from Kochi or Chennai placed in that period.

select*from orders where order_status='Delivered' and city in ('Chennai','Kochi') and order_date between '2026-04-01' and '2026-06-30';



-- 4. The payments team is reviewing card and net banking activity. Show me the orders paid by credit card or net banking where more than 2 units were bought and the order was not cancelled.

select * from orders where payment_mode in ('Credit card','Net Banking') and quantity>2 and order_status<>'Cancelled';


-- 5. Which products are priced between ₹1,000 and ₹5,000 and are not in the Electronics category?
 
select*from products where price between 1000 and 5000 and category<>'Electronics'; 


-- 6. The website search team is testing premium-sounding product names. Which products have "Pro" or "Max" in their name?

select *from products where product_name like '%Pro%' or '%Max%';

-- 7. Marketing wants to send a message to customers whose names start with "S". Give me each such customer once.

select  distinct Customer_name from orders where Customer_name like "S%";


-- 8. Show me all cancelled or returned orders where we gave no discount.

select * from orders where order_status in('Cancelled','Returned') and discount_percent is null ;

-- 9. Which products launched in 2026 have not received a customer rating yet?
select* from products where launch_date between '2026-01-01'and'2026-12-31'and rating is null;
 


-- 10. Who are our 5 most expensive products, and what do they cost?

select product_name,price from products order by price desc limit 5; 


-- 11. Give me the full product list sorted by category from A to Z, and within each category with the most expensive product first.

select product_name,category,price from products order by category asc,price desc; 


-- 12. Show me our 10 biggest delivered orders: who ordered, from which city, and how much they paid.

select order_id,customer_name,city,total_amount from orders where order_status='Delivered' order by total_amount desc limit 10;

-- 13. Give management a one-line summary of all orders that were not cancelled: how many orders, total revenue, average order value, smallest order and largest order. Use readable headings.

select count(*) as 'total orders',
sum(total_amount) as 'total revenue',
avg(total_amount) as 'aveage order value',
min(total_amount) as 'smaller order',
max(total_amount) as 'larger order'
from orders where order_status<>'cancelled';


-- 14. How many orders do we have in total, how many of them had a discount, and how many different customers have ordered?

select
    count(*) as total_orders,
    sum(discount_percent > 0) as discounted_orders,
    count(distinct customer_name) as unique_customers
from orders;


-- 15. For delivered orders, show each city with its number of orders and revenue, biggest revenue first.

select
    city,
    count(*) as total_orders,
    sum(total_amount) as revenue
from orders
where order_status = 'Delivered'
group by city
order by revenue desc;


-- 16. For orders that were not cancelled, show each payment method with its number of orders and average order value. Only include methods used on more than 12 orders.


select
    payment_mode,
    count(*) as total_orders,
    avg(total_amount) as avg_order_value
from orders
where order_status <> 'Cancelled'
group by payment_mode
having count(*) > 12;


-- 17. We want to reward loyal customers. Who has placed more than 4 orders (not counting cancelled ones)? Show their name, number of orders and total spend, and give me only the top 5 spenders.

select
    customer_name,
    count(*) as total_orders,
    sum(total_amount) as total_spend
from orders
where order_status <> 'Cancelled'
group by customer_name
having count(*) > 4
order by total_spend desc
limit 5;


-- 18. For each product category, show how many products we sell, their average price and the total units in stock. Leave out categories with 3 products or fewer. 

select
    category,
    count(*) as total_products,
    avg(price) as avg_price,
    sum(stock_qty) as total_units_in_stock
from products
group by category
having count(*) > 3;

-- 19. Operations wants to find slow cities. Among delivered orders, which cities take more than 6 days on average to deliver? Show the average, slowest first.

select
    city,
    avg(delivery_days) as avg_delivery_days
from orders
where order_status = 'Delivered'
group by city
having avg(delivery_days) > 6
order by avg_delivery_days desc;


-- 20. Looking only at delivered orders placed on or after 1 April 2026, and leaving out Delhi, show the number of orders and revenue for each payment method. Only include methods with revenue above ₹15,000, and show just the top 2.

select
    payment_mode,
    count(*) as total_orders,
    sum(total_amount) as revenue
from orders
where order_status = 'Delivered'
  and order_date >= '2026-04-01'
  and city <> 'Delhi'
group by payment_mode
having sum(total_amount) > 15000
order by revenue desc
limit 2;
