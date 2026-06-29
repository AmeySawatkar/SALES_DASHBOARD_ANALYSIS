/*
================================================================================
  PROJECT     : Sales Dashboard Analysis
  DATABASE    : sales_dashboard_analysis
  TABLE       : superstore
  DEVELOPER   : Amey Kishor Sawatkar
  INTERNSHIP  : SkillInfyTech IT Solutions Pvt. Ltd.
  DATABASE VER: MySQL 8.0
  TOOL        : MySQL Workbench
  PURPOSE     : Professional SQL Analysis Script for Power BI Dashboard
================================================================================
*/

USE sales_dashboard_analysis;

/* ============================================================
   SECTION 1: DATA VALIDATION
   ============================================================ */

-- Total number of records in the superstore table
SELECT
    COUNT(*) AS Total_Records
FROM superstore;

-- Check for NULL values in critical columns
SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END)       AS Null_Order_ID,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END)     AS Null_Order_Date,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END)    AS Null_Customer_ID,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END)          AS Null_Sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END)         AS Null_Profit,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END)       AS Null_Quantity,
    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END)       AS Null_Discount
FROM superstore;

-- Count of distinct categories and sub-categories
SELECT
    COUNT(DISTINCT Category)     AS Distinct_Categories,
    COUNT(DISTINCT Sub_Category) AS Distinct_Sub_Categories
FROM superstore;

-- Date range of orders in the dataset
SELECT
    MIN(Order_Date) AS Earliest_Order_Date,
    MAX(Order_Date) AS Latest_Order_Date
FROM superstore;

-- Count of unique customers, orders, and products
SELECT
    COUNT(DISTINCT Customer_ID)  AS Unique_Customers,
    COUNT(DISTINCT Order_ID)     AS Unique_Orders,
    COUNT(DISTINCT Product_ID)   AS Unique_Products
FROM superstore;

/* ============================================================
   SECTION 2: KPI ANALYSIS
   ============================================================ */

-- Overall KPIs: Total Sales, Total Profit, Total Quantity, Profit Margin
SELECT
    ROUND(SUM(Sales), 2)                              AS Total_Sales,
    ROUND(SUM(Profit), 2)                             AS Total_Profit,
    SUM(Quantity)                                     AS Total_Quantity,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)       AS Profit_Margin_Pct,
    COUNT(DISTINCT Order_ID)                          AS Total_Orders,
    COUNT(DISTINCT Customer_ID)                       AS Total_Customers
FROM superstore;

-- Average order value
SELECT
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2)  AS Avg_Order_Value
FROM superstore;

-- Average profit per order
SELECT
    ROUND(SUM(Profit) / COUNT(DISTINCT Order_ID), 2) AS Avg_Profit_Per_Order
FROM superstore;

/* ============================================================
   SECTION 3: SALES ANALYSIS
   ============================================================ */

-- Total Sales by Region
SELECT
    Region,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Total Sales by Category
SELECT
    Category,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    SUM(Quantity)           AS Total_Quantity
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Total Sales by Segment
SELECT
    Segment,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- Top 10 States by Sales
SELECT
    State,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit
FROM superstore
GROUP BY State
ORDER BY Total_Sales DESC
LIMIT 10;

/* ============================================================
   SECTION 4: PRODUCT ANALYSIS
   ============================================================ */

-- Top 10 Best-Selling Products by Sales
SELECT
    Product_ID,
    Product_Name,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    SUM(Quantity)           AS Total_Quantity_Sold
FROM superstore
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Top 10 Most Profitable Products
SELECT
    Product_ID,
    Product_Name,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Sales), 2)    AS Total_Sales
FROM superstore
GROUP BY Product_ID, Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;

-- Bottom 10 Products by Sales
SELECT
    Product_ID,
    Product_Name,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    SUM(Quantity)           AS Total_Quantity_Sold
FROM superstore
GROUP BY Product_ID, Product_Name
ORDER BY Total_Sales ASC
LIMIT 10;

-- Bottom 10 Products by Profit (Loss-Making Products)
SELECT
    Product_ID,
    Product_Name,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Sales), 2)    AS Total_Sales
FROM superstore
GROUP BY Product_ID, Product_Name
ORDER BY Total_Profit ASC
LIMIT 10;

