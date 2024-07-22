select *
from PortfolioProject ..WalmartSales
order by Invoice_ID, Branch

--- FEATURE ENGINEERING FOR THE SALES
---DATE AND TIME FEATURES
---ADDING AND PPOPULATING THE day_of_week COLUMNS
use PortfolioProject;
select *
from WalmartSales
ALTER TABLE walmartSales ADD day_of_week INT

select *
from WalmartSales
update WalmartSales set day_of_week = DATEPART(dw, date);

---ADDING AND PPOPULATING THE Month COLUMN
select *
from WalmartSales
ALTER TABLE walmartSales ADD Month int;

select *
from WalmartSales
update WalmartSales set Month = DATEPART(month, date);

---ADDING AND PPOPULATING THE Hour of the Day
select *
from WalmartSales
ALTER TABLE walmartSales ADD Hour int;

select *
from WalmartSales
update WalmartSales set Hour = DATEPART(hour, time);

---ADDING AND PPOPULATING THE Weekend Indicator(1 FOR WEEKEND 0 FOR 0THERWISE)
select *
from WalmartSales;
ALTER TABLE walmartsales add Weekend BIT;

select *
from WalmartSales;
UPDATE WalmartSales set Weekend = case
	when DATEPART(dw, date) IN (1,7) THEN 1
	ELSE 0
END;

---Customer and Transaction Features
------ADDING AND PPOPULATING THE is the customer a member COLUMN
select *
from WalmartSales;
ALTER TABLE Walmartsales add Is_a_Member BIT;

UPDATE WalmartSales SET is_a_member = case
	WHEN Customer_type = 'Member' THEN 1
	ELSE 0
END;

---CHECKING DATASET---
select Invoice_ID, City, Customer_type, is_member
from WalmartSales
group by Invoice_ID, city, customer_type, is_member
order by is_member

---ADDING AND PPOPULATING THE Avg_Transaction_Amount_per_Item COLUMN
select *
from WalmartSales;
ALTER TABLE walmartsales add Avg_Transaction_Amount_per_Item DECIMAL(12,4);

select *
from WalmartSales
UPDATE WalmartSales SET avg_transaction_amount_per_item = total / quantity;

---Gross Margin

select *
from WalmartSales;
ALTER TABLE walmartsales add gross_margin DECIMAL(12,4);

select *
from WalmartSales
UPDATE WalmartSales SET gross_margin = (gross_margin_percentage/100)*Total;


--- SALES PERFORMACE ANALYSIS
---Total Sales per Branch
SELECT *
FROM WalmartSales;
ALTER TABLE WalmartSales ADD Total_Sales_Per_Branch DECIMAL(12, 2);

select *
from WalmartSales
UPDATE WalmartSales SET Total_Sales_Per_Branch = (
	SELECT SUM(total)
	FROM WalmartSales AS inner_sales
	WHERE inner_sales.branch = WalmartSales.branch
);

select branch, City, Total_Sales_Per_Branch
from WalmartSales
group by city, branch, Total_Sales_Per_Branch
order by branch

-- Total Sales per Product Line --
-- Add and update Total_Sales_Per_Product_line column
SELECT *
FROM WalmartSales;
ALTER TABLE WalmartSales ADD Total_Sales_Per_Product_line DECIMAL(12, 2);

select *
from WalmartSales
UPDATE WalmartSales SET Total_Sales_Per_Product_line = (
	SELECT SUM(Product_line)
	FROM WalmartSales AS inner_sales
	WHERE inner_sales.Product_line = WalmartSales.Product_line
);

-- Query to display total sales per product line
select Product_line, Total_Sales_Per_Product_line
from WalmartSales
group by Product_line, Total_Sales_Per_Product_line
order by Total_Sales_Per_Product_line

--occurrences of each product line 

select product_line, count(product_line) as common_product_line
from WalmartSales
group by Product_line
order by common_product_line

--- CUSTOMERS TYPES WITH THE HIGHEST REVENUE
-- Query to identify customer types with the highest total revenue

SELECT Customer_type, Sum(total) AS Highest_Revenue_per_CustomerType
FROM walmartsales
GROUP BY Customer_type
ORDER BY Highest_Revenue_per_CustomerType


