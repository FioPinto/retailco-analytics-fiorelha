--SELECT LISTAGG(COLUMN_NAME || ' AS ' || SUBSTR(COLUMN_NAME, 3), ',\n')
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = 'CUSTOMER';

--SELECT
--    A
--FROM {{ source('raw', 'customer') }}

{{clean_columns(source('raw', 'customer'),2)}}