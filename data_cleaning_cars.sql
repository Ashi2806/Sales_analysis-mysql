select * from cars_2024;
-- ------Copy of original data-------------
create table cars_duplicates
like cars_2024;

INSERT INTO cars_duplicates
SELECT * FROM cars_2024;

SELECT * FROM cars_duplicates;
-- Change the column name to proper english for further steps
ALTER TABLE cars_duplicates
CHANGE ï»¿Brand brand_name varchar(50);

-- 1.Remove duplicates ----------------
WITH duplicate_rows AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY brand_name, `Car Name`, Price, Rating, Safety, Mileage, `Power (BHP)`,`FY2024(sales)`) 
as row_num
FROM cars_duplicates
) 
SELECT *
FROM duplicate_rows
WHERE row_num > 1; -- No duplicates

-- 2. Standandrize the data 

UPDATE cars_duplicates
SET model_name = TRIM(REPLACE(model_name, brand_name, ''))
WHERE model_name LIKE CONCAT(brand_name, '%');

UPDATE cars_duplicates
SET model_name = TRIM(REPLACE(model_name, 'Maruti', ''))
WHERE model_name LIKE 'Maruti%';

UPDATE cars_duplicates
  SET price =
CASE
    WHEN price LIKE '%Lakh%' THEN
      cast(CAST(REPLACE(REPLACE(price, 'Rs. ', ''), ' Lakh', '') AS DECIMAL(10,2)) * 100000 as unsigned)
    WHEN price LIKE '%Crore%' THEN
     cast( CAST(REPLACE(REPLACE(price, 'Rs. ', ''), ' Crore', '') AS DECIMAL(10,2)) * 10000000 as unsigned)
    ELSE NULL
END;

UPDATE cars_duplicates 
SET rating =
CASE 
	WHEN rating LIKE '%/5'
	THEN substring_index(rating,'/5',1)
	ELSE NULL
END ;

UPDATE cars_duplicates 
SET Safety =
CASE 
	WHEN Safety REGEXP '[0-9]' THEN
	REGEXP_REPLACE(Safety,'[^0-9]','')
	ELSE NULL
END ;

alter table cars_duplicates
add column `mileage_min(kmpl)` int,
add column `mileage_max(kmpl)` int;

UPDATE  cars_duplicates 
SET Mileage = null 
where Mileage = '';

UPDATE  cars_duplicates 
SET 
`mileage_min(kmpl)`= REGEXP_REPLACE(SUBSTRING_INDEX(Mileage,'-',1),'[^0-9]','') ,
`mileage_max(kmpl)`=REGEXP_REPLACE(SUBSTRING_INDEX(Mileage,'-',-1),'[^0-9]','') 
;

SELECT  `Power (BHP)`,
REGEXP_REPLACE(SUBSTRING_INDEX(`Power (BHP)`,'-',1),'[^0-9]','') min,
REGEXP_REPLACE(SUBSTRING_INDEX(`Power (BHP)`,'-',-1),'[^0-9]','') max
FROM cars_duplicates;

alter table cars_duplicates
add column min_BHP int,
add column max_BHP int;

UPDATE cars_duplicates
SET `Power (BHP)` = null
WHERE `Power (BHP)` = '';

UPDATE cars_duplicates
SET min_BHP =
REGEXP_REPLACE(SUBSTRING_INDEX(`Power (BHP)`,'-',1),'[^0-9]','') ,
max_BHP = REGEXP_REPLACE(SUBSTRING_INDEX(`Power (BHP)`,'-',-1),'[^0-9]','') 
;

UPDATE  cars_duplicates 
SET `fy2024(sales)` = null 
where `fy2024(sales)` = '';

UPDATE  cars_duplicates 
SET `fy2024(sales)` = CAST(REPLACE(`fy2024(sales)`, ',', '') AS UNSIGNED);

SELECT * FROM cars_duplicates
order by 4 asc
;

ALTER TABLE cars_duplicates
CHANGE `Car Name` model_name varchar(50),
CHANGE Price price_in_inr int,
CHANGE Rating customer_rating decimal(2,1),
CHANGE Safety safety_rating  int,
CHANGE `FY2024(sales)` annual_sales_2024 int ;

SELECT * FROM cars_duplicates;

-- -------------handling null-------------

UPDATE cars_duplicates
SET annual_sales_2024 = 0
WHERE annual_sales_2024 IS NULL ;

ALTER TABLE cars_duplicates
ADD  COLUMN `sales_status` VARCHAR(50);

UPDATE cars_duplicates
SET `sales_status`=
CASE 
	WHEN annual_sales_2024 = 0
	THEN 'No sales'
	ELSE 'Sold'
END;

-- -----------------REMOVE UNWANTED COUMN ---------------
ALTER TABLE cars_duplicates
DROP COLUMN Mileage,
DROP COLUMN `Power (BHP)`;



