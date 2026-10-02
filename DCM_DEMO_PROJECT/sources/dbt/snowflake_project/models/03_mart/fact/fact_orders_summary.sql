{{ config(materialized='table') }}

SELECT
    customer_id,
    COUNT(*) AS order_count,
    SUM(amount) AS total_spent
FROM {{ ref('core_orders') }}
GROUP BY customer_id