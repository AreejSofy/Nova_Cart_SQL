CREATE DATABASE NovaCartDB;
GO

CREATE TABLE Customers(
customerid INT PRIMARY KEY  NOT NULL,
full_name NVARCHAR(100) NOT NULL,
phone_number NVARCHAR(20) NULL,
email NVARCHAR(100) UNIQUE NULL,
join_date DATE NOT NULL CONSTRAINT DF_Customers_join_date DEFAULT (CAST(GETDATE() AS DATE))
);
GO

INSERT INTO Customers (customerid, full_name, phone_number, email, join_date)
VALUES 
(1,'Sarah Jenkins','+1 (555) 234-5678','s.jenkins88@gmail.com','2023-01-14'),
(2,'Marcus Vance','+1 (555) 876-5432','marcus.vance@techcorp.io','2023-01-29'),
(3,'Elena Rostova','+1 (555) 432-1098','elena.rostova@gmail.com','2023-02-05'),
(4,'David O''Connor','+1 (555) 901-2345','doconnor@outlook.com','2023-02-18'),
(5,'Priya Patel','+1 (555) 654-3210','priya.patel@designs.co','2023-03-02'),
(6,'Liam Gallagher',NULL,'lgallagher92@yahoo.com','2023-03-21'),
(7,'Aisha Khan','+1 (555) 321-9876','aisha.k@freemail.net','2023-04-11'),
(8,'Carlos Gomez','+1 (555) 789-0123','carlos.gomez@gmail.com','2023-04-30'),
(9,'Hannah Schmidt','+1 (555) 210-9876','hannah.schmidt@outlook.com','2023-05-12'),
(10,'Tariq Al-Mansoor','+1 (555) 543-2109','tariq.mansoor@alman-consulting.com','2023-06-01'),
(11,'Chloe Dubois','+1 (555) 890-1234','chloe.dubois@proton.me','2023-06-19'),
(12,'Devon Miller',NULL,'devon.miller@gmail.com','2023-07-04'),
(13,'Siddharth Rao','+1 (555) 678-9012','siddharth.rao@enterprise.org','2023-07-22'),
(14,'Jessica Sterling','+1 (555) 345-6789','jess.sterling@gmail.com','2023-08-08'),
(15,'Tyler Washington','+1 (555) 987-6543','twashington@icloud.com','2023-08-31'),
(16,'Mei-Ling Chen','+1 (555) 123-8901','ml.chen@biotech.res.net','2023-09-15'),
(17,'Benjamin Brooks','+1 (555) 765-4321','ben.brooks@yahoo.com','2023-10-02'),
(18,'Fatima Said','+1 (555) 456-7890','fatima_said@outlook.com','2023-10-20'),
(19,'Alexander Novak',NULL,'anovak99@gmail.com','2023-11-05'),
(20,'Zoe Takahashi','+1 (555) 012-3456','zoe.takahashi@studio.design','2023-11-28');

GO

SELECT * FROM Customers;


CREATE TABLE Products(
productid INT PRIMARY KEY  NOT NULL,
product_name NVARCHAR(100) NOT NULL,
category NVARCHAR(50) NOT NULL,
price DECIMAL(10,2) NOT NULL,
stock_quantity INT NOT NULL
CONSTRAINT DF_Products_stock DEFAULT (0),
CONSTRAINT CK_Products_price  CHECK (price >= 0),
CONSTRAINT CK_Products_stock  CHECK (stock_quantity >= 0)
);
GO


