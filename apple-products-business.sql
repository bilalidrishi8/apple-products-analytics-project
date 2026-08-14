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

-- ============================================================
-- APPLE PRODUCTS ANALYTICS PROJECT
-- SQL BUSINESS QUESTIONS
-- ============================================================


-- 1. Which RAM configuration has the highest average sale price?
SELECT * FROM apple_products

SELECT
    ram,
    ROUND(AVG(sale_price), 2) AS avg_sale_price
FROM apple_products
GROUP BY ram
ORDER BY avg_sale_price DESC
LIMIT 1;


-- 2. Which RAM configuration has the lowest average sale price?
SELECT * FROM apple_products

SELECT
    ram,
    ROUND(AVG(sale_price), 2) AS avg_sale_price
FROM apple_products
GROUP BY ram
ORDER BY avg_sale_price ASC
LIMIT 1;


-- 3. What is the average discount percentage for each RAM configuration?
SELECT * FROM apple_products

SELECT
    ram,
    ROUND(AVG(discount_percentage), 2) AS avg_discount_percentage
FROM apple_products
GROUP BY ram
ORDER BY avg_discount_percentage DESC;


-- 4. Which RAM configuration has the highest average star rating?
SELECT * FROM apple_products

SELECT
    ram,
    ROUND(AVG(star_rating), 2) AS avg_star_rating
FROM apple_products
GROUP BY ram
ORDER BY avg_star_rating DESC
LIMIT 1;


-- 5. Which products have a sale price below the overall average sale price?
SELECT * FROM apple_products

SELECT
    product_name,
    sale_price
FROM apple_products
WHERE sale_price < (
    SELECT AVG(sale_price)
    FROM apple_products)
ORDER BY sale_price ASC;

-- 6. Which products are priced above the overall average MRP?
SELECT * FROM apple_products

SELECT
    product_name,
    mrp
FROM apple_products
WHERE mrp > (
    SELECT AVG(mrp)
    FROM apple_products
)
ORDER BY mrp DESC;


-- 7. What is the average price difference between MRP and sale price?
SELECT * FROM apple_products

SELECT
    ROUND(
        AVG(mrp - sale_price),
        2
    ) AS avg_price_difference
FROM apple_products;


-- 8. Which products offer the highest absolute discount amount?
SELECT * FROM apple_products

SELECT
    product_name,
    mrp,
    sale_price,
    (mrp - sale_price) AS discount_amount
FROM apple_products
ORDER BY discount_amount DESC;


-- 9. Which products have the highest number of customer reviews?
SELECT * FROM apple_products

SELECT
    product_name,
    number_of_reviews
FROM apple_products
ORDER BY number_of_reviews DESC
LIMIT 10;


-- 10. Which products have a high number of ratings but a below-average star rating?
--
--     "High number of ratings" is defined here as
--     ratings above the overall average.
SELECT * FROM apple_products

SELECT
    product_name,
    number_of_ratings,
    star_rating
FROM apple_products
WHERE number_of_ratings > (
    SELECT AVG(number_of_ratings)
    FROM apple_products
)
AND star_rating < (
    SELECT AVG(star_rating)
    FROM apple_products
)
ORDER BY number_of_ratings DESC;


-- 11. Rank all products by sale price using RANK().
SELECT * FROM apple_products

SELECT
    product_name,
    sale_price,
    RANK() OVER (
        ORDER BY sale_price DESC
    ) AS price_rank
FROM apple_products
ORDER BY price_rank;


-- 12. Rank products within each RAM configuration based on sale price using ROW_NUMBER().
SELECT * FROM apple_products

SELECT
    product_name,
    ram,
    sale_price,
    ROW_NUMBER() OVER (
        PARTITION BY ram
        ORDER BY sale_price DESC
    ) AS ram_price_rank
FROM apple_products
ORDER BY ram, ram_price_rank;


-- 13. Calculate the percentage discount amount and compare it with the recorded discount percentage.
SELECT * FROM apple_products

SELECT
    product_name,
    mrp,
    sale_price,
    discount_percentage AS recorded_discount_percentage,

    ROUND(
        ((mrp - sale_price) / NULLIF(mrp, 0)) * 100,
        2
    ) AS calculated_discount_percentage,

    ROUND(
        (
            ((mrp - sale_price) / NULLIF(mrp, 0)) * 100
        ) - discount_percentage,
        2
    ) AS discount_percentage_difference

FROM apple_products
ORDER BY discount_percentage_difference DESC;


-- 14. Find the top 10 products based on a combined popularity score using ratings and reviews.
--
--     Popularity Score =
--     Number of Ratings + Number of Reviews

SELECT * FROM apple_products

SELECT
    product_name,
    number_of_ratings,
    number_of_reviews,

    (
        COALESCE(number_of_ratings, 0)
        +
        COALESCE(number_of_reviews, 0)
    ) AS popularity_score

FROM apple_products
ORDER BY popularity_score DESC
LIMIT 10;

-- 15. Calculate the percentage contribution of each product to the total number of ratings.
SELECT * FROM apple_products

SELECT
    product_name,
    number_of_ratings,
    ROUND(
        100.0 * number_of_ratings
        / SUM(number_of_ratings) OVER (),
        2
    ) AS rating_contribution_percentage
FROM apple_products
ORDER BY rating_contribution_percentage DESC;


-- 16. Identify products whose sale price is lower than the average sale price of their RAM configuration.
SELECT * FROM apple_products

SELECT
    product_name,
    ram,
    sale_price,
    ROUND(
        AVG(sale_price) OVER (PARTITION BY ram),
        2
    ) AS ram_average_sale_price
FROM apple_products
WHERE sale_price <
      AVG(sale_price) OVER (PARTITION BY ram);

-- Correct PostgreSQL version

WITH ram_price AS (
    SELECT
        product_name,
        ram,
        sale_price,
        AVG(sale_price) OVER (
            PARTITION BY ram
        ) AS avg_ram_sale_price
    FROM apple_products
)

SELECT
    product_name,
    ram,
    sale_price,
    ROUND(avg_ram_sale_price, 2) AS avg_ram_sale_price
FROM ram_price
WHERE sale_price < avg_ram_sale_price
ORDER BY ram, sale_price;


-- 17. Find the highest-rated product within each RAM configuration.
SELECT * FROM apple_products

WITH ranked_products AS (
    SELECT
        product_name,
        ram,
        star_rating,
        ROW_NUMBER() OVER (
            PARTITION BY ram
            ORDER BY star_rating DESC,
                     number_of_ratings DESC
        ) AS rating_rank
    FROM apple_products
)

SELECT
    product_name,
    ram,
    star_rating
FROM ranked_products
WHERE rating_rank = 1
ORDER BY ram;


-- 18. Calculate the rating-to-review ratio for every product and identify products with the highest ratio.
SELECT * FROM apple_products

SELECT
    product_name,
    number_of_ratings,
    number_of_reviews,
    ROUND(
        number_of_ratings::NUMERIC
        / NULLIF(number_of_reviews, 0),
        2
    ) AS rating_to_review_ratio
FROM apple_products
WHERE number_of_reviews > 0
ORDER BY rating_to_review_ratio DESC;