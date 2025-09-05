create database joi;
use joi;
-- MOVE THE SUPERSTORE DATA TO LOCAL C->PROGRAM DATA->MY SQL->MY SQL SERVER 8.0->DATA->DATABASE CREATED
create table super_store (
Row_ID int,
order_id varchar(30),
order_date date,
ship_date date,
arriving_days int,
ship_mode varchar(30),
customer_id varchar(20),
customer_name varchar(30),
segment varchar(30),
country varchar(20),
city varchar(20),
state varchar(50),
postal_code varchar(20),
region varchar(20),
product_id varchar(30),
category varchar(20),
sub_category varchar(20),

sales float,
quantity int,
discount float,
profit float);

select * from super_store;
-- LOADING SUPERSTORE DATA INTO A DATABASE THAT CONTAINS AN EMPTY TABLE
load data infile "Sample_Superstore.csv" into table super_store
fields terminated by ","
Ignore 1 lines;

-- SALES ANALYSIS
select round(sum(sales),2) Total_sales from super_store;
select sub_category,round(sum(sales),2) Total_sales from super_store group by sub_category order by Total_sales desc;
select category,round(sum(sales),2) Total_sales from super_store group by category order by Total_sales desc;
select region,round(sum(sales),2) Total_sales from super_store group by region order by Total_sales desc;
-- CUSTOMER ANAYSIS
select city,state,country,count(distinct customer_id) customer_count,round(sum(sales),2) Total_sales from super_store group by city,state,country order by Total_sales desc;
select segment,count(distinct customer_id) customer_count, round(sum(sales),2) Total_sales from super_store group by segment order by Total_sales desc;
select customer_name,round(sum(sales),2) Total_sales from super_store group by customer_name order by Total_sales desc;
-- PRODUCT ANALYSIS
select sub_category,round(sum(profit),2) Total_profit from super_store group by sub_category order by Total_profit desc;
select sub_category,round(sum(sales),2) Total_sales,sum(quantity) sold_quantity from super_store group by sub_category order by Total_sales desc;
select category,round(sum(sales),2) Total_sales,sum(quantity) sold_quantity from super_store group by category order by Total_sales desc;
-- REGIONAL ANALYSIS
select region,round(sum(sales),2) Total_sales,sum(quantity) sold_quantity from super_store group by region order by Total_sales desc;
select region,country,state,city,count(distinct customer_id) customer_count,round(sum(sales),2) Total_sales from super_store group by region,country,state,city order by Total_sales desc;
-- PROFIT MARGIN ANALYSIS
select sub_category,round(sum(profit)/sum(sales),3)*100 Profit_margin from super_store group by sub_category order by Profit_margin desc;
-- DISCOUNT ANALYSIS
select sub_category,round(SUM(discount),2) Total_discount,round(sum(sales),2) Total_sales from super_store group by sub_category order by Total_discount desc;
-- SALES TREND OVER TIME
select year(order_date) Yearly,round(sum(sales),0) Total_sales from super_store group by Yearly order by Yearly;
select month(order_date) Monthly ,round(sum(sales),0) Total_sales from super_store group by Monthly order by Monthly;
-- CUMMULATIVE ANALYSIS
select order_date,round(sum(sales),0) Daily_sales, round(sum(sum(sales)) over (order by order_date),0) Cummulative_sales from super_store group by order_date;
select sub_category,round(sum(sales),0) Total_sales,round(sum(sum(sales))over(order by sum(sales) desc),0) Cummulative_sales from super_store group by sub_category;
select order_date,round(sum(profit),0) Daily_profit,round(sum(sum(profit))over(order by order_date),0) cummulative_profit from super_store group by order_date;
select sub_category,round(sum(profit),0) Daily_profit,round(sum(sum(profit))over(order by sum(profit)),0) cummulative_profit from super_store group by sub_category;
-- CUMMULATIVE SALES OVER TIME
select month(order_date) month_by_month,round(sum(sales),0) Total_sales,round(sum(sum(sales))over(order by month(order_date)),0) Cummulative_sales from super_store group by month_by_month;
select  day(order_date) day_by_day,round(sum(sales),0) Total_sales,round(sum(sum(sales)) over(order by day(order_date)),0) Cummulative_sales from super_store group by day_by_day;
select  year(order_date) yearly,round(sum(sales),0) Total_sales,round(sum(sum(sales)) over(order by year(order_date)),0) Cummulative_sales from super_store group by yearly;
-- CORRELATION ANALYSIS
select (avg(sales *profit)-avg(sales)*avg(profit))/(stddev(sales)*stddev(profit))  as correlation from super_store;
select(avg(sales*discount)-avg(sales)*avg(discount))/(stddev(sales)*stddev(discount)) as correlation from super_store;
select (avg(sales*quantity)-avg(sales)*avg(quantity))/(stddev(sales)*stddev(quantity)) as correlation from super_store;
-- RANKING ANALYSIS
with cte as (select category,round(sum(sales),2) Total_sales  from super_store group by category)
select category,Total_sales,rank() over(order by Total_sales desc) Ranking from cte;
select sub_category,round(sum(sales),2) Total_sales,rank() over(order by sum(sales) desc) Sales_rank from super_store group by sub_category order by Sales_rank;
-- GROUPING ANALYSIS
select region,sub_category,count(distinct customer_id) customer_count,round(sum(sales),2) Total_sales from super_store group by region,sub_category order by Total_sales desc;
select segment,country,round(sum(sales),2) Total_sales from super_store group by segment,country order by Total_sales desc;
-- PERCENTAGE ANALYSIS
select category,concat(round(sum(sales)/(select sum(sales) from super_store),2)*100,'%') Sales_percentage from super_store group by category order by Sales_percentage desc; 
select segment,concat(round(sum(sales)/(select sum(sales) from super_store),2)*100,'%') Sales_percentage from super_store group by segment order by Sales_percentage desc; 
select ship_mode,concat(round(sum(sales)/(select sum(sales) from super_store),2)*100,'%') Sales_percentage from super_store group by ship_mode order by Sales_percentage desc; 
select region,concat(round(sum(sales)/(select sum(sales) from super_store),3)*100,'%') Sales_percentage from super_store group by region order by Sales_percentage desc; 
-- PROFIT PERCENTGE
select category,concat(round(sum(profit)/(select sum(profit) from super_store),3)*100,'%') Profit_percentage from super_store group by category order by Profit_percentage desc; 
select segment,concat(round(sum(profit)/(select sum(profit) from super_store),2)*100,'%') Profit_percentage from super_store group by segment order by Profit_percentage desc; 
select ship_mode,concat(round(sum(profit)/(select sum(profit) from super_store),2)*100,'%') Profit_percentage from super_store group by ship_mode order by Profit_percentage desc; 
select region,concat(round(sum(profit)/(select sum(profit) from super_store),3)*100,'%') Profit_percentage from super_store group by region order by Profit_percentage desc;
select city,concat(round(sum(profit)/(select sum(profit) from super_store),3)*100,'%') Profit_percentage from super_store group by city order by Profit_percentage desc ; 

-- DISCOUNT PERCENT
select sub_category,concat(round(sum(discount)/(select sum(discount) from super_store),2)*100,'%') Discount_percentage from super_store group by sub_category order by Discount_percentage desc; 
select category,concat(round(sum(discount)/(select sum(discount) from super_store),2)*100,'%') Discount_percentage from super_store group by category order by Discount_percentage desc; 
select ship_mode,concat(round(sum(discount)/(select sum(discount) from super_store),2)*100,'%') Discount_percentage from super_store group by ship_mode order by Discount_percentage desc; 
select region,concat(round(sum(discount)/(select sum(discount) from super_store),2)*100,'%') Discount_percentage from super_store group by region order by Discount_percentage desc; 