INSERT INTO Products (productid,product_name,category,price,stock_quantity)
VALUES 
(1,'UltraSlim Laptop 15"','Electronics',1299.99,45),
(2,'Pro Wireless Headphones','Audio',199.99,120),
(3,'4K Smart Monitor 27"','Electronics',349.50,30),
(4,'Ergonomic Mechanical Keyboard','Accessories',89.99,85),
(5,'Precision Wireless Mouse','Accessories',49.99,150),
(6,'Smartphone Pro Max 256GB','Electronics',1099.00,25),
(7,'Noise-Cancelling Earbuds','Audio',129.95,90),
(8,'Portable Bluetooth Speaker','Audio',79.99,110),
(9,'USB-C Multi-Port Hub','Accessories',39.99,200),
(10,'Fast Charging Pad 15W','Accessories',24.99,300),
(11,'Smart Robot Vacuum','Home Appliances',299.99,40),
(12,'Digital Espresso Machine','Home Appliances',449.00,18),
(13,'Air Purifier HEPA H13','Home Appliances',159.99,65),
(14,'Electric Kettle Stainless','Home Appliances',45.50,140),
(15,'Smart Thermostat WiFi','Home Appliances',129.00,50),
(16,'Fitness Smartwatch Series 5','Electronics',229.99,75),
(17,'HD Webcam 1080p','Accessories',59.99,110),
(18,'Aluminum Laptop Stand','Accessories',34.99,160),
(19,'External SSD 1TB Portable','Electronics',119.99,95),
(20,'Smart LED Light Strip 5M','Home Appliances',29.99,200);

GO


SELECT * FROM Products;


CREATE TABLE Orders(
orderid INT PRIMARY KEY NOT NULL,
customerid INT NOT NULL,
order_date DATE NOT NULL,
status NVARCHAR(50) NOT NULL CONSTRAINT DF_Orders_status DEFAULT ('Pending'),
CONSTRAINT FK_Orders_Customers FOREIGN KEY (customerid) REFERENCES Customers(customerid),
CONSTRAINT CK_Orders_status CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);
GO

INSERT INTO Orders (orderid,customerid,order_date,status)
VALUES 
(1,1,'2023-01-15','Delivered'),
(2,1,'2023-03-10','Delivered'),
(3,1,'2023-08-22','Shipped'),
(4,2,'2023-02-01','Delivered'),
(5,4,'2023-06-15','Pending'),
(6,7,'2023-02-10','Delivered'),
(7,7,'2023-02-25','Delivered'),
(8,10,'2023-07-04','Cancelled'),
(9,11,'2023-03-05','Delivered'),
(10,13,'2023-03-25','Delivered'),
(11,13,'2023-04-15','Shipped'),
(12,14,'2023-05-02','Delivered'),
(13,15,'2023-06-21','Delivered'),
(14,16,'2023-07-25','Delivered'),
(15,16,'2023-08-10','Delivered'),
(16,17,'2023-09-18','Pending'),
(17,18,'2023-09-02','Shipped'),
(18,20,'2023-09-20','Delivered'),
(19,20,'2023-10-05','Delivered'),
(20,20,'2023-11-10','Pending');

GO

SELECT * FROM Orders;


CREATE TABLE Payments (
paymentid INT PRIMARY KEY  NOT NULL,
orderid INT NOT NULL,
payment_date DATE NOT NULL,
amount DECIMAL (10,2) NOT NULL,
payment_method NVARCHAR(20) NOT NULL,
CONSTRAINT UQ_Payments_order UNIQUE (orderid),
CONSTRAINT FK_Payments_Orders FOREIGN KEY (orderid) REFERENCES Orders (orderid),
CONSTRAINT CK_Payments_amount CHECK (amount > 0),
CONSTRAINT CK_Payments_method CHECK (payment_method IN ('Credit Card','PayPal','COD','Debit Card'))
);
GO

INSERT INTO Payments (paymentid,orderid,payment_date,amount,payment_method)
VALUES 
(1,1,'2023-01-15',1299.99,'Credit Card'),
(2,2,'2023-02-01',349.50,'COD'),
(3,3,'2023-02-10',449.00,'PayPal'),
(4,4,'2023-02-25',159.99,'Debit Card'),
(5,5,'2023-03-05',229.99,'Credit Card'),
(6,6,'2023-03-25',119.99,'COD'),
(7,7,'2023-04-15',79.99,'PayPal'),
(8,8,'2023-05-02',299.99,'Credit Card'),
(9,9,'2023-06-21',199.99,'COD'),
(10,10,'2023-07-25',39.99,'Debit Card'),
(11,11,'2023-08-10',1099.00,'Credit Card'),
(12,12,'2023-09-02',89.99,'PayPal'),
(13,13,'2023-09-20',159.99,'Debit Card'),
(14,14,'2023-10-05',45.50,'Debit Card'),
(15,15,'2023-11-10',119.99,'Credit Card'),
(16,16,'2023-08-10',1099.00,'Credit Card'),
(17,17,'2023-09-02',89.99,'PayPal'),
(18,18,'2023-09-20',159.99,'Debit Card'),
(19,19,'2023-10-05',45.50,'COD'),
(20,20,'2023-11-10',119.99,'Credit Card');
GO

