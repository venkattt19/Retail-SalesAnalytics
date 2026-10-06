CREATE TABLE RetailSales
(
	OrderID VARCHAR(20) PRIMARY KEY,
	OrderDate DATE,
	ShipDate Date,
	ShipMode VARCHAR(20) NOT NULL,
	CustomerID VARCHAR(20) NOT NULL,
	CustomerName VARCHAR(50) NOT NULL,
	Segment VARCHAR(20),
	Country VARCHAR(50),
	City VARCHAR(50) NOT NULL,
	State VARCHAR(50),
	Region VARCHAR(20),
	ProductID VARCHAR(20) NOT NULL,
	Category VARCHAR(20),
	SubCategory VARCHAR(20),
	ProductName VARCHAR(100) NOT NULL,
	Sales DECIMAL(10,2),
	Quantity INT NOT NULL,
	Discount DECIMAL(10,2),
	Profit DECIMAL(10,2)
)

--Check for Duplicate Orders
SELECT
OrderID,
COUNT(*) AS totalRows
FROM RetailSales
GROUP BY OrderID
HAVING COUNT(*) > 1;

--Check for Missing Values
SELECT
    COUNT(CustomerName) AS CustomerName_Nulls,
    COUNT(Sales) AS Sales_Nulls,
    COUNT(Profit) AS Profit_Nulls
FROM RetailSales;

--Validate Business Rules
SELECT
Sales
FROM RetailSales
WHERE Sales < 0

SELECT
Quantity
FROM RetailSales
WHERE Quantity <= 0

SELECT
Discount
FROM RetailSales
WHERE Discount < 0 OR Discount > 1

--Total Sales
SELECT
SUM(Sales) AS TotalSales
FROM RetailSales

--Total Profit
SELECT
SUM(Profit) AS TotalProfit
FROM RetailSales

--Top 5 Most Profitable Products
SELECT TOP 5
ProductName,
SUM(Profit) AS TotalProfit
FROM RetailSales
GROUP BY ProductName
ORDER BY SUM(Profit) DESC;

--Which category has the highest sales?
SELECT
Category,
SUM(Sales) AS TotalSales
FROM RetailSales
GROUP BY Category
ORDER BY TotalSales DESC;

--Which Region has the highest profit?
SELECT
Region,
SUM(Profit) AS TotalProfit
FROM RetailSales
GROUP BY Region
ORDER BY TotalProfit DESC;

--Top 10 Customers
SELECT
TOP 10 CustomerName,
SUM(Sales) AS TotalSales
FROM RetailSales
GROUP BY CustomerName
ORDER BY TotalSales DESC;

--Sales by Year 
SELECT
YEAR(OrderDate) AS yearSale,
SUM(Sales) AS TotalSales
FROM RetailSales
GROUP BY YEAR(OrderDate)
ORDER BY yearSale

--Monthly Sales Trend
SELECT
YEAR(OrderDate) AS yearSale,
MONTH(OrderDate) AS MonthlySale,
SUM(Sales)AS TotalSales
FROM RetailSales
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    YearSale,
    MonthlySale;

--11) Which cities generate the highest sales?
SELECT TOP 5
	City,
	SUM(Sales) AS TotalSales
FROM RetailSales
GROUP BY City
ORDER BY TotalSales DESC;

--Discount Category
SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS DiscountCategory,
    COUNT(*) AS TotalOrders
FROM RetailSales
GROUP BY
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END;

--"Which discount category generates the highest sales?"
SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS DiscountCategory,
SUM(Sales) AS TotalSales
FROM RetailSales
GROUP BY 
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY TotalSales DESC;

--"Which discount category generates the highest profit?
SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS DiscountCategory,
SUM(Profit) AS TotalProfit
FROM RetailSales
GROUP BY 
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY TotalProfit DESC;

--How many orders fall into each discount category?
SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS DiscountCategory,
COUNT(*) AS TotalOrders
FROM RetailSales
GROUP BY 
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY TotalOrders DESC;

--Top 3 customers in each region based on total sales.
WITH CTE_TotalSales AS
(
SELECT
    CustomerName,
    Region,
    SUM(Sales) AS TotalSales,
    RANK() OVER(PARTITION BY Region ORDER BY SUM(Sales) DESC) AS CustomerRank
FROM RetailSales
    GROUP BY CustomerName,
             Region
) 
SELECT
    CustomerName,
    Region,
    TotalSales,
    CustomerRank