/* ============================================================
   SECTION 5: CATEGORY ANALYSIS
   ============================================================ */

-- Sales and Profit by Category and Sub-Category
SELECT
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2)                            AS Total_Sales,
    ROUND(SUM(Profit), 2)                           AS Total_Profit,
    SUM(Quantity)                                   AS Total_Quantity,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)     AS Profit_Margin_Pct
FROM superstore
GROUP BY Category, Sub_Category
ORDER BY Category, Total_Sales DESC;

-- Sub-Category with Highest Profit Margin
SELECT
    Sub_Category,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)     AS Profit_Margin_Pct,
    ROUND(SUM(Sales), 2)                            AS Total_Sales,
    ROUND(SUM(Profit), 2)                           AS Total_Profit
FROM superstore
GROUP BY Sub_Category
HAVING SUM(Sales) > 0
ORDER BY Profit_Margin_Pct DESC;

-- Count of Orders per Category
SELECT
    Category,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(*) AS Total_Line_Items
FROM superstore
GROUP BY Category
ORDER BY Total_Orders DESC;

/* ============================================================
   SECTION 6: CUSTOMER ANALYSIS
   ============================================================ */

-- Top 10 Customers by Total Sales
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY Customer_ID, Customer_Name, Segment
ORDER BY Total_Sales DESC
LIMIT 10;

-- Bottom 10 Customers by Total Sales
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY Customer_ID, Customer_Name, Segment
ORDER BY Total_Sales ASC
LIMIT 10;

-- Top 10 Customers by Profit
SELECT
    Customer_ID,
    Customer_Name,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Sales), 2)    AS Total_Sales
FROM superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY Total_Profit DESC
LIMIT 10;

-- Customers with Most Frequent Orders
SELECT
    Customer_ID,
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Order_Frequency,
    ROUND(SUM(Sales), 2)    AS Total_Sales
FROM superstore
GROUP BY Customer_ID, Customer_Name
ORDER BY Order_Frequency DESC
LIMIT 10;

/* ============================================================
   SECTION 7: REGIONAL ANALYSIS
   ============================================================ */

-- Sales, Profit, and Orders by Region
SELECT
    Region,
    ROUND(SUM(Sales), 2)                            AS Total_Sales,
    ROUND(SUM(Profit), 2)                           AS Total_Profit,
    SUM(Quantity)                                   AS Total_Quantity,
    COUNT(DISTINCT Order_ID)                        AS Total_Orders,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)     AS Profit_Margin_Pct
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Region-wise Category Performance
SELECT
    Region,
    Category,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit
FROM superstore
GROUP BY Region, Category
ORDER BY Region, Total_Sales DESC;

/* ============================================================
   SECTION 8: STATE ANALYSIS
   ============================================================ */

-- All States ranked by Sales
SELECT
    State,
    Region,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY State, Region
ORDER BY Total_Sales DESC;

-- Top 5 States by Profit
SELECT
    State,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Sales), 2)    AS Total_Sales
FROM superstore
GROUP BY State
ORDER BY Total_Profit DESC
LIMIT 5;

-- Bottom 5 States by Profit (Loss-Making States)
SELECT
    State,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Sales), 2)    AS Total_Sales
FROM superstore
GROUP BY State
ORDER BY Total_Profit ASC
LIMIT 5;

/* ============================================================
   SECTION 9: SEGMENT ANALYSIS
   ============================================================ */

-- Segment-wise KPIs: Sales, Profit, Quantity, Orders
SELECT
    Segment,
    ROUND(SUM(Sales), 2)                            AS Total_Sales,
    ROUND(SUM(Profit), 2)                           AS Total_Profit,
    SUM(Quantity)                                   AS Total_Quantity,
    COUNT(DISTINCT Order_ID)                        AS Total_Orders,
    COUNT(DISTINCT Customer_ID)                     AS Unique_Customers,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)     AS Profit_Margin_Pct
FROM superstore
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- Segment and Category Cross Analysis
SELECT
    Segment,
    Category,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit
FROM superstore
GROUP BY Segment, Category
ORDER BY Segment, Total_Sales DESC;

/* ============================================================
   SECTION 10: SHIPPING ANALYSIS
   ============================================================ */

