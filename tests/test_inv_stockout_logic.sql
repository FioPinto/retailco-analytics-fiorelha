SELECT *
FROM {{ ref('mart_inventory_health') }}
WHERE
    stockout_flag = 1
    AND avg_stock > 0