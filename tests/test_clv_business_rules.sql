SELECT *
FROM {{ ref('mart_customer_lifetime_value') }}
WHERE
    (clv > 0 AND total_transactions = 0)
    OR return_rate > 1