SELECT *
FROM {{ ref('mart_inventory_health') }}
WHERE
    weeks_of_stock < 0