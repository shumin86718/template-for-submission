{{
    config(
        materialized='view'
    )
}}

WITH q4 AS (
    WITH top_vendor2 AS (
        SELECT Orders.country_name, Vendors.vendor_name, ROUND(SUM(Orders.gmv_local), 2) AS total_gmv, CAST(Orders.date_local AS datetime) AS year,
               ROW_NUMBER() OVER (PARTITION BY Orders.date_local, Orders.country_name
                                  ORDER BY SUM(Orders.gmv_local) DESC) row_num
        FROM `bigquery.tables.datawarhouse.orders` AS Orders
        LEFT JOIN `bigquery.tables.datawarhouse.vendors` AS Vendors
            ON Orders.vendor_id = Vendors.id
        GROUP BY Orders.date_local, Orders.country_name, Vendors.vendor_name
    )

    SELECT year, country_name, vendor_name, total_gmv
    FROM top_vendor2
    WHERE row_num < 3
    ORDER BY year, country_name ASC;
)