FROM CTE_TotalSales
    WHERE CustomerRank <=3
    ORDER BY Region,CustomerRank;

--I only want to know the best-selling product in each category.
WITH CTE_Product_Category AS
(
SELECT
    Category,
    ProductName,
    SUM(Sales) AS totalSales,
    Rank() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS ProductRank
FROM RetailSales
    GROUP BY Category,
             ProductName
)
SELECT 
    Category,
    ProductName,
    TotalSales,
    ProductRank
FROM CTE_Product_Category
    WHERE ProductRank=1
    ORDER BY CateGory

--TotalSales by product(best selling) and category 
WITH CTE_Total_Sales AS
(
SELECT
    Category,
    ProductName,
    SUM(Sales) AS TotalSales,
    RANK() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS ProductRank
FROM RetailSales
    GROUP BY ProductName,
         Category
         )
SELECT 
    Category,
    ProductName,
    TotalSales,
    ProductRank
FROM CTE_Total_Sales
    WHERE ProductRank = 1
    ORDER BY Category,
         TotalSales DESC

--I want to understand how each customer's spending changes over time.
WITH CTE_SaleDifference AS
(
SELECT
    CustomerName,
    OrderDate,
    Sales AS CurrentSales,
    LAG(Sales,1,0) OVER(PARTITION BY CustomerName ORDER BY OrderDate) AS PreviousSales
FROM RetailSales
)

SELECT
    CustomerName,
    OrderDate,
    CurrentSales,
    PreviousSales,
    CurrentSales - PreviousSales AS SalesDifference
FROM CTE_SaleDifference
    ORDER BY CustomerName,OrderDate ASC;

--current and previous sales
WITH CTE_Sales_Status AS
(
SELECT
CustomerName,
OrderDate,
Sales AS CurrentSales,
LAG(Sales) OVER(PARTITION BY CustomerName ORDER BY OrderDate) AS PreviousSales
FROM RetailSales
)
    SELECT
    CustomerName,
    OrderDate,
    CurrentSales,
    PreviousSales,
    CASE
        WHEN CurrentSales > PreviousSales THEN 'Increased'
        WHEN CurrentSales < PreviousSales THEN 'Decreased'
        WHEN PreviousSales IS NULL THEN 'First Order'
        ELSE 'No Change'
    END AS SalesStatus
FROM CTE_Sales_Status
ORDER BY CustomerName,
         OrderDate ASC;

-------------------
WITH CTE_RunningTotalSales AS 
(
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(Sales) AS MonthlySales
FROM RetailSales
GROUP BY YEAR(OrderDate),MONTH(OrderDate)
)
SELECT
    Year,
    Month,
    MonthlySales,
    SUM(MonthlySales) OVER(PARTITION BY YEAR ORDER BY MONTH) AS RunningTotal
FROM CTE_RunningTotalSales
ORDER BY Year,Month

--Show Month-over-Month (MoM) Sales Growth.

--Year
--Month
--Monthly Sales
--Previous Month Sales
--Sales Difference
WITH CTE_MonthlySales AS
(
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(Sales) AS MonthlySales
FROM RetailSales
GROUP BY YEAR(OrderDate),MONTH(OrderDate)
)
,CTE_PreviousMonthSale AS 
(
SELECT
    Year,
    Month,
    MonthlySales,
    LAG(MonthlySales,1,0) OVER(ORDER BY YEAR,Month) AS PreviousMonthSales
FROM CTE_MonthlySales
)
SELECT
    Year,
    Month,
    MonthlySales,
    PreviousMonthSales,
    MonthlySales - PreviousMonthSales AS SalesDifference
FROM CTE_PreviousMonthSale
ORDER BY Year,Month;



---"Sales were $12,000 last month and $15,000 this month. What is the growth %?"

WITH CTE_MonthlySales AS
(
SELECT
    YEAR(OrderDate) AS Year,
    MONTH(OrderDate) AS Month,
    SUM(Sales) AS MonthlySales
FROM RetailSales
GROUP BY YEAR(OrderDate),MONTH(OrderDate)
)
,CTE_PreviousMonthSale AS 
(
SELECT
    Year,
    Month,
    MonthlySales,
    NULLIF(LAG(MonthlySales,1,0) OVER(ORDER BY YEAR,Month),0) AS PreviousMonthSales
FROM CTE_MonthlySales
)
SELECT
    Year,
    Month,
    MonthlySales,
    PreviousMonthSales,
    ((MonthlySales - PreviousMonthSales)
 / PreviousMonthSales) * 100 AS MoMGrowthPercent
