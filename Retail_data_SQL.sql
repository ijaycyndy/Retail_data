SELECT* 
FROM project_documentation.newretaildata;

-- 1) Sales Performance Analysis:
-- Total Sales Over Time: Analyses of the Total_Amount by Year and Month, time tracking sales trends over time.

-- Sales Performance Analysis: Total Sales Over Time
SELECT 
    YEAR AS Sales_Year,
    MONTH AS Sales_Month,
    SUM(Total_Amount) AS Total_Sales
FROM 
    project_documentation.newretaildata
GROUP BY 
    YEAR,
    MONTH
ORDER BY 
    CAST(CONCAT(Year, '-', CASE 
        WHEN Month = 'January' THEN '01'
        WHEN Month = 'February' THEN '02'
        WHEN Month = 'March' THEN '03'
        WHEN Month = 'April' THEN '04'
        WHEN Month = 'May' THEN '05'
        WHEN Month = 'June' THEN '06'
        WHEN Month = 'July' THEN '07'
        WHEN Month = 'August' THEN '08'
        WHEN Month = 'September' THEN '09'
        WHEN Month = 'October' THEN '10'
        WHEN Month = 'November' THEN '11'
        WHEN Month = 'December' THEN '12'
    END, '-01') AS DATE) ASC;


-- Product Performance: Analysing which Product_Category, Product_Brand, or Product_Type generates the highest Total_Amount
SELECT 
      Product_Category, 
      Product_Brand, 
      Product_Type, 
      SUM(total_amount) AS Total_amount_sum
FROM 
      project_documentation.newretaildata
GROUP BY 
       Product_Category, Product_Brand, Product_Type
ORDER BY 
       total_amount_sum DESC;

-- Customer Segmentation Analysis: determining which Customer segment contributes the most to your revenue.
SELECT  
      Customer_Segment, 
      SUM(Total_amount) AS total_amount_sum 
FROM 
      project_documentation.newretaildata
GROUP BY   
      Customer_Segment
ORDER BY
      total_amount_sum  DESC;

-- 2)  Customer Analysis
-- Demographic Analysis: Understanding customer demographics by analyzing Age, Gender, City, State, and Country and see how different demographics contribute to sales.

SELECT 
    CASE 
        WHEN age BETWEEN 0 AND 18 THEN '0-18'
        WHEN age BETWEEN 19 AND 25 THEN '19-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+' 
    END AS age_range,
    gender, 
    SUM(total_amount) AS total_amount_sum 
FROM 
     project_documentation.newretaildata
GROUP BY 
       age_range, gender
ORDER BY 
       total_amount_sum  DESC;

SELECT 
     City, State, Country ,
     SUM(total_amount) AS total_amount_sum 
FROM 
     project_documentation.newretaildata
GROUP BY 
     City, State, Country 
ORDER BY 
     total_amount_sum  DESC;

-- Customer Lifetime Value (CLV): Calculating the CLV using Customer_ID and Total_Purchases, and total amount to identify the most valuable customers.
SELECT 
    Customer_ID, 
    COUNT(Transaction_ID) AS Total_Purchases, 
    SUM(total_amount) AS Total_Revenue,
    (SUM(total_amount) / COUNT(Transaction_ID)) * COUNT(DISTINCT Date) AS CLV
FROM 
    project_documentation.newretaildata
GROUP BY 
    Customer_ID
ORDER BY 
    CLV DESC;

-- Customer Retention: Analyzing repeat purchases by tracking the frequency of Transaction_ID associated with each Customer_ID.

SELECT 
    Customer_ID,
    COUNT(Transaction_ID) AS Total_Purchases,
    COUNT(DISTINCT Date) AS Purchase_Days,
    CASE 
        WHEN COUNT(Transaction_ID) > 1 THEN 'Repeat Customer'
        ELSE 'One-Time Customer'
    END AS Customer_Type
FROM 
    project_documentation.newretaildata
GROUP BY 
    Customer_ID
ORDER BY 
    Total_Purchases DESC;


-- 3) Product Analysis
-- Product Popularity: Analyzing which products (Product_Category, Product_Brand, Product_Type) are most frequently purchased based on the products and Total_Purchases columns.

SELECT 
    Product_Category,
    Product_Brand,
    Product_Type,
    COUNT(*) AS Total_Purchases
FROM 
    project_documentation.newretaildata
GROUP BY 
    Product_Category, 
    Product_Brand, 
    Product_Type
ORDER BY 
    Total_Purchases DESC;


