/*
============================================================
                    NovaCart SQL Lab
                  SQL Questions Worksheet
============================================================

Student Name : ______________________________
Section      : ______________________________
ID           : __________________________________

Platform: Microsoft SQL Server / SSMS

Instructions:
1. Complete the database design and implementation before solving
   these questions.
2. Do not modify the database structure just to make a question easier.
3. Write your SQL solution directly below each question.
4. Use meaningful aliases and readable formatting.
5. All queries must execute successfully on your completed NovaCartDB.
6. Use the separate Hints PDF only when you are genuinely stuck.
7. Do not hard-code results that should be calculated from the data.

Database:
    NovaCartDB

============================================================
*/

USE NovaCartDB;
GO

/*============================================================
                MISSION 1 — CUSTOMER & PRODUCT OVERVIEW
============================================================*/

-- M1-Q1
-- Display all customers.

-- Your query:
SELECT * FROM Customers;


------------------------------------------------------------

-- M1-Q2
-- Display the product name, category, and current price
-- for every product.

-- Your query:
SELECT 
product_name,
category, 
price AS current_price 
FROM Products;



------------------------------------------------------------

-- M1-Q3
-- Display products whose current price is greater than 5000.

-- Your query:
SELECT
product_name,
price
FROM Products WHERE price > 5000;

------------------------------------------------------------

-- M1-Q4
-- Display all customers ordered by join date, newest first.

-- Your query:
SELECT * FROM Customers
ORDER BY join_date DESC;

------------------------------------------------------------

-- M1-Q5
-- Display the total number of customers.

-- Your query:
SELECT
COUNT(*) AS total_customers
FROM Customers;

/*============================================================
             MISSION 2 — AGGREGATION & BUSINESS TOTALS
============================================================*/

-- M2-Q1
-- Calculate the average current product price.

-- Your query:
SELECT 
AVG(price) AS avg_product_price
FROM Products;

------------------------------------------------------------

-- M2-Q2
-- Display the highest and lowest current product prices.

-- Your query:
SELECT
MAX(price) AS highest_price,
MIN(price) AS lowest_price
FROM Products;


------------------------------------------------------------

-- M2-Q3
-- Calculate the total available stock quantity.

-- Your query:
SELECT
SUM(stock_quantity) AS total_quantity
FROM Products;


------------------------------------------------------------

-- M2-Q4
-- Calculate the total amount recorded in Payments.

-- Your query:
SELECT
SUM(amount) AS total_amount
FROM Payments;


------------------------------------------------------------

-- M2-Q5
-- Display the number of orders for each order status.

-- Your query:
SELECT 
status,
COUNT(*) AS total_orders
FROM Orders
GROUP BY status;


------------------------------------------------------------

-- M2-Q6
-- Display the total payment amount for each payment method.

-- Your query:
SELECT 
payment_method,
SUM (amount) AS total_payment_amount
FROM Payments
GROUP BY payment_method;


/*============================================================
               MISSION 3 — ORDER & SALES ANALYSIS
============================================================*/

-- M3-Q1
-- Calculate the total sales amount for each order.
-- Use quantity multiplied by the historical unit price.

-- Your query:
SELECT 
orderid,
SUM(quantity * unit_price) AS total_sales_amount
FROM OrderDetails
GROUP BY orderid;


------------------------------------------------------------

-- M3-Q2
-- Display only orders whose total sales exceed 5000.

-- Your query:
SELECT
orderid,
SUM(quantity * unit_price) AS total_sales_amount
FROM OrderDetails
GROUP BY orderid
HAVING SUM (quantity * unit_price) > 5000;


------------------------------------------------------------

-- M3-Q3
-- Display each order together with:
-- customer name, order date, and order status.

-- Your query:
SELECT
c.full_name AS name,
o.order_date,
o.status,
o.orderid
FROM Orders o
INNER JOIN Customers c ON o.customerid = c.customerid;



------------------------------------------------------------

-- M3-Q4
-- Display each order with:
-- product name, purchased quantity, and historical unit price.

-- Your query:
SELECT 
o.orderid,
p.product_name,
d.quantity,
d.unit_price
FROM Orders o
INNER JOIN OrderDetails d on o.orderid = d.orderid
INNER JOIN Products p ON d.productid = p.productid;



------------------------------------------------------------

-- M3-Q5
-- Display the total amount spent by each customer.

