DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
DiscountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock boolean,
quantity INTEGER
);

-- data exploration

--count of rows

SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name is null
or
category is null
or
mrp is null
or
discountPercent is null
or
discountedSellingPrice is null
or
weightInGms is null
or
availableQuantity is null
or
outOfstock is null
or
quantity is null;


--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--product in stock vs out of stock
SELECT outOfStock, COUNT(sku_id)
from zepto
GROUP BY outOfStock;

--product names prsesnt multiple times
SELECT name, COUNT(sku_id) as "number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT (sku_id) DESC;

--data cleaning

--product with price = 
SELECT * FROM zepto
WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise to ruppees
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp, discountedSellingPrice from zepto

-- find the top 10 best-value products based on the discount percentage
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
limit 10;

--what are the products with High MRP but Out Of Stock

select distinct name, mrp
from zepto
where outOfStock = TRUE and mrp > 300
ORDER BY mrp DESC;

--CALCULATE ESTIMATED REVENUE FOR CATEGORY
SELECT category,
SUM(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
GROUP BY category
ORDER BY total_revenue;

--find all products where MRP is greater than 500 and discount is less than 10%
SELECT DISTINCT name, mrp, discountPercent 
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--identify the top 5 categories offering the highest average discount percentage
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
from zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Find the price per gram for products above 100g and sort by best value
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
WHERE weightInGms >=100
ORDER BY price_per_gram;

--group the product into categories like low, medium, bulk
SELECT DISTINCT NAME, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'low'
when weightInGms <5000 THEN 'medium'
else 'bulk'
END AS weight_category
FROM zepto;

--what is the Total Inventory Weight Per Category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

