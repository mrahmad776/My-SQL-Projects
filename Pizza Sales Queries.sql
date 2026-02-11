-- Retrieve the total number of orders placed.

SELECT COUNT(order_id) AS Total_Orders 
FROM orders;
--  Calculate the total revenue generated from pizza sales.

SELECT ROUND(SUM(od.quantity * p.price), 2) AS Total_Revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;
-- Identify the highest-priced pizza.

SELECT pt.name, p.price
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;
-- Identify the most common pizza size ordered.

SELECT p.size, COUNT(od.order_details_id) AS Order_Count
FROM pizzas p
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Order_Count DESC
LIMIT 1;
--  top 5 most ordered pizza types along with their quantities.

SELECT pt.name, SUM(od.quantity) AS Total_Quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY Total_Quantity DESC
LIMIT 5;

--  Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pt.category, SUM(od.quantity) AS Total_Quantity
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY Total_Quantity DESC;
-- Determine the distribution of orders by hour of the day.

SELECT HOUR(order_time) AS Hour_of_Day, COUNT(order_id) AS Order_Count
FROM orders
GROUP BY HOUR(order_time);
-- Join relevant tables to find the category-wise distribution of pizzas. 

SELECT category, COUNT(name) AS Pizza_Types_Count
FROM pizza_types
GROUP BY category;
 -- Group the orders by date and calculate the average number of pizzas ordered per day. 

SELECT ROUND(AVG(quantity), 0) AS Avg_Pizzas_Per_Day
FROM (
    SELECT o.order_date, SUM(od.quantity) AS quantity
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date
) AS order_quantity;
-- Determine the top 3 most ordered pizza types based on revenue.

SELECT pt.name, SUM(od.quantity * p.price) AS Revenue
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY Revenue DESC
LIMIT 3;

--  Calculate the percentage contribution of each pizza category to total revenue.

SELECT pt.category, 
       ROUND(SUM(od.quantity * p.price) / (SELECT SUM(od.quantity * p.price) 
       FROM order_details od 
       JOIN pizzas p ON od.pizza_id = p.pizza_id) * 100, 2) AS Revenue_Share
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY Revenue_Share DESC;
 -- Analyze the cumulative revenue generated over time. 

SELECT order_date,
       SUM(Daily_Revenue) OVER(ORDER BY order_date) AS Cumulative_Revenue
FROM (
    SELECT o.order_date, SUM(od.quantity * p.price) AS Daily_Revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY o.order_date
) AS Sales;
 -- Determine the top 3 most ordered pizza types based on revenue for EACH pizza category.

SELECT name, category, revenue
FROM (
    SELECT pt.category, pt.name, SUM(od.quantity * p.price) AS Revenue,
           RANK() OVER(PARTITION BY pt.category ORDER BY SUM(od.quantity * p.price) DESC) AS rn
    FROM pizza_types pt
    JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
    JOIN order_details od ON p.pizza_id = od.pizza_id
    GROUP BY pt.category, pt.name
) AS ranked_pizzas
WHERE rn <= 3;