FROM CTE_PreviousMonthSale
ORDER BY Year,Month;

---Top 3 Products by Profit in each Category.
WITH CTE_ProductProfit AS
(
SELECT
ProductName,
Category,
SUM(Profit) AS TotalProfit
FROM RetailSales
GROUP BY ProductName,Category
)
,CTE_ProductRank AS
(
SELECT 
ProductName,
Category,
TotalProfit,
RANK() OVER(PARTITION BY Category ORDER BY TotalProfit DESC) AS RankProduct
FROM CTE_ProductProfit
)
SELECT
ProductName,
Category,
TotalProfit,
RankProduct
FROM CTE_ProductRank
WHERE RankProduct<=3
ORDER BY Category,RankProduct

--Identify the Bottom 3 Products by Profit in each Category.
WITH CTE_ProductProfit AS
(
SELECT
ProductName,
Category,
SUM(Profit) AS TotalProfit
FROM RetailSales
GROUP BY ProductName,Category
)
,CTE_ProductRank AS
(
SELECT 
ProductName,
Category,
TotalProfit,
RANK() OVER(PARTITION BY Category ORDER BY TotalProfit ASC) AS RankProduct
FROM CTE_ProductProfit
)
SELECT
ProductName,
Category,
TotalProfit,
RankProduct
FROM CTE_ProductRank
WHERE RankProduct<=3
ORDER BY Category,RankProduct

--Find each customer's first purchase date and latest purchase date.
SELECT
CustomerID,
CustomerName,
MIN(OrderDate) AS First_purchase_date,
MAX(OrderDate) AS Last_purchase_date
FROM RetailSales
GROUP BY CustomerID,
         CustomerName
ORDER BY CustomerID

--Customer Purchase Frequency
SELECT
    CustomerID,
    CustomerName,
    COUNT(OrderID) AS TotalOrders
FROM RetailSales
    GROUP BY CustomerID,
             CustomerName
    ORDER BY COUNT(OrderID) DESC;

--Average Days Between Order Date and Ship Date for each ShipMode.
SELECT
    ShipMode,
    AVG(DATEDIFF(DAY,OrderDate,ShipDate)) AS AverageShippingDays
FROM RetailSales
    GROUP BY ShipMode
    ORDER BY AverageShippingDays DESC;

--Calculate Customer Lifetime Value (Basic)
SELECT
CustomerID,
CustomerName,
SUM(Sales) AS Life_Time_Sales,
SUM(Profit) AS Life_Time_Profit,
COUNT(OrderID) AS Life_Time_Orders
FROM RetailSales
GROUP BY CustomerID,
CustomerName
ORDER BY Life_Time_Sales DESC;

--Calculate Profit Margin for each Category.
WITH CTE_Profit_margin AS
(
SELECT
Category,
SUM(Sales) AS TotalSales,
SUM(Profit) AS TotalProfit
FROM RetailSales
GROUP BY Category
)
SELECT
Category,
TotalSales,
TotalProfit,
(TotalProfit * 100.0) / NULLIF(TotalSales, 0) AS ProfitMargin
FROM CTE_Profit_margin
ORDER BY ProfitMargin DESC;

--Find each Region's contribution to Total Sales
WITH CTE_RegionSale AS
(
SELECT
Region,
SUM(Sales) AS RegionSales
FROM RetailSales 
GROUP BY Region
)
, CTE_TotalSale AS
(
SELECT
Region,
RegionSales,
SUM(RegionSales) OVER() AS TotalSales
FROM CTE_RegionSale
)
SELECT
Region,
RegionSales,
(RegionSales * 100.0) / NULLIF(TotalSales, 0) AS ContributionPercent
FROM CTE_TotalSale
ORDER BY RegionSales DESC;

--Calculate a Rolling 3-Month Sales Total
WITH CTE_MonthlySale AS
(
SELECT
YEAR(OrderDate) AS Year,
MONTH(OrderDate) AS Month,
SUM(Sales) AS MonthlySales
FROM RetailSales
GROUP BY YEAR(OrderDate),
         MONTH(OrderDate)
)
SELECT
Year,
Month,
MonthlySales,
SUM(MonthlySales)
OVER(ORDER BY Year,Month
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
) AS Rolling_3_MonthSales
FROM CTE_MonthlySale

