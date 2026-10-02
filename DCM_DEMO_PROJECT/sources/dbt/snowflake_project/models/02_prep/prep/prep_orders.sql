{{ config(materialized='table') }}

SELECT DISTINCT
    order_id,
    customer_id,
    order_date,
    amount
FROM {{ ref('stg_orders') }}
WHERE amount IS NOT NULL