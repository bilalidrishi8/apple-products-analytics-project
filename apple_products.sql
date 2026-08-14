-- ============================================================
-- APPLE PRODUCTS ANALYTICS PROJECT
-- PostgreSQL Table
-- ============================================================

CREATE TABLE apple_products (
    product_name VARCHAR(150),
    product_url TEXT,
    brand VARCHAR(50),
    sale_price NUMERIC(12,2),
    mrp NUMERIC(12,2),
    discount_percentage NUMERIC(5,2),
    number_of_ratings INT,
    number_of_reviews INT,
    upc VARCHAR(100) PRIMARY KEY,
	star_rating NUMERIC(3,1),
    ram VARCHAR(20)
);

SELECT * FROM apple_products

--1.Which RAM configuration has the highest average sale price?
--2.Which RAM configuration has the lowest average sale price?
--3.What is the average discount percentage for each RAM configuration?
--4.Which RAM configuration has the highest average star rating?
--5.Which products have a sale price below the overall average sale price?
--6.Which products are priced above the overall average MRP?
--7.What is the average price difference between MRP and sale price?
--8.Which products offer the highest absolute discount amount (MRP − sale price)?
--9.Which products have the highest number of customer reviews?
--10.Which products have a high number of ratings but a below-average star rating?
--11.Rank all products by sale price using RANK().
--12.Rank products within each RAM configuration based on sale price using ROW_NUMBER().
--13.Calculate the percentage discount amount for each product and compare it with the recorded discount percentage.
--14.Find the top 10 products based on a combined popularity score using ratings and reviews.
--15.Calculate the percentage contribution of each product to the total number of ratings.
--16.Identify products whose sale price is lower than the average sale price of their RAM configuration.
--17.Find the highest-rated product within each RAM configuration.
--18.Calculate the rating-to-review ratio for every product and identify products with the highest
