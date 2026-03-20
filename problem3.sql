WITH monthly_sales AS (
    SELECT 
        product_id,
        DATE_TRUNC('month', sale_date) AS month,
        SUM(amount) AS monthly_amount
    FROM sales_detailed
    GROUP BY product_id, DATE_TRUNC('month', sale_date)
)
SELECT 
    product_id,
    month,
    monthly_amount,
    COALESCE(
        ROUND(
            (monthly_amount - LAG(monthly_amount) OVER (PARTITION BY product_id ORDER BY month)) * 100.0 
            / LAG(monthly_amount) OVER (PARTITION BY product_id ORDER BY month), 
            2
        ),
        0
    ) AS percent_change
FROM monthly_sales
ORDER BY product_id, month;
