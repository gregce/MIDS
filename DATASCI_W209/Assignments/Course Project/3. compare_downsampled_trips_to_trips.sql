-- Count records from main trips

WITH query
AS (
	SELECT count(*) cnt
		,extract(year FROM pickup_datetime) AS yr
		,cab_type_id
	FROM trips
	GROUP BY 2
		,3
	ORDER BY 3
		,2
	)
SELECT *
	,round(cast(cnt AS NUMERIC) / sum(cnt) OVER () * 100, 2) AS percentage
	,sum(cnt) over() as total_records
FROM query
ORDER BY cab_type_id
	,yr


--- Query to count records from downsampled trips
WITH query
AS (
	SELECT count(*) cnt
		,extract(year FROM pickup_datetime) AS yr
		,cab_type_id
	FROM gregce.downsampled_trips
	GROUP BY 2
		,3
	ORDER BY 3
		,2
	)
SELECT *
	,round(cast(cnt AS NUMERIC) / sum(cnt) OVER () * 100, 2) AS percentage
	,sum(cnt) over() as total_records
FROM query
ORDER BY cab_type_id
	,yr