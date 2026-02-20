--Select all data info--
SELECT *
FROM Chocolate_Sales

SELECT *
FROM Chocolate_Sales
WHERE Date IS NULL


--Total Sales By Country and Product--
SELECT 
Country,
[Product],
Amount AS Total_Revenue
FROM Chocolate_Sales

--Total Revenue by Country--
SELECT
Country,
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales
GROUP BY Country
Order by Total_Revenue DESC

--Total Boxes shipped by Country--
SELECT
Country,
SUM(Boxes_Shipped) AS Total_Boxes_Shipped
FROM
Chocolate_Sales
GROUP BY Country
Order by Total_Boxes_Shipped DESC

--Cost Per Sale where Country is USA and Product is Rasberry Choco--
SELECT 
Country,
[Product],
Amount / Boxes_shipped AS Cost_Per_Sale
FROM
Chocolate_Sales
WHERE Country = 'USA' AND [Product] = 'Raspberry Choco'
ORDER BY Cost_Per_Sale DESC

--Top 10 Sales Person and Product where the country is USA--
--and Total Revenue is less than 30,000
SELECT
TOP(10)
Sales_Person,
[Product],
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales
WHERE Country = 'USA'
GROUP BY Sales_Person, [Product]
HAVING SUM(Amount) < 30000
Order by Total_Revenue DESC


--Top 5 Sales Person and Product where the country is USA--
--and Total Revenue is greater than 3million
SELECT
Sales_Person,
[Product],
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales
WHERE Country = 'USA'
GROUP BY Sales_Person, [Product]
HAVING SUM(Amount) > 10000
Order by Total_Revenue DESC

--Sales per product where product is "Milk Bars"--
SELECT 
[Product],
SUM(Amount) AS Total_Sales_Per_Product
FROM Chocolate_Sales
WHERE [Product] = 'Milk Bars'
GROUP BY [Product]

--Total Boxes_Shipped by Product 
SELECT 
[Product],
SUM(Boxes_Shipped) AS Total_Sales_Per_Product
FROM Chocolate_Sales
GROUP BY [Product]


--Total Revenue by Sales Persons where Product is Milk Bars--
SELECT 
Sales_Person,
[Product],
SUM(Amount) AS Total_Revenue
FROM Chocolate_Sales
WHERE [Product] = 'Milk Bars'
GROUP BY 
Sales_Person,[Product]

--Total Revenue for Sales Person with "r" in their names--
SELECT 
Sales_Person,
[Product],
SUM(Amount) AS Total_Revenue
FROM Chocolate_Sales
WHERE Sales_Person like '%r%'
GROUP BY 
Sales_Person,[Product]

--Average Boxes shipped per Product & Sales Person--
SELECT 
Sales_Person,
[Product],
AVG(Amount / Boxes_Shipped) AS Cost_Per_Product
FROM Chocolate_Sales
GROUP BY 
Sales_Person,[Product]

--Average Boxes shipped per Product--
SELECT 
[Product],
AVG(Boxes_Shipped) AS AVG_Boxes_Per_Product
FROM Chocolate_Sales
GROUP BY 
[Product]

--Average Cost per Product--
SELECT 
[Product],
AVG(Amount / Boxes_Shipped) AS AVG_Cost_Per_Product
FROM Chocolate_Sales
GROUP BY 
[Product]

--Cost per product greater than 50000--
SELECT 
[Product],
SUM(Amount) AS Sales_Per_Product
FROM Chocolate_Sales
GROUP BY 
[Product]
Having SUM(Amount) <= 250000

--Average amount per Product--
SELECT 
[Product],
AVG(Amount) AS AVG_Amount
FROM Chocolate_Sales
GROUP BY 
[Product]


--Yearly and Monthly Sales Revenue--
SELECT
YEAR(Date) AS Year,
MONTH(Date) AS Month,
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month


--Total Revenue generated at previous Month--
SELECT
DATEADD(MONTH, -1, Date) AS Previous_Month,
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales 
GROUP BY DATEADD(MONTH, -1, Date)
ORDER BY SUM(Amount) DESC

--Total Boxshipped by Country--
SELECT
Country,
COUNT(Boxes_Shipped) AS Count_of_Boxes_Shipped
FROM
Chocolate_sales
GROUP BY Country
ORDER BY Count_of_Boxes_Shipped DESC

--Product decreasing in Sales Revenue--
SELECT
TOP 10
[Product],
SUM(Amount) AS Total_Revenue
FROM
Chocolate_sales
GROUP BY [Product]
ORDER BY SUM(Amount) ASC

--Product with low average Quantity--
SELECT
[Product],
AVG(Boxes_Shipped) AS Average_Boxes_Shipped
FROM
Chocolate_sales
GROUP BY [Product]
ORDER BY AVG(Boxes_Shipped) ASC

