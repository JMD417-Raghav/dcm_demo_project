{{ config(materialized='table') }}

SELECT DISTINCT customer_id
FROM {{ ref('core_orders') }}