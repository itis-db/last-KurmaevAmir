SELECT
    p.category,
    SUM(oi.amount) AS total_sales,
    ROUND(SUM(oi.amount)::numeric / COUNT(DISTINCT oi.order_id), 2) AS avg_per_order,
    ROUND(
            (SUM(oi.amount) * 100.0) / SUM(SUM(oi.amount)) OVER (),
            2
    ) AS category_share
FROM order_items AS oi
         JOIN products AS p ON oi.product_id = p.id
GROUP BY p.category;