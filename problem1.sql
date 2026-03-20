SELECT 
    id,
    amount,
    amount / SUM(amount) OVER() AS sale_percentage,
    SUM(amount) OVER() AS total_amount
FROM sales;
