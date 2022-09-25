{{
    config(
        materialized='view'
    )
}}

WITH q1 AS (
    WITH taiwan_vendor AS (
        SELECT Vendors.vendor_name, ROUND(SUM(Orders.gmv_local), 2) AS total_gmv, COUNT(Orders.country_name) AS customer_count,
               ROW_NUMBER() OVER (PARTITION BY Vendors.vendor_name
                                  ORDER BY SUM(Orders.gmv_local) DESC) row_num
        FROM `bigquery.tables.datawarhouse.orders` AS Orders
        LEFT JOIN `bigquery.tables.datawarhouse.vendors` AS Vendors
            ON Orders.vendor_id = Vendors.id
        GROUP BY Orders.country_name, Vendors.vendor_name
        HAVING Orders.country_name lIKE 'Taiwan' 
    )

    SELECT vendor_name, customer_count, total_gmv
    FROM taiwan_vendor
    WHERE row_num < 2
    ORDER BY customer_count DESC;
)