-- Sales and Orders by Ship Mode
SELECT
    Ship_Mode,
    COUNT(DISTINCT Order_ID)                        AS Total_Orders,
    ROUND(SUM(Sales), 2)                            AS Total_Sales,
    ROUND(SUM(Profit), 2)                           AS Total_Profit,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 2)  AS Avg_Ship_Days
FROM superstore
GROUP BY Ship_Mode
ORDER BY Total_Orders DESC;

-- Average Shipping Days by Region and Ship Mode
SELECT
    Region,
    Ship_Mode,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 2)  AS Avg_Ship_Days,
    COUNT(DISTINCT Order_ID)                        AS Total_Orders
FROM superstore
GROUP BY Region, Ship_Mode
ORDER BY Region, Avg_Ship_Days;

/* ============================================================
   SECTION 11: DISCOUNT ANALYSIS
   ============================================================ */

-- Impact of Discount on Profit
SELECT
    CASE
        WHEN Discount = 0           THEN 'No Discount'
        WHEN Discount > 0
         AND Discount <= 0.1        THEN '1% - 10%'
        WHEN Discount > 0.1
         AND Discount <= 0.2        THEN '11% - 20%'
        WHEN Discount > 0.2
         AND Discount <= 0.3        THEN '21% - 30%'
        WHEN Discount > 0.3
         AND Discount <= 0.5        THEN '31% - 50%'
        ELSE 'Above 50%'
    END                             AS Discount_Band,
    COUNT(*)                        AS Total_Line_Items,
    ROUND(SUM(Sales), 2)            AS Total_Sales,
    ROUND(SUM(Profit), 2)           AS Total_Profit,
    ROUND(AVG(Discount) * 100, 2)   AS Avg_Discount_Pct
FROM superstore
GROUP BY Discount_Band
ORDER BY Avg_Discount_Pct;

-- Average Discount by Category
SELECT
    Category,
    ROUND(AVG(Discount) * 100, 2)  AS Avg_Discount_Pct,
    ROUND(SUM(Sales), 2)           AS Total_Sales,
    ROUND(SUM(Profit), 2)          AS Total_Profit
FROM superstore
GROUP BY Category
ORDER BY Avg_Discount_Pct DESC;

-- Sub-Categories with High Discounts and Low Profit
SELECT
    Sub_Category,
    ROUND(AVG(Discount) * 100, 2)  AS Avg_Discount_Pct,
    ROUND(SUM(Profit), 2)          AS Total_Profit,
    ROUND(SUM(Sales), 2)           AS Total_Sales
FROM superstore
GROUP BY Sub_Category
HAVING AVG(Discount) > 0.2
ORDER BY Total_Profit ASC;

/* ============================================================
   SECTION 12: MONTHLY SALES TREND
   ============================================================ */

-- Monthly Sales and Profit Trend
SELECT
    YEAR(Order_Date)                AS Order_Year,
    MONTH(Order_Date)               AS Order_Month,
    ROUND(SUM(Sales), 2)            AS Monthly_Sales,
    ROUND(SUM(Profit), 2)           AS Monthly_Profit,
    SUM(Quantity)                   AS Monthly_Quantity,
    COUNT(DISTINCT Order_ID)        AS Monthly_Orders
FROM superstore
GROUP BY Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;

/* ============================================================
   SECTION 13: QUARTERLY SALES TREND
   ============================================================ */

-- Quarterly Sales and Profit Trend
SELECT
    YEAR(Order_Date)                AS Order_Year,
    QUARTER(Order_Date)             AS Order_Quarter,
    ROUND(SUM(Sales), 2)            AS Quarterly_Sales,
    ROUND(SUM(Profit), 2)           AS Quarterly_Profit,
    SUM(Quantity)                   AS Quarterly_Quantity,
    COUNT(DISTINCT Order_ID)        AS Quarterly_Orders
FROM superstore
GROUP BY Order_Year, Order_Quarter
ORDER BY Order_Year, Order_Quarter;

/* ============================================================
   SECTION 14: YEARLY SALES TREND
   ============================================================ */

