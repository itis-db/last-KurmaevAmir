WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS year_month,
        SUM(oi.amount) AS total_sales
    FROM orders o
             JOIN order_items oi ON o.id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)
),
     joined AS (
         SELECT
             curr.year_month,
             curr.total_sales,
             prev.total_sales AS prev_month_sales,
             last_year.total_sales AS prev_year_sales
         FROM monthly_sales curr
                  LEFT JOIN monthly_sales prev
                            ON curr.month = prev.month + INTERVAL '1 month'
                  LEFT JOIN monthly_sales last_year
                            ON curr.month = last_year.month + INTERVAL '1 year'
     )
SELECT
    year_month,
    total_sales,
    ROUND(
            CASE
                WHEN prev_month_sales IS NULL OR prev_month_sales = 0 THEN NULL
                ELSE (total_sales - prev_month_sales) / prev_month_sales * 100
                END, 2
    ) AS prev_month_diff,
    ROUND(
            CASE
                WHEN prev_year_sales IS NULL OR prev_year_sales = 0 THEN NULL
                ELSE (total_sales - prev_year_sales) / prev_year_sales * 100
                END, 2
    ) AS prev_year_diff
FROM joined
ORDER BY year_month;
