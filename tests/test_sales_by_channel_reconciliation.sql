SELECT
    SUM(m.revenue) AS mart_revenue,
    (
        SELECT SUM(net_paid)
        FROM {{ ref('int_unified_sales') }}
    ) AS source_revenue
FROM {{ ref('mart_sales_by_channel') }} m
HAVING SUM(m.revenue) != (
    SELECT SUM(net_paid)
    FROM {{ ref('int_unified_sales') }}
)