-- Yearly Sales and Profit Trend
SELECT
    YEAR(Order_Date)                                AS Order_Year,
    ROUND(SUM(Sales), 2)                            AS Yearly_Sales,
    ROUND(SUM(Profit), 2)                           AS Yearly_Profit,
    SUM(Quantity)                                   AS Yearly_Quantity,
    COUNT(DISTINCT Order_ID)                        AS Yearly_Orders,
    COUNT(DISTINCT Customer_ID)                     AS Yearly_Customers,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)     AS Profit_Margin_Pct
FROM superstore
GROUP BY Order_Year
ORDER BY Order_Year;

/* ============================================================
   SECTION 15: PROFIT ANALYSIS
   ============================================================ */

-- Most Profitable Sub-Categories
SELECT
    Sub_Category,
    ROUND(SUM(Profit), 2)                           AS Total_Profit,
    ROUND(SUM(Sales), 2)                            AS Total_Sales,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)     AS Profit_Margin_Pct
FROM superstore
GROUP BY Sub_Category
ORDER BY Total_Profit DESC;

-- Profitable Orders Count vs Loss Orders Count
SELECT
    COUNT(CASE WHEN Profit > 0 THEN 1 END)  AS Profitable_Line_Items,
    COUNT(CASE WHEN Profit < 0 THEN 1 END)  AS Loss_Line_Items,
    COUNT(CASE WHEN Profit = 0 THEN 1 END)  AS Breakeven_Line_Items,
    COUNT(*)                                AS Total_Line_Items
FROM superstore;

-- Profit by Region and Category
SELECT
    Region,
    Category,
    ROUND(SUM(Profit), 2)                           AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2)     AS Profit_Margin_Pct
FROM superstore
GROUP BY Region, Category
ORDER BY Total_Profit DESC;

/* ============================================================
   SECTION 16: LOSS ANALYSIS
   ============================================================ */

-- Products generating a net loss
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    SUM(Quantity)           AS Total_Quantity
FROM superstore
GROUP BY Product_ID, Product_Name, Category, Sub_Category
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 15;

-- States with Net Loss
SELECT
    State,
    Region,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY State, Region
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC;

/* ============================================================
   SECTION 17: TOP CUSTOMERS
   ============================================================ */

-- Top 20 Customers by Total Revenue (Sales)
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    State,
    Region,
    ROUND(SUM(Sales), 2)        AS Total_Sales,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    SUM(Quantity)               AS Total_Quantity,
    COUNT(DISTINCT Order_ID)    AS Total_Orders
FROM superstore
GROUP BY Customer_ID, Customer_Name, Segment, State, Region
ORDER BY Total_Sales DESC
LIMIT 20;

/* ============================================================
   SECTION 18: BOTTOM CUSTOMERS
   ============================================================ */

-- Bottom 20 Customers by Total Revenue (Sales)
SELECT
    Customer_ID,
    Customer_Name,
    Segment,
    State,
    Region,
    ROUND(SUM(Sales), 2)        AS Total_Sales,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    COUNT(DISTINCT Order_ID)    AS Total_Orders
FROM superstore
GROUP BY Customer_ID, Customer_Name, Segment, State, Region
ORDER BY Total_Sales ASC
LIMIT 20;

/* ============================================================
   SECTION 19: TOP PRODUCTS
   ============================================================ */

-- Top 15 Products by Revenue
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    SUM(Quantity)           AS Total_Quantity
FROM superstore
GROUP BY Product_ID, Product_Name, Category, Sub_Category
ORDER BY Total_Sales DESC
LIMIT 15;

-- Top 15 Products by Quantity Sold
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    SUM(Quantity)           AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2)    AS Total_Sales
FROM superstore
GROUP BY Product_ID, Product_Name, Category, Sub_Category
ORDER BY Total_Quantity_Sold DESC
LIMIT 15;

/* ============================================================
   SECTION 20: BOTTOM PRODUCTS
   ============================================================ */

-- Bottom 15 Products by Revenue
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2)    AS Total_Sales,
    ROUND(SUM(Profit), 2)   AS Total_Profit,
    SUM(Quantity)           AS Total_Quantity
FROM superstore
GROUP BY Product_ID, Product_Name, Category, Sub_Category
ORDER BY Total_Sales ASC
LIMIT 15;

/* ============================================================
   SECTION 21: BUSINESS INSIGHTS QUERIES
   ============================================================ */

