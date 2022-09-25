{{
    config(
        materialized='view'
    )
}}

WITH q1 AS (
    WITH top_country AS (
        SELECT Orders.country_name, ROUND(SUM(Orders.gmv_local), 2) AS total_gmv,
            ROW_NUMBER() OVER (PARTITION BY Orders.country_name
                                ORDER BY SUM(Orders.gmv_local) DESC) row_num
        FROM `bigquery.tables.datawarhouse.orders` AS Orders
            GROUP BY Orders.country_name
)

    SELECT country_name, total_gmv
    FROM top_country
    WHERE row_num < 2
    ORDER BY total_gmv DESC;
)