-- 	Product Feedback and Ratings: Evaluating Feedback and Ratings to understand customer satisfaction with different products.

SELECT 
    Product_Type, 
    Product_Brand,
    SUM(CASE WHEN Feedback = 'excellent' THEN 1 ELSE 0 END) AS Excellent_count,
    SUM(CASE WHEN Feedback = 'Good' THEN 1 ELSE 0 END) AS Good_count,
    SUM(CASE WHEN Feedback = 'Average' THEN 1 ELSE 0 END) AS Average_count,
    SUM(CASE WHEN Feedback = 'Bad' THEN 1 ELSE 0 END) AS Bad_count
FROM 
    project_documentation.newretaildata
GROUP BY 
    Product_Type, 
    Product_Brand
ORDER BY
   Excellent_count desc;

-- 3) Geographical Analysis
-- Sales by Location: Analyzing sales (Total_Amount) by City, State, Zipcode, or Country to identify regions with the highest and lowest sales.
SELECT  
      City, 
      State, 
      Country, 
      sum(Total_Amount) AS Total_amount_sum
FROM 
      project_documentation.newretaildata
GROUP BY 
      City, State, Country
ORDER BY
      Total_amount_sum desc;

-- Customer Distribution: Map out where your customers are located based on City, State, Zipcode, or Country.
SELECT 
      Country, 
      City, 
      State, 
      COUNT(DISTINCT Customer_ID) AS Number_of_Customers
FROM 
      project_documentation.newretaildata
GROUP BY 
      Country, City, State
ORDER BY 
      Number_of_Customers DESC;

-- 4) Payment and Shipping Analysis
-- Preferred Payment Methods: Analyzing the Payment_Method to determine the most popular payment options among customers.
SELECT 
      Payment_Method, 
      count(Customer_ID) as Usage_count
FROM 
      Project_documentation.newretaildata
GROUP BY
      Payment_Method
ORDER BY 
      Usage_count desc;

-- Shipping Method Analysis: Evaluating the Shipping_Method to see which options are most commonly chosen and their impact on Order_Status.
SELECT 
      Shipping_method,  
      count(Customer_id) as Usage_count
FROM 
    project_documentation.newretaildata
GROUP BY 
     Shipping_Method
ORDER BY
    Usage_count desc;
-- Impact of Shipping Method on Order Status 
SELECT Shipping_Method, 
       Order_Status, 
       COUNT(*) AS Status_count,
       (COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Shipping_Method)) AS Status_percentage
FROM 
     project_documentation.newretaildata
GROUP BY 
    Shipping_Method, Order_Status
ORDER BY 
    Status_percentage DESC;

-- 5) Order and Transaction Analysis
-- Order Status Evaluation: Using the Order_Status to analyze the percentage of Delivered,Shipped, Processing or pending orders.

SELECT Order_Status, COUNT(Customer_ID) AS Order_count,
    (COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER ()) AS Percentage
FROM  project_documentation.newretaildata
WHERE Year = 2023 AND Month = 'September'
GROUP BY Order_Status
ORDER BY Percentage DESC;

-- Transaction Timing Analysis: Examining peak hours for transactions and correlating with Total_Amount and Total_Purchases
SELECT 
    EXTRACT(HOUR FROM Time) AS Hour,
    COUNT(*) AS Total_Transactions,
    SUM(Total_Amount) AS Total_Sales,
    SUM(Total_Purchases) AS Total_Purchases
FROM 
    project_documentation.newretaildata
GROUP BY 
    EXTRACT(HOUR FROM Time)
ORDER BY 
    Total_Transactions DESC;


-- 6) Income and Spending Analysis
-- Income vs. Spending: Correlating Income with Total_Amount to analyze how income levels affect spending behavior.
SELECT 
    Income, 
    COUNT(Customer_ID) AS Number_of_Customers,
    AVG(Total_Amount) AS Average_Spending,
    SUM(Total_Amount) AS Total_Spending
FROM 
    project_documentation.newretaildata
GROUP BY 
    Income
ORDER BY 
    Average_Spending DESC;

-- 7) Customer Feedback Analysis
-- Feedback Correlation: Analyze how Feedback and Ratings correlate with other variables like Product_Type, Shipping_Method, or Order_Status to identify areas of improvement
 -- Percentage of Each Feedback Type by Product Category
