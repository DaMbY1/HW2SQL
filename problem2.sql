WITH product_category_sales AS (
    SELECT 
        product,
        category,
        SUM(amount) AS category_amount
    FROM sales
    GROUP BY product, category
),
ranked_products AS (
    SELECT 
        product,
        category,
        category_amount,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY category_amount DESC) AS rank
    FROM product_category_sales
)
    
SELECT 
    category,
    product
FROM ranked_products
WHERE rank <= 2
ORDER BY category, rank;
