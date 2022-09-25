{{
    config(
        materialized='view'
    )
}}

WITH q3 AS (
    WITH top_vendor AS (
        SELECT Orders.country_name, Vendors.vendor_name, ROUND(SUM(Orders.gmv_local), 2) AS total_gmv,
               ROW_NUMBER() OVER (PARTITION BY Orders.country_name
                                  ORDER BY SUM(Orders.gmv_local) DESC) row_num
        FROM `bigquery.tables.datawarhouse.orders` AS Orders
        LEFT JOIN `bigquery.tables.datawarhouse.vendors` AS Vendors
            ON Orders.vendor_id = Vendors.id
        GROUP BY Orders.country_name, Vendors.vendor_name
    )

    SELECT country_name, vendor_name, total_gmv
    FROM top_vendor
    WHERE row_num < 2
    ORDER BY country_name, total_gmv DESC;
)