---CUSTOMER TYPE WITH THE HIGHEST VAT
SELECT customer_type, SUM(Vat) AS Total_Vat
FROM Walmartsales 
GROUP BY customer_type
ORDER BY Total_Vat

---PRODUCT WITH THE HIGHEST VAT
-- Query to calculate total VAT per product line
SELECT product_line, sum(vat) AS Highest_Vat
FROM WalmartSales
GROUP BY Product_line
ORDER BY Highest_Vat


-- Total VAT per City --
-- Query to calculate total VAT per city and round to two decimal places
SELECT city, ROUND(SUM(Vat), 2) AS Total_City_Vat
FROM walmartsales
GROUP BY City
ORDER BY Total_City_Vat

-- Total Sales excluding weekends --
-- Query to calculate total sales excluding weekends (Saturday and Sunday)

SELECT day_of_week, Time_of_day, COUNT(invoice_id) AS total_Sales
FROM walmartsales 
GROUP BY day_of_week, Time_of_day
HAVING day_of_week NOT in ('sunday','saturday');

---FINANCIAL METRICS

---REVENUE BY MONTH
-- Query to calculate total revenue per month

SELECT month, SUM(total) as Total_revenue
from walmartsales 
group by month
order by Total_revenue desc

---MONTH WITH THE HIGHEST SALES

SELECT month, sum(cogs) AS Total_Cogs
FROM WalmartSales
group by month
order by Total_Cogs DESC

--- PRODUCT LINE WITH THE HIGHEST REVENUE
-- Query to identify product lines with the highest total revenue
SELECT product_line, sum(total) AS Total_Revenue
FROM WalmartSales
group by Product_line
order by Total_Revenue DESC

---CITY WITH THE HIGHEST REVENUE
-- Query to identify cities with the highest total revenue

SELECT city, sum(total) AS City_Revenue
FROM WalmartSales
group by city
order by City_Revenue DESC


---GENERIC RESPONSES
select *
from WalmartSales

-- Query to display distinct cities in the dataset

select distinct city from WalmartSales;

-- Query to display distinct branches and cities in the dataset

select distinct Branch, city from WalmartSales;

---DISTINCT PRODUCT IN THE DATASET
select count(distinct product_line) from WalmartSales;

---THE MOST COMMON PAYMENT
-- Query to identify the most common payment methods and their counts

select payment, count(payment) as Common_Payment_Method
FROM WalmartSales
group by Payment
order by Common_Payment_Method desc


---PRODUCT LINE WITH QUALITY INDICATOR

SELECT *
FROM WalmartSales;
ALTER TABLE walmartsales ADD Product_Category VARCHAR(20);

SELECT *
FROM WalmartSales
UPDATE WalmartSales SET Product_Category = Case
	WHEN Total >= (SELECT AVG(total) FROM WalmartSales) THEN 'Good'
	ELSE 'Bad'
END;

---PRODUCTS WITH MORE THAN AVERAGE SALES
-- Query to identify branches with quantities of products sold above the average

SELECT branch, Sum(quantity) AS Quantity
FROM WalmartSales
GROUP BY branch
HAVING sum(quantity) > AVG(quantity)
ORDER BY Quantity 

---MOST COMMON PRODUCT LINE BY GENDER
----- Query to identify the most common product lines purchased by gender

SELECT gender, product_line, COUNT(gender) AS Total_Count
FROM WalmartSales
GROUP BY gender, Product_line, city
ORDER BY Total_Count desc

SELECT *
FROM WalmartSales;
ALTER TABLE walmartsales ADD Rating_Category VARCHAR(20);

select *
from WalmartSales
UPDATE WalmartSales SET Rating_Category = Case
	WHEN Rating >= 4.5 THEN 'Good_rating'
	ELSE 'Bad_rating'
END;

-- Average Rating of Each Product Line --
-- Query to calculate the average rating for each product line rounded to two decimal places
SELECT product_line, ROUND(AVG(rating),2) average_rating
FROM walmartsales 
GROUP BY product_line
ORDER BY average_rating