SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'cars_duplicates';

SELECT  brand_name,min(price_in_inr),max(price_in_inr),avg(price_in_inr)
FROM cars_duplicates
group by brand_name;
-- info about Mileage and BHP
SELECT 
  brand_name,
  AVG(`mileage_min(kmpl)`+`mileage_min(kmpl)`/2) AS avg_mileage,
  AVG(`mileage_min(kmpl)`) AS avg_mileage_min,
  AVG(`mileage_max(kmpl)`) AS avg_mileage_max,
  MIN(`mileage_min(kmpl)`) AS min_mileage,
  MAX(`mileage_max(kmpl)`) AS max_mileage,
  AVG(min_BHP) AS avg_min_BHP,
  AVG(max_BHP) AS avg_max_BHP,
  MIN(min_BHP) AS min_BHP,
  MAX(max_BHP) AS max_BHP
FROM cars_duplicates
GROUP BY brand_name
ORDER BY avg_mileage DESC;

-- ratings
SELECT brand_name,avg(customer_rating),min(customer_rating),max(customer_rating)
FROM cars_duplicates
group by brand_name
order by 2 desc;

-- Total Sales in the year 2024
SELECT sum(annual_sales_2024)
FROM cars_duplicates;

-- Total Sales by Brand
select  brand_name,sum(annual_sales_2024) as total_sales
from cars_duplicates
group by brand_name
order by 2 desc
;
-- Total Sales by model
Select model_name,sum(annual_sales_2024) as Sales
from cars_duplicates
group by model_name
order by 2 desc;

-- Total Sales of cars by brand
SELECT brand_name, model_name, annual_sales_2024
FROM cars_duplicates AS c
WHERE annual_sales_2024 = (
  SELECT max(annual_sales_2024)
  FROM cars_duplicates
  WHERE brand_name = c.brand_name
)
ORDER BY annual_sales_2024 DESC
;

--  2024 Car Sales by Price Category
SELECT 
  CASE 
    WHEN price_in_inr < 500000 THEN 'Low (< ₹5L)'
    WHEN price_in_inr BETWEEN 500000 AND 1000000 THEN 'Mid (₹5L–₹10L)'
    WHEN price_in_inr BETWEEN 1000000 AND 2000000 THEN 'High (₹10L–₹20L)'
    ELSE 'Premium (> ₹20L)'
  END AS price_segment,
  COUNT(*) AS model_count,
  SUM(annual_sales_2024) AS total_sales
FROM cars_duplicates
GROUP BY price_segment
ORDER BY total_sales DESC;

-- Unsold cars in 2024 
SELECT distinct(brand_name), model_name
FROM cars_duplicates
where sales_status= 'No sales';

-- Top 5 selling brand in 2024
select  brand_name,sum(annual_sales_2024) as total_sales
from cars_duplicates
group by brand_name
order by 2 desc
limit 5;

-- Leading models  in 2024
SELECT brand_name, model_name, annual_sales_2024
FROM cars_duplicates AS c
WHERE annual_sales_2024 = (
  SELECT max(annual_sales_2024)
  FROM cars_duplicates
  WHERE brand_name = c.brand_name
)
ORDER BY annual_sales_2024 DESC
Limit 5;

-- -------REPORT-----
SELECT 'Total Sales' AS measure, SUM(annual_sales_2024) AS value
FROM cars_duplicates
UNION ALL
SELECT 'Average Price' AS measure, Round(AVG(price_in_inr),2) AS value
FROM cars_duplicates
UNION ALL
SELECT 'Total Brands' AS measure, COUNT(DISTINCT brand_name) AS value
FROM cars_duplicates
UNION ALL
SELECT 'Total Models' AS measure, COUNT(DISTINCT model_name) AS value
FROM cars_duplicates
UNION ALL
SELECT 'Sold Model Count' AS measure, COUNT(*) AS value
FROM cars_duplicates
WHERE sales_status = 'Sold'
UNION ALL
SELECT 'Unsold Model Count' AS measure, COUNT(*) AS value
FROM cars_duplicates
WHERE sales_status = 'No sales'
;

-- Highest-Priced Cars
SELECT brand_name,model_name,annual_sales_2024 ,price_in_inr
FROM cars_duplicates
ORDER BY price_in_inr DESC
LIMIT 5;







