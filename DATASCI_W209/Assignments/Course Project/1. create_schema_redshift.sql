CREATE TABLE trips 
(
  id      					INTEGER NOT NULL,
  cab_type_id    			INTEGER NULL,
  vendor_id      			VARCHAR(50) NULL,
  pickup_datetime        	TIMESTAMP NULL,
  dropoff_datetime       	TIMESTAMP NULL,
  store_and_fwd_flag        VARCHAR(10) NULL,
  rate_code_id        		INTEGER NULL,
  pickup_longitude   		NUMERIC(38,12) NULL,
  pickup_latitude			NUMERIC(38,12) NULL,
  dropoff_longitude			NUMERIC(38,12) NULL,
  dropoff_latitude			NUMERIC(38,12) NULL,
  passenger_count			INTEGER NULL,
  trip_distance				NUMERIC(38,12) NULL,
  fare_amount				NUMERIC(38,12) NULL,
  extra						NUMERIC(38,12) NULL,
  mta_tax					NUMERIC(38,12) NULL,
  tip_amount				NUMERIC(38,12) NULL,
  tolls_amount				NUMERIC(38,12) NULL,
  ehail_fee					NUMERIC(38,12) NULL,
  improvement_surcharge	    NUMERIC(38,12) NULL,
  total_amount				NUMERIC(38,12) NULL,
  payment_type				VARCHAR(50) NULL,
  trip_type					INTEGER NULL,
  pickup_nyct2010_gid		INTEGER NULL,
  dropoff_nyct2010_gid		INTEGER NULL,
  pickup					VARCHAR(500) NULL,
  dropoff					VARCHAR(500) NULL
);


CREATE TABLE uber_trips_2015 (
    id integer NOT NULL,
    dispatching_base_num VARCHAR(100) NULL,
    pickup_datetime TIMESTAMP NULL,
    affiliated_base_num VARCHAR(50) NULL,
    location_id INTEGER NULL,
    nyct2010_ntacode VARCHAR(100) NULL
);

CREATE TABLE uber_taxi_zone_lookups (
    location_id INTEGER NOT NULL,
    borough VARCHAR(100) NULL,
    zone VARCHAR(100) NULL,
    nyct2010_ntacode VARCHAR(100) NULL
);

CREATE TABLE central_park_weather_observations_raw (
    station_id VARCHAR(50) NULL,
    station_name VARCHAR(50) NULL,
    date DATE NULL,
    precipitation_tenths_of_mm NUMERIC(38,12) NULL,
    snow_depth_mm NUMERIC(38,12) NULL,
    snowfall_mm NUMERIC(38,12) NULL,
    max_temperature_tenths_degrees_celsius NUMERIC(38,12) NULL,
    min_temperature_tenths_degrees_celsius NUMERIC(38,12) NULL,
    average_wind_speed_tenths_of_meters_per_second NUMERIC(38,12) NULL
);

CREATE TABLE cab_types (
    id INTEGER NOT NULL,
    type VARCHAR(10) NULL
);

CREATE TABLE nyct2010 (
    gid INTEGER NOT NULL,
    ctlabel VARCHAR(50) NULL,
    borocode VARCHAR(50) NULL,
    boroname VARCHAR(50) NULL,
    ct2010 VARCHAR(50) NULL,
    boroct2010 VARCHAR(50) NULL,
    cdeligibil VARCHAR(50) NULL,
    ntacode VARCHAR(50) NULL,
    ntaname VARCHAR(100) NULL,
    puma VARCHAR(50) NULL,
    shape_leng NUMERIC(38,12) NULL,
    shape_area NUMERIC(38,12) NULL,
    the_geom VARCHAR(500) NULL
    );