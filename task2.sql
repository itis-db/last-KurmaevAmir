SELECT
    o.customer_id,
    o.id AS order_id,
    o.order_date,
    SUM(oi.amount) AS order_total,
    SUM(SUM(oi.amount)) OVER (PARTITION BY o.customer_id) AS total_spent,
    ROUND(AVG(SUM(oi.amount)) OVER (PARTITION BY o.customer_id), 2) AS avg_order_amount,
    SUM(oi.amount) - ROUND(AVG(SUM(oi.amount)) OVER (PARTITION BY o.customer_id), 2) AS difference_from_avg
FROM orders AS o
         JOIN order_items AS oi ON o.id = oi.order_id
GROUP BY o.id, o.customer_id, o.order_date;
