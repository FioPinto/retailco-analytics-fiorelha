{{ config(materialized='incremental', unique_key='mart_key') }}

WITH unified_sales AS (
    SELECT * FROM {{ ref('int_unified_sales') }}
),

unified_returns AS (
    SELECT * FROM {{ ref('int_unified_returns') }}
),

item AS (
    SELECT * FROM {{ ref('stg_raw__item') }}
),

final as (
    SELECT
        dd.year,
        dd.moy as month,
        us.sales_channel,
        i.category,
        us.store_sk,
        us.web_site_sk,
        sum(us.net_paid) as revenue,
        sum(us.net_paid) - sum(coalesce(ur.return_amount,0)) as net_revenue,
        sum(coalesce(ur.return_amount,0)) / nullif(sum(us.net_paid),0) as return_rate,
        sum(coalesce(us.discount_amount,0)) / nullif(sum(us.sales_price),0) as avg_discount_pct,
        {{ dbt_utils.generate_surrogate_key([
            'dd.year',
            'dd.moy',
            'us.sales_channel',
            'i.category',
            'us.store_sk',
            'us.web_site_sk'
        ]) }} as mart_key
    from unified_sales us

    left join unified_returns ur
        on us.order_id = ur.order_id
        and us.item_sk = ur.item_sk

    left join item i
        on us.item_sk = i.item_sk

    left join {{ ref('stg_raw__date_dim') }} dd
        on us.date_sk = dd.date_sk

    group by 1,2,3,4,5,6
)

select * from final