WITH FeedbackCounts AS (
    SELECT 
        Product_Category, 
        Feedback, 
        COUNT(Feedback) AS feedback_count 
    FROM 
        project_documentation.newretaildata
    GROUP BY 
        Product_Category, 
        Feedback
),
TotalCounts AS (
    SELECT 
        Product_Category, 
        SUM(feedback_count) AS total_feedback
    FROM 
        FeedbackCounts
    GROUP BY 
        Product_Category
)
SELECT 
    fc.Product_Category, 
    fc.Feedback, 
    fc.feedback_count,
    (fc.feedback_count * 100.0 / tc.total_feedback) AS feedback_percentage
FROM 
    FeedbackCounts fc
JOIN 
    TotalCounts tc
ON 
    fc.Product_Category = tc.Product_Category
ORDER BY 
    fc.Product_Category, 
    feedback_percentage DESC;
    
    
-- including ratings to understand average ratings by feedback type    
SELECT 
    Product_Category, 
    Feedback, 
    COUNT(Feedback) AS feedback_count, 
    AVG(Ratings) AS average_rating
FROM 
    project_documentation.newretaildata
GROUP BY 
    Product_Category, 
    Feedback
ORDER BY 
    Product_Category, 
    feedback_count DESC;
-- To see how feedback trends over time for each product category
SELECT 
    Product_Category, 
    Date,
    Feedback,
    COUNT(Feedback) AS feedback_count
FROM 
    project_documentation.newretaildata
GROUP BY 
    Product_Category, 
    Date,
    Feedback
ORDER BY 
    feedback_count DESC;
    
-- 9) Seasonality Analysis
-- 	Monthly/Seasonal Trends: Analyzing Total_Amount or Total_Purchases by Month or Year to identify any seasonal trends in purchasing behavior.

SELECT 
    Year, 
    Month, 
    SUM(Total_Purchases) AS total_purchases,
    SUM(Total_Amount) AS total_Amount
FROM 
    project_documentation.newretaildata
GROUP BY 
    Year, 
    Month
ORDER BY 
    CAST(CONCAT(Year, '-', CASE 
        WHEN Month = 'January' THEN '01'
        WHEN Month = 'February' THEN '02'
        WHEN Month = 'March' THEN '03'
        WHEN Month = 'April' THEN '04'
        WHEN Month = 'May' THEN '05'
        WHEN Month = 'June' THEN '06'
        WHEN Month = 'July' THEN '07'
        WHEN Month = 'August' THEN '08'
        WHEN Month = 'September' THEN '09'
        WHEN Month = 'October' THEN '10'
        WHEN Month = 'November' THEN '11'
        WHEN Month = 'December' THEN '12'
    END, '-01') AS DATE) ASC;

 -- Average Purchase Amount by Month and Year
 SELECT 
    Year, 
    Month, 
    AVG(Total_Amount) AS average_purchase_amount
FROM 
    project_documentation.newretaildata
GROUP BY 
    Year, 
    Month
ORDER BY 
    CAST(CONCAT(Year, '-', CASE 
        WHEN Month = 'January' THEN '01'
        WHEN Month = 'February' THEN '02'
        WHEN Month = 'March' THEN '03'
        WHEN Month = 'April' THEN '04'
        WHEN Month = 'May' THEN '05'
        WHEN Month = 'June' THEN '06'
        WHEN Month = 'July' THEN '07'
        WHEN Month = 'August' THEN '08'
        WHEN Month = 'September' THEN '09'
        WHEN Month = 'October' THEN '10'
        WHEN Month = 'November' THEN '11'
        WHEN Month = 'December' THEN '12'
    END, '-01') AS DATE) ASC;

--  Seasonal Trends by Product Category
 SELECT 
    Year, 
    Month, 
    Product_Category, 
    SUM(Total_Amount) AS total_amount
FROM 
    project_documentation.newretaildata
GROUP BY 
    Year, 
    Month, 
    Product_Category
ORDER BY 
    CAST(CONCAT(Year, '-', CASE 
        WHEN Month = 'January' THEN '01'
        WHEN Month = 'February' THEN '02'
        WHEN Month = 'March' THEN '03'
        WHEN Month = 'April' THEN '04'
        WHEN Month = 'May' THEN '05'
        WHEN Month = 'June' THEN '06'
        WHEN Month = 'July' THEN '07'
        WHEN Month = 'August' THEN '08'
        WHEN Month = 'September' THEN '09'
        WHEN Month = 'October' THEN '10'
        WHEN Month = 'November' THEN '11'
        WHEN Month = 'December' THEN '12'
    END, '-01') AS DATE) ASC;

 -- Year-over-Year Comparison
 SELECT 
    Month, 
    Year, 
    SUM(Total_Amount) AS total_amount
