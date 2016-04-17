CREATE TABLE gregce.downsampled_trips_all AS
SELECT  'Cabs' as  type
	,    case when cab_type_id = 1 then  'yellow'
			 when cab_type_id = 2  then  'green'
			 when cab_type_id = 3  then  'uber' end as vehicle_type
	,    pickup_datetime as start_time
	,    dropoff_datetime as stop_time
	,    pickup_longitude
	,    pickup_latitude
	,    dropoff_longitude
	,    dropoff_latitude
	,    datediff(seconds, pickup_datetime, dropoff_datetime) as trip_duration_seconds
	,    passenger_count 
	,    trip_distance
	,    tip_amount
	, 	 total_amount
	,    payment_type
FROM gregce.downsampled_trips

union all

SELECT

	   'Bike' as type
	,  'Citibike' as vehicle_type
	,   start_time
	,   stop_time
	,   pickup_longitude
	,   pickup_latitude
	,   dropoff_longitude
	,   dropoff_latitude
	, 	datediff(seconds, start_time, stop_time) as trip_duration_seconds
	,   1 as passenger_count
	,   null as trip_distance
	,   null as tip_amount
    ,   case when datediff(seconds, start_time, stop_time)/60 <= 30 then 4
            when datediff(seconds, start_time, stop_time)/60 <= 120 then 10
            when datediff(seconds, start_time, stop_time)/60 <= 240 then 18 
            when datediff(seconds, start_time, stop_time)/60 <= 720 then 24
            when datediff(seconds, start_time, stop_time)/60 >= 720 then (datediff(seconds, start_time, stop_time)/60) * .0333 end as total_amount
	,   'CRD' as payment_type
FROM gregce.downsampled_bike_trips