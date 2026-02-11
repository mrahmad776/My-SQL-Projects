CREATE DATABASE TechTrend;
USE TechTrend;


-- -- Customers: customer_id (PK), name, email, region, join_date.

CREATE TABLE Customer
(
customer_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(100),
email VARCHAR(100),
region VARCHAR(100),
join_date INT
);
ALTER TABLE Customer MODIFY join_date DATE;

-- -- Products: product_id (PK), name, category, price, stock_quantity.
CREATE TABLE Products
(
product_id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(200),
category VARCHAR(100),
price INT,
stock_quantity INT 
);

-- -- Orders: order_id (PK),  customer_id(FK), order_date, total_amount.

CREATE TABLE Orders
(
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
order_date DATE,
total_amount INT,
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- -- Order_Details: detail_id (PK), order_id (FK), product_id (FK), quantity, unit_price.

CREATE TABLE Order_Details
(
detail_id INT PRIMARY KEY AUTO_INCREMENT,
order_id INT,
product_id INT,
quantity INT,
unit_price INT,
FOREIGN KEY(order_id) REFERENCES Orders(order_id),
FOREIGN KEY(product_id) REFERENCES Products(product_id)
);

 

INSERT INTO Customer (name, email, region, join_date) VALUES
('Ali','ali.khan@example.com', 'South', '2023-01-15'),
('Sara', 'sara.ahmed@example.com', 'North', '2023-02-10'),
('Bilal',  'bilal.saeed@example.com', 'East', '2023-03-05'),
('Zainab',  'zainab.riaz@example.com', 'South', '2023-05-20'),
('Usman',  'usman.tariq@example.com', 'West', '2023-06-15');

INSERT INTO Products (product_name, category, price, stock_quantity) VALUES
('Gaming Laptop', 'Electronics', 1200.00, 15),
('Wireless Mouse', 'Accessories', 25.50, 100),
('Mechanical Keyboard', 'Accessories', 85.00, 50),
('Smartphone X', 'Electronics', 800.00, 30),
('Noise Cancelling Headphones', 'Electronics', 150.00, 45);


INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2023-07-01', 1225.50), -- Ali bought Laptop + Mouse
(2, '2023-07-05', 800.00),  -- Sara bought Smartphone
(1, '2023-08-10', 170.00),  -- Ali bought 2 Keyboards
(3, '2023-08-15', 150.00),  -- Bilal bought Headphones
(4, '2023-09-01', 1200.00); -- Zainab bought Laptop

INSERT INTO Order_Details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00), -- Order 1 contains 1 Laptop
(1, 2, 1, 25.50),  -- Order 1 also contains 1 Mouse
(2, 4, 1, 800.00), -- Order 2 contains 1 Smartphone
(3, 3, 2, 85.00),  -- Order 3 contains 2 Keyboards
(4, 5, 1, 150.00), -- Order 4 contains 1 Headphone
(5, 1, 1, 1200.00);-- Order 5 contains 1 Laptop

-- ANALYTICS ON IMP COLUMNS
-- TOTAL REVENUE
SELECT p.category,
SUM(od.quantity * od.unit_price) AS Total_Revenue
FROM products p
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.category;

-- TOP CUSTOMERS
SELECT c.name,
SUM(O.total_amount) AS Spending
FROM customer c 
JOIN Orders O ON c.customer_id = o.customer_id
GROUP BY c.customer_id , c.name
ORDER BY Spending DESC;

-- the total number of items sold
SELECT p.product_ID, p.product_name,
SUM(od.quantity) AS Total_Sold
FROM Products p
JOIN Order_Details od ON p.product_id = p.Product_ID
GROUP BY p.product_id ,p.product_name, od.quantity
ORDER BY Total_Sold DESC;

-- "Revenue by Category" report every single Monday.
CREATE VIEW SUMMARY_OF_SALES AS
SELECT p.category,
COUNT(od.detail_id) AS Total_Orders,
SUM(od.quantity * od.unit_price) AS Total_Revenue
FROM products p
JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.category;

SELECT * FROM SUMMARY_OF_SALES;

DELIMITER $$
CREATE PROCEDURE Customer_History(IN target_customer INT)
BEGIN 
SELECT
        o.order_id,
        o.order_date,
        o.total_amount
FROM Orders o
WHERE o.customer_id = target_customer
ORDER BY o.order_date DESC;

END $$
 DELIMITER ;
 
 CALL Customer_History(2);
 












SELECT * FROM customer;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_detailS;


