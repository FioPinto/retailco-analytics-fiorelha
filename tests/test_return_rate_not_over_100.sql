SELECT *
FROM {{ ref('mart_sales_by_channel') }}
WHERE return_rate > 1