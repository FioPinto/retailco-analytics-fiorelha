
select S_STORE_ID, S_STORE_NAME from {{ source('raw', 'store') }}