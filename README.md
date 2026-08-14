# 🍎 Apple Products SQL Analysis

![SQL](https://img.shields.io/badge/SQL-Analysis-4169E1?style=for-the-badge&logo=databricks&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-Data%20Analysis-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Analytics-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=for-the-badge&logo=github)

---

## 📌 Project Overview

The **Apple Products SQL Analysis Project** analyzes Apple product pricing, discounts, RAM configurations, customer ratings, reviews, and product popularity.

The project uses **PostgreSQL and SQL** to transform raw product data into meaningful business insights and demonstrate practical SQL skills from intermediate to advanced level.

The analysis focuses on understanding **product pricing, customer engagement, discounts, ratings, and product performance**.

---

## 🎯 Project Objectives

- Analyze Apple product pricing.
- Compare MRP and sale prices.
- Analyze product discounts.
- Compare products across RAM configurations.
- Analyze customer ratings and reviews.
- Identify popular products.
- Rank products based on price and customer engagement.
- Identify high-performing products.
- Create useful product segments.
- Generate business-focused product insights.

---

## 📊 Dataset

The dataset contains **62 Apple product records and 11 columns**.

| Column | Description |
|---|---|
| `product_name` | Apple product name |
| `product_url` | Product page URL |
| `brand` | Product brand |
| `sale_price` | Current selling price |
| `mrp` | Maximum retail price |
| `discount_percentage` | Recorded discount percentage |
| `number_of_ratings` | Number of customer ratings |
| `number_of_reviews` | Number of customer reviews |
| `upc` | Unique product code |
| `star_rating` | Customer star rating |
| `ram` | RAM configuration |

---

# 🛠️ Technologies Used

- **PostgreSQL**
- **SQL**
- **pgAdmin**
- **Microsoft Excel**
- **Power BI**
- **DAX**
- **Power Query**
- **Git & GitHub**

---

# 🔍 Business Questions

## 🟡 Product & Pricing Analysis

1. Which RAM configuration has the highest average sale price?
2. Which RAM configuration has the lowest average sale price?
3. What is the average discount percentage for each RAM configuration?
4. Which RAM configuration has the highest average star rating?
5. Which products have a sale price below the overall average sale price?
6. Which products are priced above the overall average MRP?
7. What is the average price difference between MRP and sale price?
8. Which products offer the highest absolute discount amount?

## ⭐ Customer Engagement Analysis

9. Which products have the highest number of customer reviews?
10. Which products have a high number of ratings but a below-average star rating?
11. What percentage of total ratings does each product contribute?
12. Which products have the highest rating-to-review ratio?
13. Which products have above-average ratings and above-average customer ratings volume?
14. Which RAM configuration has the highest average number of customer ratings?

## 📊 Advanced Product Analysis

15. Rank all products by sale price using `RANK()`.
16. Rank products within each RAM configuration using `ROW_NUMBER()`.
17. Calculate the actual discount percentage and compare it with the recorded discount percentage.
18. Find the top 10 products using a combined popularity score.
19. Identify products whose sale price is lower than their RAM configuration's average sale price.
20. Find the highest-rated product within each RAM configuration.
21. Create product price segments using `CASE`.
22. Create product performance categories using price, rating, discount, and popularity.
23. Find the top 3 products within each RAM configuration.
24. Identify products with high ratings but low discounts.
25. Identify products with high discounts but low ratings.

---

# 📈 Key KPIs

| KPI | Description |
|---|---|
| 🍎 Total Products | Total Apple products |
| 💰 Average Sale Price | Average selling price |
| 🏷️ Average MRP | Average maximum retail price |
| 💸 Average Discount | Average discount percentage |
| ⭐ Average Rating | Average customer rating |
| 👥 Total Ratings | Total customer ratings |
| 💬 Total Reviews | Total customer reviews |
| 💰 Average Discount Amount | Average MRP − Sale Price |
| 🏆 Top Product | Highest-performing product |
| 💾 RAM Configurations | Number of unique RAM options |

---

# 🧮 Sample SQL Analysis

## Average Sale Price by RAM

```sql
SELECT
    ram,
    ROUND(AVG(sale_price), 2) AS avg_sale_price
FROM apple_products
GROUP BY ram
ORDER BY avg_sale_price DESC;

Highest-Rated Product by RAM
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
WHERE rating_rank = 1;
Product Rating Contribution
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
Product Discount Analysis
SELECT
    product_name,
    mrp,
    sale_price,
    ROUND(
        ((mrp - sale_price) / NULLIF(mrp, 0)) * 100,
        2
    ) AS calculated_discount_percentage,
    discount_percentage AS recorded_discount_percentage
FROM apple_products
ORDER BY calculated_discount_percentage DESC;
Rating-to-Review Ratio
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
