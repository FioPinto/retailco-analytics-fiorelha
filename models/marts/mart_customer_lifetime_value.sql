WITH unified_sales AS (
    SELECT * FROM {{ ref('int_unified_sales') }}
),

unified_returns AS (
    SELECT * FROM {{ ref('int_unified_returns') }}
),

customer_sales AS (
    SELECT
        customer_sk,
        COUNT(*) as total_transactions,
        SUM(net_paid) as lifetime_revenue,
        MIN(date_sk) as first_purchase_sk,
        MAX(date_sk) as last_purchase_sk,
        SUM(CASE WHEN sales_channel = 'store' THEN 1 ELSE 0 END) as store_tx,
        SUM(CASE WHEN sales_channel = 'web' THEN 1 ELSE 0 END) as web_tx,
        SUM(CASE WHEN sales_channel = 'catalog' THEN 1 ELSE 0 END) as catalog_tx
    FROM unified_sales
    GROUP BY 1
),

customer_returns AS (
    SELECT
        customer_sk,
        SUM(return_amount) as total_returns
    FROM unified_returns
    GROUP BY 1
),

final as (
    SELECT
        s.customer_sk,
        s.total_transactions,
        s.lifetime_revenue,
        COALESCE(r.total_returns, 0) as total_returns,
        s.lifetime_revenue - COALESCE(r.total_returns, 0) as clv,
        s.store_tx,
        s.web_tx,
        s.catalog_tx,
        LEAST(
            COALESCE(r.total_returns,0) / NULLIF(s.lifetime_revenue,0),
            1
        ) AS return_rate
    FROM customer_sales s
    LEFT JOIN customer_returns r
        ON s.customer_sk = r.customer_sk
),

percentiles AS (
    SELECT
        PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY clv) as p33,
        PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY clv) as p66
    FROM final
)

SELECT
    f.*,
    {{ clv_segment('f.clv') }} as value_segment
FROM final f
CROSS JOIN percentiles p