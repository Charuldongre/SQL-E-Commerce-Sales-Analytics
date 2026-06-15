#TOTAL REVENUE
SELECT SUM(Sales) as TOTALREVENUE
FROM Orders;

#TOTAL PROFIT
SELECT SUM(Profit) AS TOTALPROFIT
FROM Orders;

#TOTAL ORDERS
SELECT COUNT(*) AS TOTALORDERS
FROM Orders;

#AVERAGE ORDER VALUE
SELECT AVG(Sales) AS AvgOrderValue
FROM Orders;
#############################################################
#REVENUE BY CATEGORY
SELECT p.Category,SUM(o.Sales) AS Revenue
FROM Products p
JOIN Orders o
ON p.ProductID=o.ProductID
GROUP BY p.Category;

#Top Cities by Sales
SELECT c.City,SUM(o.Sales) AS SalesByCity
FROM Customers c
JOIN Orders o
ON c.CustomerID=o.CustomerID
group by c.City
order by SUM(o.Sales) DESC;

#REVENUE BY CUSTOMER SEGMENT
SELECT c.Segment,SUM(o.Sales) AS RevenueBySegment
FROM Customers c
JOIN Orders o
ON c.CustomerID=o.CustomerID
Group By c.Segment;



#TOP CUSTOMERS
SELECT c.CustomerName,SUM(o.Sales) AS Revenue
FROM Customers c
JOIN Orders o
ON c.CustomerID=o.CustomerID
GROUP BY c.CustomerName
ORDER BY Revenue DESC;

#TOP PRODUCTS
SELECT p.ProductName,SUM(o.Quantity) AS UnitsSold
FROM Products p
JOIN Orders o
ON p.ProductID=o.ProductID
GROUP BY p.ProductName
ORDER BY UnitsSold DESC;

#############################################################

#MONTHLY REVENUE
SELECT MONTH(OrderDate) AS MONTH,SUM(Sales) AS Revenue
FROM Orders
GROUP BY MONTH(OrderDate)
ORDER BY MONTH;

SELECT year(OrderDate) AS YEAR,MONTH(OrderDate) as MONTH,SUM(Sales) as Revenue
FROM Orders
group by year(OrderDate),MONTH(OrderDate)
order by YEAR,MONTH;

#MONTHLY PROFIT TREND
SELECT year(OrderDate) AS YEAR,MONTH(OrderDate) as MONTH,SUM(Profit) as MonthlyProfit
FROM Orders
group by year(OrderDate),MONTH(OrderDate)
order by YEAR,MONTH;

#Category Profitability
SELECT c.Category,SUM(o.Profit) as CategoryProfit
FROM Products c
JOIN Orders o
ON c.ProductID=o.ProductID
GROUP BY c.Category;

###########################################################
#customer segmentation
SELECT CustomerID,SUM(Sales) AS Revenue,
CASE
WHEN SUM(Sales)>10000
THEN 'High Value'

WHEN SUM(Sales)>5000
THEN 'Medium Value'

ELSE 'Low Value'
END AS CustomerType

FROM Orders
GROUP BY CustomerID;

#DISCOUNT CLASSIFICATION
SELECT OrderID,Discount,
CASE
WHEN Discount>=0.3
THEN 'High Discount'

WHEN Discount>=0.1
THEN 'Medium Discount'

ELSE 'Low Discount'
END AS DiscountType

FROM Orders;
##########################################################

#Customers Above Average Revenue
SELECT c.CustomerID,c.CustomerName,SUM(o.Sales) AS TOTALREVENUE
FROM Customers c
JOIN Orders o
ON C.CustomerID=o.CustomerID
GROUP BY c.CustomerID,c.CustomerName
HAVING SUM(o.Sales)>
(SELECT AVG(CustomerRevenue) 
 FROM
 (SELECT SUM(Sales) AS CustomerRevenue
  FROM Orders
  GROUP BY CustomerID
  ) x
);

#Products Never Ordered
SELECT *
FROM Products
WHERE ProductID NOT IN
(SELECT DISTINCT ProductID
 FROM Orders
); 

#Highest Revenue Customer
SELECT *
FROM Customers
WHERE CustomerID=
(SELECT CustomerID
 FROM Orders
 GROUP BY CustomerID
 ORDER BY SUM(Sales) DESC
 LIMIT 1
); 

#######################################
#Top 10 Customers
WITH CustomerRevenue AS
( SELECT CustomerID,SUM(Sales) Revenue
  FROM Orders
  GROUP BY CustomerID
) 
SELECT *
FROM CustomerRevenue
ORDER BY Revenue DESC
LIMIT 10;

#Revenue by Category using CTE
WITH CategoryRevenue AS(
SELECT p.Category,SUM(Sales) Revenue
FROM Orders o
JOIN Products p
ON o.ProductID=p.ProductID
GROUP BY p.Category
)
SELECT *
FROM CategoryRevenue;

###################################################################
#Rank Customers
SELECT CustomerID,SUM(Sales) Revenue,RANK() OVER
(
ORDER BY SUM(Sales) DESC
) as CustomerRank
FROM Orders
GROUP BY CustomerID;

#Top Product in Each Category
WITH TOPPRODUCTCTE AS(
SELECT p.Category,p.ProductName,SUM(o.Quantity) Qty
FROM Orders o
JOIN Products p
ON o.ProductID=p.ProductID
GROUP BY p.Category,p.ProductName
)
SELECT *
FROM
(
SELECT *,
RANK() OVER
(
PARTITION BY Category
ORDER BY Qty DESC
) rnk
FROM TOPPRODUCTCTE
) x
WHERE rnk=1;

#Running Revenue Total
SELECT
OrderDate,
Sales,
SUM(Sales)
OVER
(
ORDER BY OrderDate
) AS RunningRevenue
FROM Orders;

################################################################
#Month-over-Month Growth
WITH MonthlyRevenue AS
(
SELECT
YEAR(OrderDate) yr,
MONTH(OrderDate) mn,
SUM(Sales) Revenue
FROM Orders
GROUP BY yr,mn
)
SELECT *,
LAG(Revenue)
OVER
(
ORDER BY yr,mn
) PreviousRevenue
FROM MonthlyRevenue;

#Top 20% Customers
SELECT *
FROM
(
SELECT
CustomerID,
SUM(Sales) Revenue,
NTILE(5)
OVER
(
ORDER BY SUM(Sales) DESC
) CustomerTier
FROM Orders
GROUP BY CustomerID
) x
WHERE CustomerTier=1;