--Frequency Purchase by Sales Persons--
SELECT
Sales_Person,
COUNT (*) AS Frequency_Purchase
FROM
Chocolate_sales
GROUP BY Sales_Person
ORDER BY COUNT (*) DESC


--Total Sales made by Sales Persons - this shows the highest generating sales person--
SELECT
Sales_Person,
SUM(Amount) AS Total_Revenue
FROM
Chocolate_sales
GROUP BY Sales_Person
ORDER BY SUM(Amount) DESC

--Average Amount of product from Total Revenue-- 
SELECT [Product], SUM(Amount) AS Total_Revenue
FROM Chocolate_sales
GROUP BY [Product]
HAVING SUM(Amount) >= (SELECT AVG(Amount) FROM Chocolate_Sales)


--Ranking product by revenue--
SELECT
[Product],
SUM(Amount) AS Total_Revenue,
RANK() OVER(ORDER BY SUM(Amount)DESC) AS Ranked_Revenue
FROM
Chocolate_sales
GROUP BY [Product]

--This shows
SELECT
Country,
[Product],
SUM(Amount) AS Total_Revenue,
RANK() OVER(PARTITION BY Country ORDER BY SUM(Amount)DESC) AS Ranked_Revenue
FROM
Chocolate_sales
GROUP BY Country, [Product]

--Ranking revenue by month--
SELECT 
MONTH(Date) AS Monthly_Revenue,
SUM(Amount) AS Total_Revenue,
RANK() OVER(ORDER BY SUM(Amount)DESC) AS Ranked_Month
FROM
Chocolate_Sales
GROUP BY MONTH(Date)

--Ranked Monthly Revenue by countries
SELECT 
DISTINCT Country,
MONTH(Date) AS Sales_Month,
SUM(Amount) AS Total_Revenue,
RANK() OVER(PARTITION BY Country ORDER BY SUM(Amount)DESC) AS Ranked_Countries_by_Revenue
FROM
Chocolate_Sales
GROUP BY MONTH(Date), Country


--Contribution Percentage of each product to total revenue--
SELECT
[Product],
SUM(Amount) AS Total_Revenue,
(SUM(Amount) * 100.0 / 
(SELECT SUM(Amount) 
FROM 
Chocolate_Sales)
    ) AS Contribution_Percentage
FROM Chocolate_Sales
GROUP BY [Product]
ORDER BY Contribution_Percentage,Total_Revenue


--Using CTE to find the Monthly and Yearly Revenue--
WITH Monthly_sales AS
(
SELECT 
MONTH(Date) AS SalesMonth,
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales
GROUP BY 
MONTH(Date)
)
SELECT *
FROM Monthly_sales
ORDER BY SalesMonth


--This query gives you a straightforward view of each chocolate product's total revenue 
--sorted from highest to lowest earners. 
--It's your basic product performance report that shows which products are generating the most sales dollars, 
--helping you quickly spot your top sellers and weakest performers at a glance.

WITH Product_Revenue AS
(
SELECT [Product],
SUM(Amount) AS Total_Revenue
FROM
Chocolate_sales
GROUP BY [Product]
)
SELECT *
FROM Product_Revenue
ORDER BY Total_Revenue DESC

--This is the Product Revenue before Average
--This query identifies your above-average performing chocolate products by first calculating each product's total revenue, 
--then filtering to show only those products that exceeded the average revenue across all products. 
--It's a great way to focus on your stronger performers and 
--see which products are pulling their weight compared to the overall portfolio average.

WITH Product_Revenue AS
(
SELECT [Product],
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales
GROUP BY [Product]
)
SELECT *
FROM Product_Revenue
WHERE Total_Revenue >
(SELECT AVG(Total_Revenue) FROM Product_Revenue)
ORDER BY Total_Revenue DESC

--Ranked Revenue by Product- This query first aggregates total revenue per product, 
--then ranks products from highest to lowest revenue using a window function. 
--It helps quickly identify top-performing and underperforming products based on revenue contribution.

WITH Product_Revenue AS
(
SELECT [Product],
SUM(Amount) AS Total_Revenue
FROM
Chocolate_Sales
GROUP BY [Product]
)
SELECT 
[Product],
Total_Revenue,
RANK() OVER(ORDER BY Total_Revenue DESC) AS Revenue_Rank
FROM 
Product_Revenue

WITH Product_Revenue AS (
    SELECT [Product],
    SUM(Amount) AS Total_Revenue
    FROM Chocolate_Sales
    GROUP BY [Product]
)
SELECT
    [Product],
    Total_Revenue,
    CASE
        WHEN Total_Revenue > (SELECT AVG(Total_Revenue) 
                              FROM Product_Revenue)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS Performance_Category
FROM Product_Revenue
ORDER BY Total_Revenue DESC;