FROM 
    project_documentation.newretaildata
GROUP BY 
    Year, 
    Month
ORDER BY 
    CAST(CONCAT(Year, '-', CASE 
        WHEN Month = 'January' THEN '01'
        WHEN Month = 'February' THEN '02'
        WHEN Month = 'March' THEN '03'
        WHEN Month = 'April' THEN '04'
        WHEN Month = 'May' THEN '05'
        WHEN Month = 'June' THEN '06'
        WHEN Month = 'July' THEN '07'
        WHEN Month = 'August' THEN '08'
        WHEN Month = 'September' THEN '09'
        WHEN Month = 'October' THEN '10'
        WHEN Month = 'November' THEN '11'
        WHEN Month = 'December' THEN '12'
    END, '-01') AS DATE) ASC;

-- Cross-Selling and Upselling Opportunities
--	Product Bundling: Analyzing the products column to identify common product combinations purchased together, which could inform cross-selling or upselling strategies.
-- Finding Frequently Bought Together Products
SELECT 
    t1.Product_Type AS Product_A,
    t2.Product_Type AS Product_B,
    COUNT(*) AS Frequency
FROM 
    project_documentation.newretaildata t1
JOIN 
    project_documentation.newretaildata t2 
    ON t1.Customer_ID = t2.Customer_ID 
    AND t1.Transaction_ID < t2.Transaction_ID
GROUP BY 
    t1.Product_Type, t2.Product_Type
HAVING 
    COUNT(*) > 1
ORDER BY 
    Frequency DESC;
    
-- Identifing Potential Upselling Opportunities
WITH Product_Rank AS (
    SELECT 
        Customer_ID, 
        Product_Type, 
        Amount, 
        RANK() OVER (PARTITION BY Customer_ID, Product_Type ORDER BY Amount DESC) AS `rank`
    FROM 
        project_documentation.newretaildata
)
SELECT 
    Customer_ID, 
    Product_Type, 
    MIN(Amount) AS Min_Amount,
    MAX(Amount) AS Max_Amount,
    COUNT(*) AS Purchase_Count
FROM 
    Product_Rank
WHERE 
    `rank` = 1
GROUP BY 
    Customer_ID, 
    Product_Type
HAVING 
    COUNT(*) > 1
ORDER BY 
    Max_Amount DESC;

-- Finding Cross-Selling and Upselling Based on Customer Segments
SELECT 
    Customer_Segment, 
    Product_Brand, 
    Product_Type, 
    COUNT(*) AS Purchase_Count, 
    AVG(Amount) AS Avg_Amount
FROM 
    project_documentation.newretaildata
GROUP BY 
    Customer_Segment, 
    Product_Brand, 
    Product_Type
ORDER BY 
    Purchase_Count DESC, Avg_Amount DESC;



SELECT *
FROM project_documentation.newretaildata;

-- **************************************************************************

-- Identifying potential upselling opportunities without window functions
SELECT 
    t1.Product_Type AS Product_A,
    t2.Product_Type AS Product_B,
    COUNT(*) AS Frequency,
    AVG(t2.Amount - t1.Amount) AS Avg_Amount_Difference
FROM 
    project_documentation.newretaildata t1
JOIN 
    project_documentation.newretaildata t2
    ON t1.Transaction_ID = t2.Transaction_ID
    AND t1.Amount < t2.Amount
GROUP BY 
    t1.Product_Type, t2.Product_Type
HAVING 
    COUNT(*) > 1
ORDER BY 
    Frequency DESC, Avg_Amount_Difference DESC;
    

-- Analyzing customer segments for cross-selling and upselling
SELECT 
    t1.Customer_Segment,  -- Explicitly reference Customer_Segment from table t1
    t1.Product_Type AS Product_A,
    t2.Product_Type AS Product_B,
    COUNT(*) AS Frequency
FROM 
    project_documentation.newretaildata t1
JOIN 
    project_documentation.newretaildata t2
    ON t1.Transaction_ID = t2.Transaction_ID
    AND t1.Customer_Segment = t2.Customer_Segment
    AND t1.Product_Type < t2.Product_Type
GROUP BY 
    t1.Customer_Segment,  -- Group by the explicit reference
    t1.Product_Type, 
    t2.Product_Type
HAVING 
    COUNT(*) > 1
ORDER BY 
    Frequency DESC
LIMIT 1000;  -- LIMIT 0, 1000 can be simplified to just LIMIT 1000


