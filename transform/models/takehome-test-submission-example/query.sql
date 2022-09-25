SELECT YEAR(q4.year) as year,q4.country_name as country, q4.vendor_name as vendor, q4.total_gmv as gmv
FROM {{ref('q4')}} as q4
WHERE year > 2012
GROUP BY year,country, vendor, gmv
ORDER BY gmv DESC
