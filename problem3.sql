WITH monthly_sales AS (
    -- Группируем по товару и месяцу. Решение работает в рамках предположения о том, что все происходит в пределах одного года
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
    -- Процент изменения относительно предыдущего месяца
    CASE 
        WHEN LAG(monthly_amount) OVER (PARTITION BY product_id ORDER BY month) IS NOT NULL 
        THEN ROUND(
            (monthly_amount - LAG(monthly_amount) OVER (PARTITION BY product_id ORDER BY month)) * 100.0 
            / LAG(monthly_amount) OVER (PARTITION BY product_id ORDER BY month), 
            2
        )
        ELSE NULL  -- для первого месяца нет предыдущего
    END AS percent_change
FROM monthly_sales
ORDER BY product_id, month;