-- Your query:
SELECT 
c.customerid,
c.full_name AS name,
SUM(d.quantity * d.unit_price) AS total_amount_spent
FROM Customers c
INNER JOIN Orders o ON c.customerid = o.customerid
INNER JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY c.customerid, c.full_name;

/*============================================================
              MISSION 4 — REVIEWS & RELATIONSHIPS
============================================================*/

-- M4-Q1
-- Display the number of reviews received by each product,
-- including products with no reviews.

-- Your query:
SELECT
p.productid,
p.product_name,
COUNT (r.reviewid) AS total_reviwes
FROM Products p
LEFT JOIN Reviews r ON p.productid = r.productid
GROUP BY p.productid, p.product_name;


------------------------------------------------------------

-- M4-Q2
-- Display all reviews together with:
-- customer name and product name.

-- Your query:
SELECT 
c.full_name,
p.product_name,
r.reviewid,
r.rating,
r.comment,
r.review_date
FROM Reviews r
INNER JOIN Customers c ON r.customerid = c.customerid
INNER JOIN Products p ON r.productid = p.productid;



------------------------------------------------------------

-- M4-Q3
-- Display customers who have placed at least one order.

-- Your query:
SELECT DISTINCT
o.customerid,
c.full_name
FROM Customers c
INNER JOIN Orders o ON c.customerid = o.customerid;
------------------------------------------------------------

-- M4-Q4
-- Display products that have never been ordered.

-- Your query:
SELECT 
p.productid,
p.product_name
FROM Products p 
WHERE NOT EXISTS (SELECT 1 FROM OrderDetails d WHERE d.productid = p.productid);

------------------------------------------------------------

-- M4-Q5
-- Display products that have never received a review.

-- Your query:
SELECT 
p.productid,
p.product_name
FROM Products p
LEFT JOIN Reviews r ON p.productid = r.productid
WHERE r.productid IS NULL;


------------------------------------------------------------

-- M4-Q6
-- Display all customers and their number of orders,
-- including customers who have never placed an order.

-- Your query:
SELECT
c.full_name,
c.customerid,
COUNT(o.orderid) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customerid = o.orderid
GROUP BY c.customerid, c.full_name
ORDER BY total_orders DESC;

/*============================================================
                       MISSION 5 — SUBQUERIES
============================================================*/

-- M5-Q1
-- Display customers who placed more orders than the average
-- number of orders among customers who placed at least one order.

-- Your query:
SELECT 
c.customerid,
c.full_name,
COUNT(o.orderid) AS total_orders
FROM Customers c
INNER JOIN Orders o ON c.customerid = o.customerid
GROUP BY c.customerid, c.full_name
HAVING COUNT(o.orderid) > (
SELECT AVG(CAST(order_count AS FLOAT))
FROM (
SELECT COUNT(orderid) AS order_count
FROM Orders
GROUP BY customerid) AS user_orders)
ORDER BY total_orders DESC;


------------------------------------------------------------

-- M5-Q2
-- Display products whose current price is above the average
-- current product price.

-- Your query:
SELECT 
productid,
product_name,
price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)
ORDER BY price DESC;



------------------------------------------------------------

-- M5-Q3
-- Display customers whose total spending is greater than
-- the average total spending among customers who have made
-- at least one payment.

-- Your query:
WITH CustomerSpending AS (
SELECT 
o.customerid,
SUM(d.quantity * d.unit_price) AS total_spent
FROM Orders o
INNER JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY o.customerid
)
SELECT 
c.customerid,
c.full_name AS customer_name,
SUM(d.quantity * d.unit_price) AS total_spending
FROM Customers c
INNER JOIN Orders o ON c.customerid = o.customerid
INNER JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY c.customerid, c.full_name
HAVING SUM(d.quantity * d.unit_price) > (
SELECT AVG(total_spent) 
FROM CustomerSpending
)
ORDER BY total_spending DESC;


/*============================================================
                MISSION 6 — COMMON TABLE EXPRESSIONS
============================================================*/

-- M6-Q1
-- Using a CTE, calculate total revenue by month.

-- Your query:
WITH MonthlyRevenue AS (
SELECT 
FORMAT(o.order_date, 'yyyy-MM') AS revenue_month,
SUM(d.quantity * d.unit_price) AS total_revenue
FROM Orders o
INNER JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
)
SELECT 
revenue_month,
total_revenue
FROM MonthlyRevenue
ORDER BY revenue_month ASC;



