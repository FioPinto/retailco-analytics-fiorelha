{{ config(materialized='table') }}

---------------------------------

WITH catalog_sales as (
    SELECT
        'catalog' as sales_channel,
        sold_date_sk as date_sk,
        sold_time_sk as time_sk,
        item_sk,
        ship_customer_sk as customer_sk,
        null as store_sk,
        warehouse_sk,
        null as web_site_sk,
        order_number as order_id,
        quantity,
        net_paid,
        net_profit,
        sales_price,
        list_price,
        ext_discount_amt as discount_amount,
        EXT_TAX AS tax
    FROM {{ ref('stg_raw__catalog_sales') }}
),

store_sales as (
    SELECT
        'store' as sales_channel,
        sold_date_sk as date_sk,
        sold_time_sk as time_sk,
        item_sk,
        customer_sk,
        store_sk,
        null as warehouse_sk,
        null as web_site_sk,
        ticket_number as order_id,
        quantity,
        net_paid,
        net_profit,
        sales_price,
        list_price,
        ext_discount_amt as discount_amount,
        EXT_TAX AS tax
    FROM {{ ref('stg_raw__store_sales') }}
),

web_sales as (
    select
        'web' as sales_channel,
        sold_date_sk as date_sk,
        sold_time_sk as time_sk,
        item_sk,
        bill_customer_sk as customer_sk,
        null as store_sk,
        warehouse_sk,
        web_site_sk,
        order_number as order_id,
        quantity,
        net_paid,
        net_profit,
        sales_price,
        list_price,
        ext_discount_amt as discount_amount,
        EXT_TAX AS tax
    from {{ ref('stg_raw__web_sales') }}
)

select * from store_sales
union all
select * from catalog_sales
union all
select * from web_sales