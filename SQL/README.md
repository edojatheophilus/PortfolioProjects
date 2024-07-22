# Walmart Sales Dataset Analysis

## Introduction
Walmart sales analysis using SQL queries. 
The dataset contains information on sales transactions including invoice details, customer demographics, product details, and financial metrics.

## Dataset Overview
The dataset used for analysis is stored in the WalmartSales table within the PortfolioProject database. It includes the following key columns:

Invoice_ID: Unique identifier for each transaction.
Branch: Branch identifier where the transaction occurred.
City: City where the transaction took place.
Customer_type: Type of customer (Member or Normal).
Total: Total amount of the transaction.
Quantity: Quantity of items sold in each transaction.
Vat: Value-added tax applied to the transaction.
Rating: Customer rating for the product purchased.

## SQL Analysis
## Feature Engineering
## Date and Time Features
Day of the Week: Added day_of_week column indicating the day number (1-7).
Month: Added Month column indicating the month number (1-12).
Hour of the Day: Added Hour column indicating the hour of the transaction.
Weekend Indicator: Added Weekend column (1 for Saturday and Sunday, 0 otherwise).

## Customer and Transaction Features
Membership Status: Added Is_a_Member column indicating if the customer is a member (1) or not (0).
Average Transaction Amount per Item: Added Avg_Transaction_Amount_per_Item column calculated as total amount divided by quantity.
Gross Margin: Added gross_margin column calculated using a gross margin percentage.

## Sales Performance Analysis
Total Sales per Branch: Calculated Total_Sales_Per_Branch for each branch.
Total Sales per Product Line: Calculated Total_Sales_Per_Product_line for each product line.
Highest Revenue per Customer Type: Identified customer types (Member vs Normal) with the highest revenue.
Highest VAT per Customer Type and City: Calculated total VAT for each customer type and city.

## Financial Metrics
Revenue and Costs Analysis: Analyzed total revenue and cost of goods sold (COGS) per month.
Product Line with the Highest Revenue: Identified product lines with the highest total revenue.
City with the Highest Revenue: Identified cities with the highest total revenue.

## Generic Insights
Common Payments Methods: Identified the most common payment methods used.
Product Line Quality Indicator: Added Product_Category column to indicate if a product's total sales were above or below average.

## Additional Insights
Products with Above Average Sales: Identified branches where product sales quantities were above average.
Rating Analysis: Added Rating_Category column to categorize products based on customer ratings.
