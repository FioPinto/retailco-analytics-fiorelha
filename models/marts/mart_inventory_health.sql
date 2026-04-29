WITH inventory_weekly AS (
    SELECT
        item_sk,
        d.week_seq,
        d.year,
        AVG(quantity_on_hand) AS avg_stock
    FROM {{ ref('stg_raw__inventory') }} i
    LEFT JOIN {{ ref('stg_raw__date_dim') }} d
        ON i.date_sk = d.date_sk
    GROUP BY 1,2,3
),

sales_with_week AS (
    SELECT
        item_sk,
        d.week_seq,
        d.year,
        SUM(quantity) AS weekly_sales
    FROM {{ ref('int_unified_sales') }} s
    LEFT JOIN {{ ref('stg_raw__date_dim') }} d
        ON s.date_sk = d.date_sk
    GROUP BY 1,2,3
),

wos AS (
    SELECT
        i.item_sk,
        i.week_seq,
        i.year,
        i.avg_stock,
        s.weekly_sales,
        i.avg_stock / NULLIF(s.weekly_sales,0) AS weeks_of_stock
    FROM inventory_weekly i
    LEFT JOIN sales_with_week s
        ON i.item_sk = s.item_sk
        AND i.week_seq = s.week_seq
        AND i.year = s.year
),

stockout AS (
    SELECT
        item_sk,
        week_seq,
        year,
        CASE
            WHEN avg_stock = 0 OR avg_stock IS NULL THEN 1
            ELSE 0
        END AS stockout_flag
    FROM inventory_weekly
),

trend AS (
    SELECT
        item_sk,
        week_seq,
        year,
        weekly_sales,
        AVG(weekly_sales) OVER (
            PARTITION BY item_sk
            ORDER BY year, week_seq
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) AS rolling_avg_sales,

        LAG(weekly_sales) OVER (
            PARTITION BY item_sk
            ORDER BY year, week_seq
        ) AS prev_week_sales
    FROM sales_with_week
),

trend_final AS (
    SELECT *,
        CASE
            WHEN rolling_avg_sales > prev_week_sales THEN 'growing'
            WHEN rolling_avg_sales < prev_week_sales THEN 'declining'
            ELSE 'stable'
        END AS trend
    FROM trend
)

SELECT
    w.item_sk,
    w.week_seq,
    w.year,
    w.avg_stock,
    w.weekly_sales,
    w.weeks_of_stock,
    s.stockout_flag,
    t.trend
FROM wos w

LEFT JOIN stockout s
    ON w.item_sk = s.item_sk
    AND w.week_seq = s.week_seq
    AND w.year = s.year

LEFT JOIN trend_final t
    ON w.item_sk = t.item_sk
    AND w.week_seq = t.week_seq
    AND w.year = t.year