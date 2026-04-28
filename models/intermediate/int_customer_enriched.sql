SELECT
    c.customer_sk,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.birth_year,
    c.birth_month,
    c.birth_day,
    c.age,
    c.email_address,
    ca.city,
    ca.state,
    ca.country,
    ca.zip,
    cd.gender,
    cd.marital_status,
    cd.education_status,
    cd.dep_count,
    cd.dep_employed_count,
    cd.dep_college_count,
    hd.income_band_sk,
    hd.buy_potential,
    hd.dep_count AS household_dep_count,
    hd.vehicle_count

FROM {{ ref('stg_raw__customer') }} c

LEFT JOIN {{ ref('stg_raw__customer_address') }} ca
    ON c.CURRENT_ADDR_SK = ca.ADDRESS_SK

LEFT JOIN {{ ref('stg_raw__customer_demogra') }} cd
    ON c.CURRENT_CDEMO_SK = cd.DEMO_SK

LEFT JOIN {{ ref('stg_raw__household_demogra') }} hd
    ON c.CURRENT_HDEMO_SK = hd.DEMO_SK