--Calculate Year-over-Year (YoY) Sales Growth.
WITH CTE_YearlySales AS
(
SELECT
    YEAR(OrderDate) AS Year,
    SUM(Sales) AS YearlySales
FROM RetailSales
    GROUP BY YEAR(OrderDate)
),
CTE_PreviousYearlySales AS
(
SELECT
    Year,
    YearlySales,
    LAG(YearlySales,1,0) OVER(ORDER BY Year) AS PreviousYearlySales
FROM CTE_YearlySales
)

SELECT 
    Year,
    YearlySales,
    PreviousYearlySales,
    ((YearlySales - PreviousYearlySales) * 100.0)
    /
    NULLIF(PreviousYearlySales, 0) AS YoY_GrowthPercent
FROM CTE_PreviousYearlySales;

--Find customers who have not placed an order in the last 90 days.
--CustomerID
--CustomerName
--LastOrderDate
--DaysSinceLastOrder
WITH CTE_LastOrderDate AS
(
SELECT
    CustomerID,
    CustomerName,
    MAX(OrderDate) AS LastOrderDate
FROM RetailSales
    GROUP BY CustomerID,
         CustomerName
)

,CTE_DaysSinceLastOrder AS
(
SELECT
    CustomerID,
    CustomerName,
    LastOrderDate,
    DATEDIFF(DAY,LastOrderDate,GETDATE()) AS DaysSinceLastOrder
FROM CTE_LastOrderDate
)

SELECT
    CustomerID,
    CustomerName,
    LastOrderDate,
    DaysSinceLastOrder
FROM CTE_DaysSinceLastOrder
    WHERE DaysSinceLastOrder > 90

--Segment customers based on their Lifetime Sales
--CustomerID
--CustomerName
--LifetimeSales
--CustomerSegment
WITH CTE_LifeTimeSales AS
(
SELECT
    CustomerID,
    CustomerName,
    SUM(Sales) AS LifeTimeSales
 FROM RetailSales
    GROUP BY CustomerID,
             CustomerName
)
SELECT
    CustomerID,
    CustomerName,
    LifeTimeSales,
    CASE
        WHEN LifeTimeSales >= 10000 THEN 'GOLD'
        WHEN LifeTimeSales >=5000 THEN 'SILVER'
        ELSE 'BRONZE'
    END AS CustomerSegment
FROM CTE_LifeTimeSales
    ORDER BY CustomerID ASC;

--Find the Best and Worst Performing Region based on Total Sales.
WITH CTE_TotalSales AS
(
SELECT
    Region,
    SUM(Sales) AS TotalSales
FROM RetailSales
    GROUP BY Region
),

CTE_RankTotalSales AS
(
SELECT
    Region,
    TotalSales,
    RANK() OVER(ORDER BY TotalSales DESC) AS RankDesc,
    RANK() OVER(ORDER BY TotalSales ASC) AS RankAsc
from CTE_TotalSales
)

SELECT
    Region,
    TotalSales,
    RankDesc,
    RankAsc,
    CASE
        WHEN RankDesc = 1 THEN 'Best Region'
        WHEN RankAsc = 1 THEN 'Worst Region'
        ELSE 'Average'
    END AS Performance
FROM CTE_RankTotalSales
    ORDER BY TotalSales DESC;


--Which day of the week generates the highest sales?
SELECT
    DATENAME(WEEKDAY,OrderDate) AS WeekDay,
    DATEPART(WEEKDAY,OrderDate) AS WeekNumber,
    SUM(Sales) AS TotalSales
FROM RetailSales
    GROUP BY DATENAME(WEEKDAY,OrderDate),
             DATEPART(WEEKDAY,OrderDate)
    ORDER BY WeekNumber;

--The CEO wants a report showing the Top 3 Customers in each Region based on Lifetime Sales.
WITH CTE_LifeTimeSales AS
(
SELECT
    CustomerID,
    CustomerName,
    Region,
    SUM(Sales) AS LifeTimeSales
FROM RetailSales
GROUP BY CustomerID,
         Region,
         CustomerName
),

CTE_TopCustomers AS
(
SELECT
    CustomerID,
    CustomerName,
    Region,
    LifeTimeSales,
    RANK() 
    OVER(PARTITION BY Region ORDER BY LifeTimeSales DESC) AS CustomerRank
FROM CTE_LifeTimeSales
) 

SELECT
    CustomerID,
    CustomerName,
    Region,
    LifeTimeSales,
    CustomerRank
FROM CTE_TopCustomers
    WHERE CustomerRank <=3
    ORDER BY Region,CustomerRank