-- Cities contributing to highest sales (Top 10)
SELECT
    City,
    State,
    Region,
    ROUND(SUM(Sales), 2)        AS Total_Sales,
    ROUND(SUM(Profit), 2)       AS Total_Profit,
    COUNT(DISTINCT Order_ID)    AS Total_Orders
FROM superstore
GROUP BY City, State, Region
ORDER BY Total_Sales DESC
LIMIT 10;

-- Ship Mode preference by Segment
SELECT
    Segment,
    Ship_Mode,
    COUNT(DISTINCT Order_ID)    AS Total_Orders,
    ROUND(SUM(Sales), 2)        AS Total_Sales
FROM superstore
GROUP BY Segment, Ship_Mode
ORDER BY Segment, Total_Orders DESC;

-- Average Sales and Profit per Customer by Segment
SELECT
    Segment,
    COUNT(DISTINCT Customer_ID)                                     AS Total_Customers,
    ROUND(SUM(Sales) / COUNT(DISTINCT Customer_ID), 2)             AS Avg_Sales_Per_Customer,
    ROUND(SUM(Profit) / COUNT(DISTINCT Customer_ID), 2)            AS Avg_Profit_Per_Customer,
    ROUND(COUNT(DISTINCT Order_ID) / COUNT(DISTINCT Customer_ID), 2) AS Avg_Orders_Per_Customer
FROM superstore
GROUP BY Segment
ORDER BY Avg_Sales_Per_Customer DESC;

-- Year-over-Year Sales Growth
SELECT
    YEAR(Order_Date)        AS Order_Year,
    ROUND(SUM(Sales), 2)    AS Yearly_Sales,
    ROUND(SUM(Profit), 2)   AS Yearly_Profit,
    COUNT(DISTINCT Order_ID) AS Yearly_Orders
FROM superstore
GROUP BY Order_Year
ORDER BY Order_Year;

-- Sub-Categories with consistent profit across all regions
SELECT
    Sub_Category,
    COUNT(DISTINCT Region)          AS Profitable_Regions,
    ROUND(SUM(Profit), 2)           AS Total_Profit,
    ROUND(SUM(Sales), 2)            AS Total_Sales
FROM superstore
GROUP BY Sub_Category
HAVING MIN(Profit) > 0
ORDER BY Total_Profit DESC;

/* ============================================================
   BUSINESS INSIGHTS SUPPORTED BY THIS SQL SCRIPT
   (Power BI Dashboard KPIs and Visualizations)
   ============================================================

   KPIs:
   -- Total Sales
   -- Total Profit
   -- Total Quantity Sold
   -- Total Orders
   -- Total Unique Customers
   -- Overall Profit Margin %
   -- Average Order Value
   -- Average Profit Per Order

   CHARTS & VISUALIZATIONS:
   -- Bar Chart     : Sales by Region, Category, Sub-Category, Segment
   -- Line Chart    : Monthly / Quarterly / Yearly Sales Trend
   -- Map Visual    : Sales and Profit by State / City
   -- Donut Chart   : Sales Share by Segment and Category
   -- Table         : Top & Bottom Customers, Top & Bottom Products
   -- Scatter Plot  : Discount vs Profit impact
   -- Clustered Bar : Ship Mode preference by Segment
   -- Matrix        : Region x Category Profit Heatmap
   -- Card Visuals  : KPI tiles for Total Sales, Profit, Orders
   -- Waterfall     : Profit by Sub-Category

   FILTERS / SLICERS:
   -- Year, Quarter, Month
   -- Region, State, City
   -- Category, Sub-Category
   -- Segment
   -- Ship Mode

   POWER BI DIRECT QUERY TABLES (Export from MySQL):
   -- Monthly Sales Trend
   -- Quarterly Sales Trend
   -- Yearly Sales Trend
   -- Region-wise KPIs
   -- Category & Sub-Category KPIs
   -- Customer Summary
   -- Product Summary
   -- Discount Impact Summary
   -- Shipping Summary

   ============================================================ */

/* ============================================================
   END OF SCRIPT
   Project  : Sales Dashboard Analysis
   Developer: Amey Kishor Sawatkar
   Internship: SkillInfyTech IT Solutions Pvt. Ltd.
   ============================================================ */