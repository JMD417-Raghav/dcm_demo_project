{{ config(materialized='table') }}

SELECT
    order_id,
    customer_id,
    order_date,
    amount
FROM {{ source('dcm_raw', 'ORDERS_RAW') }}