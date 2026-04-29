WITH mart AS (
    SELECT
        SUM(store_tx) AS store_tx,
        SUM(web_tx) AS web_tx,
        SUM(catalog_tx) AS catalog_tx
    FROM {{ ref('mart_customer_lifetime_value') }}
),

source AS (
    SELECT
        SUM(CASE WHEN sales_channel = 'store' THEN 1 ELSE 0 END) AS store_tx,
        SUM(CASE WHEN sales_channel = 'web' THEN 1 ELSE 0 END) AS web_tx,
        SUM(CASE WHEN sales_channel = 'catalog' THEN 1 ELSE 0 END) AS catalog_tx
    FROM {{ ref('int_unified_sales') }}
)

SELECT *
FROM mart m
CROSS JOIN source s
WHERE
    m.store_tx != s.store_tx
    OR m.web_tx != s.web_tx
    OR m.catalog_tx != s.catalog_tx