WITH catalog_returns AS (
    SELECT
        'catalog' AS return_channel,
        returned_date_sk AS date_sk,
        returned_time_sk AS time_sk,
        item_sk,
        coalesce(returning_customer_sk, refunded_customer_sk) AS customer_sk,
        refunded_customer_sk,
        NULL AS store_sk,
        warehouse_sk,
        NULL AS web_page_sk,
        call_center_sk,
        order_number AS order_id,
        return_quantity,
        return_amount,
        return_tax,
        fee,
        return_ship_cost,
        refunded_cash,
        store_credit AS account_credit,
        reversed_charge,
        net_loss
       
    FROM {{ ref('stg_raw__catalog_returns') }}
),

store_returns AS (
    SELECT
        'store' AS return_channel,
        returned_date_sk AS date_sk,
        return_time_sk AS time_sk,
        item_sk,
        customer_sk AS customer_sk,
        customer_sk AS refunded_customer_sk,
        store_sk,
        NULL AS warehouse_sk,
        NULL AS web_page_sk,
        NULL AS call_center_sk,
        ticket_number AS order_id,
        return_quantity,
        RETURN_AMT AS return_amount,
        return_tax,
        fee,
        return_ship_cost,
        refunded_cash,
        0 AS account_credit,
        reversed_charge,
        net_loss
        
    FROM {{ ref('stg_raw__store_returns') }}
),

web_returns AS (
    SELECT
        'web' AS return_channel,
        returned_date_sk AS date_sk,
        returned_time_sk AS time_sk,
        item_sk,
        coalesce(returning_customer_sk, refunded_customer_sk) AS customer_sk,
        refunded_customer_sk,
        NULL AS store_sk,
        NULL AS warehouse_sk,
        web_page_sk,
        NULL AS call_center_sk,
        order_number AS order_id,
        return_quantity,
        RETURN_AMT AS return_amount,
        return_tax,
        fee,
        return_ship_cost,
        refunded_cash,
        account_credit,
        reversed_charge,
        net_loss
    FROM {{ ref('stg_raw__web_returns') }}

)

select * from store_returns
union all
select * from catalog_returns
union all
select * from web_returns