CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Segment VARCHAR(50)
);

CREATE TABLE Products(
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  Category VARCHAR(50),
  Price DECIMAL(10,2)
);

CREATE TABLE Orders(
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductID INT,
  OrderDate DATE,
  Quantity INT,
  Sales DECIMAL(10,2),
  
  FOREIGN KEY (CustomerID)
  REFERENCES Customers(CustomerID),
  
  FOREIGN KEY (ProductID)
  REFERENCES Products(ProductID)
);

SHOW TABLES;

INSERT INTO Customers VALUES
(1,'Rahul','Delhi','Consumer'),
(2,'Priya','Mumbai','Corporate'),
(3,'Aman','Bhopal','Consumer'),
(4,'Neha','Pune','Home Office'),
(5,'Rohit','Hyderabad','Corporate');
  
INSERT INTO Products VALUES
(101,'Laptop','Electronics',50000),
(102,'Phone','Electronics',25000),
(103,'Chair','Furniture',5000),
(104,'Table','Furniture',8000),
(105,'Printer','Office Supplies',12000);  
  
INSERT INTO Orders VALUES
(1001,1,101,'2025-01-10',1,50000),
(1002,2,102,'2025-01-15',2,50000),
(1003,3,103,'2025-02-01',3,15000),
(1004,4,104,'2025-02-10',1,8000),
(1005,5,105,'2025-03-01',2,24000);

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;

SHOW TABLES;

DESC Customers;
ALTER TABLE Customers
ADD State VARCHAR(50);

DESC Products;
ALTER TABLE Products
ADD SubCategory VARCHAR(50);

DESC Orders;
ALTER TABLE Orders
ADD Profit DECIMAL(10,2);
ALTER TABLE Orders
ADD Discount DECIMAL(5,2);

DESC Customers;
DESC Products;
DESC Orders;

SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM Products;
SELECT COUNT(*) FROM Orders;

SELECT
OrderID,
COUNT(*)
FROM Orders
GROUP BY OrderID
HAVING COUNT(*) > 1; #no duplicates

SELECT *
FROM Customers
WHERE CustomerID <= 5;

UPDATE Customers
SET State = 'Delhi'
WHERE CustomerID = 1;

UPDATE Customers
SET State = 'Maharashtra'
WHERE CustomerID = 2;

UPDATE Customers
SET State = 'Madhya Pradesh'
WHERE CustomerID = 3;

UPDATE Customers
SET State = 'Maharashtra'
WHERE CustomerID = 4;

UPDATE Customers
SET State = 'Telangana'
WHERE CustomerID = 5;

SELECT *
FROM Products
WHERE ProductID <= 110;

UPDATE Products
SET SubCategory = 'Computers'
WHERE ProductID = 101;

UPDATE Products
SET SubCategory = 'Mobiles'
WHERE ProductID = 102;

UPDATE Products
SET SubCategory = 'Mobiles'
WHERE ProductID = 103;

UPDATE Products
SET SubCategory = 'Chairs'
WHERE ProductID = 104;

UPDATE Products
SET SubCategory = 'Tables'
WHERE ProductID = 105;

UPDATE Customers
SET
    City = 'Bhopal',
    State = 'Madhya Pradesh',
    Segment = 'Corporate'
WHERE CustomerID = 10;

UPDATE Orders
SET
  Profit=  4589.76,
  Discount=0.1
WHERE OrderID=1005;  