SELECT * FROM Payments;


CREATE TABLE Reviews (
reviewid INT PRIMARY KEY NOT NULL,
customerid INT NOT NULL,
productid INT NOT NULL,
rating INT NOT NULL,
comment NVARCHAR(500) NULL,
review_date DATE NOT NULL
CONSTRAINT DF_Reviews_date DEFAULT (CAST(GETDATE() AS DATE)),
CONSTRAINT FK_Reviews_Customers FOREIGN KEY (customerid)
REFERENCES Customers (customerid),
CONSTRAINT FK_Reviews_Products  FOREIGN KEY (productid)
REFERENCES Products (productid),
CONSTRAINT CK_Reviews_rating CHECK (rating BETWEEN 1 AND 5),
CONSTRAINT UQ_Reviews_cust_prod UNIQUE (customerid, productid)
);
GO

INSERT INTO Reviews (reviewid,customerid,productid,rating,comment,review_date)
VALUES 
(1,1,1,5,'Exceptional laptop performance for daily work and gaming!','2023-01-20'),
(2,1,2,4,NULL,'2023-03-15'),
(3,2,3,5,'The 4K resolution is super sharp. Perfect setup for my home office.','2023-02-10'),
(4,4,12,1,'Machine stopped brewing properly after two weeks of use.','2023-02-18'),
(5,10,13,3,'Purifies the air well, but the fan gets quite noisy on high speed.','2023-03-01'),
(6,12,16,5,'Sleek design, tracks all my workouts accurately.','2023-03-10'),
(7,13,14,4,NULL,'2023-04-02'),
(8,13,7,2,'Connectivity drops frequently when moving between rooms.','2023-04-20'),
(9,14,11,5,'Saves me so much time every day. Navigates around furniture easily.','2023-05-10'),
(10,15,4,5,'Tactile feel on the switches is top notch! Outstanding build quality.','2023-06-25'),
(11,17,5,4,'Ergonomic shape reduces wrist fatigue during long work sessions.','2023-07-01'),
(12,18,9,5,'Very useful multi-port hub. Handles dual monitors without lag.','2023-08-01'),
(13,20,6,2,'Phone gets hot when fast charging and battery drain is fast.','2023-08-15'),
(14,20,19,5,'Lighting fast read/write speeds for video editing projects.','2023-09-25'),
(15,20,18,3,NULL,'2023-10-12');
GO

SELECT * FROM Reviews;

CREATE TABLE OrderDetails (
orderid INT NOT NULL,
productid INT NOT NULL,
quantity INT NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
CONSTRAINT PK_OrderDetails PRIMARY KEY (orderid, productid),
CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (orderid)
REFERENCES Orders (orderid),
CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (productid)
REFERENCES Products (productid),
CONSTRAINT CK_OrderDetails_quantity CHECK (quantity > 0),
CONSTRAINT CK_OrderDetails_price CHECK (unit_price >= 0)
);
GO


INSERT INTO OrderDetails (orderid,productid,quantity,unit_price)
VALUES 
(1,1,1,1299.99),
(2,2,2,144.99),
(3,3,1,129.95),
(4,2,5,149.50),
(4,4,1,200.00),
(5,5,1,89.99),
(6,1,7,449.00),
(7,3,3,159.99),
(8,5,1,50.00),
(9,4,1,229.99),
(10,2,4,119.99),
(11,5,1,79.99),
(12,3,2,149.99),
(13,4,1,199.99),
(14,5,4,39.99),
(15,1,1,1099.00);
GO

SELECT * FROM OrderDetails;