------------------------------------------------------------

-- M6-Q2
-- Using a CTE, calculate total spending by customer.
-- Return only customers whose total spending exceeds 10000.

-- Your query:
WITH TotalCustomerSpending AS (
SELECT 
c.customerid,
c.full_name AS customer_name,
SUM(d.quantity * d.unit_price) AS total_spending
FROM Customers c
INNER JOIN Orders o ON c.customerid = o.customerid
INNER JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY c.customerid, c.full_name
)
SELECT 
customerid,
customer_name,
total_spending
FROM TotalCustomerSpending
WHERE total_spending > 10000
ORDER BY total_spending DESC;


/*============================================================
                  MISSION 7 — WINDOW FUNCTIONS
============================================================*/

-- M7-Q1
-- Rank customers by total spending using RANK(),
-- with the highest spending ranked first.

-- Your query:
SELECT 
c.customerid,
c.full_name AS customer_name,
SUM(d.quantity * d.unit_price) AS total_spending,
RANK() OVER (ORDER BY SUM(d.quantity * d.unit_price) DESC) AS spending_rank
FROM Customers c
INNER JOIN Orders o ON c.customerid = o.customerid
INNER JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY c.customerid, c.full_name
ORDER BY spending_rank ASC;

------------------------------------------------------------

-- M7-Q2
-- Rank products by total quantity sold using DENSE_RANK(),
-- with the highest quantity ranked first.

-- Your query:
SELECT 
p.productid,
p.product_name,
SUM(d.quantity) AS total_quantity_sold,
DENSE_RANK() OVER (ORDER BY SUM(d.quantity) DESC) AS quantity_rank
FROM Products p
INNER JOIN OrderDetails d ON p.productid = d.productid
GROUP BY p.productid, p.product_name
ORDER BY quantity_rank ASC;


------------------------------------------------------------

-- M7-Q3
-- Display each payment together with the previous payment amount
-- using LAG().
-- Order the sequence by payment date and payment ID.

-- Your query:
SELECT 
paymentid,
orderid,
payment_date,
amount,
LAG(amount) OVER (ORDER BY payment_date ASC, paymentid ASC) AS previous_payment_amount
FROM Payments
ORDER BY payment_date ASC, paymentid ASC;


------------------------------------------------------------

-- M7-Q4
-- Display a running total of payment amounts.
-- Order the sequence by payment date and payment ID.

-- Your query:
SELECT 
paymentid,
orderid,
payment_date,
amount,
SUM(amount) OVER (ORDER BY payment_date ASC, paymentid ASC) AS running_total_payments
FROM Payments
ORDER BY payment_date ASC, paymentid ASC;


/*============================================================
                         MISSION 8 — VIEWS
============================================================*/

-- M8-Q1
-- Create a view named vw_revenue_by_month
-- that displays monthly revenue.

-- Your query:
CREATE VIEW vw_revenue_by_month AS
SELECT 
FORMAT(o.order_date, 'yyyy-MM') AS revenue_month,
SUM(d.quantity * d.unit_price) AS total_revenue
FROM Orders o
INNER JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY FORMAT(o.order_date, 'yyyy-MM');



------------------------------------------------------------

-- M8-Q2
-- Create a view named vw_best_selling_products
-- that displays:
--   Product Name
--   Total Quantity Sold
--   Total Revenue

-- Your query:
CREATE VIEW vw_best_selling_products AS
SELECT 
p.product_name,
SUM(d.quantity) AS total_quantity_sold,
SUM(d.quantity * d.unit_price) AS total_revenue
FROM Products p
INNER JOIN OrderDetails d ON p.productid = d.productid
GROUP BY p.productid, p.product_name;


------------------------------------------------------------

-- M8-Q3
-- Create a view named vw_customer_summary
-- that displays:
--   Customer Name
--   Number of Orders
--   Total Amount Spent

-- Your query:
CREATE VIEW vw_customer_summary AS
SELECT 
c.full_name AS customer_name,
COUNT(DISTINCT o.orderid) AS total_orders,
ISNULL(SUM(d.quantity * d.unit_price), 0.00) AS total_amount_spent
FROM Customers c
LEFT JOIN Orders o ON c.customerid = o.customerid
LEFT JOIN OrderDetails d ON o.orderid = d.orderid
GROUP BY c.customerid, c.full_name;


/*============================================================
                           END
============================================================*/
