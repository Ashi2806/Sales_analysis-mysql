## 1. Project Title
### Exploratory Data Analysis of Automotive Sales and Performance Using MySQL

## 2. Overview
This project dives into car sales data using pure SQL—no dashboards, just logic. I cleaned and explored the dataset to uncover patterns in pricing, brand performance, and technical specs like BHP and mileage. Through modular queries and smart segmentation, I surfaced insights that connect raw numbers to real business decisions.

##  3. Key Questions Answered
- Are higher-priced models selling better?
- Which models underperform despite strong specs?
- What is the sales distribution across price tiers?
- How do mileage and BHP vary by brand?

## 4. Objectives
- Clean and structure raw data using SQL
- Identify top-selling and underperforming models
- Explore relationships between price, BHP, mileage, and sales

## 5.Key SQL Features
- Aggregations: AVG, SUM, COUNT, MIN, MAX
- Conditional logic: CASE WHEN for segmentation
- KPI reporting: UNION ALL for summary blocks
- Performance scoring and completeness checks

## 6.Sample Queries
SELECT brand_name, model_name, annual_sales_2024, price_in_inr
FROM cars_duplicates
ORDER BY price_in_inr DESC
LIMIT 5;

## 7.Sample output
<img width="756" height="491" alt="Image" src="https://github.com/user-attachments/assets/a157d086-7b7a-4fd6-ad5b-34a75b42f5f6" />
## 8.Insights
- Premium brands don’t always lead in sales
- Some models underperform despite strong specs
- Mileage and BHP vary significantly across price tiers


## 9. Next Steps
- Add Power BI dashboard
- Create views for modular reporting
- Expand to multi-year sales comparison




