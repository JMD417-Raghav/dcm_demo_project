{{ config(materialized='table') }}

SELECT
    order_id,
    customer_id,
    order_date,
    amount,
    CASE WHEN amount >= 0 THEN 'VALID' ELSE 'INVALID' END AS amount_flag
FROM {{ ref('prep_orders') }}