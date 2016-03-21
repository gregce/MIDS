-- redshift data type reference http://docs.aws.amazon.com/redshift/latest/dg/c_Supported_data_types.html

CREATE TABLE trips 
(
  id      					INTEGER NOT NULL,
  cab_type_id    			INTEGER NULL,
  vendor_id      			VARCHAR(50) NULL,
  pickup_datetime        	TIMESTAMP NULL,
  dropoff_datetime       	TIMESTAMP NULL,
  store_and_fwd_flag        VARCHAR(10) NULL,
  rate_code_id        		INTEGER NULL,
  pickup_longitude   		NUMERIC NULL,
  pickup_latitude			NUMERIC NULL,
  dropoff_longitude			NUMERIC NULL,
  dropoff_latitude			NUMERIC NULL,
  passenger_count			INTEGER NULL,
  trip_distance				NUMERIC NULL,
  fare_amount				NUMERIC NULL,
  extra						NUMERIC NULL,
  mta_tax					NUMERIC NULL,
  tip_amount				NUMERIC NULL,
  tolls_amount				NUMERIC NULL,
  ehail_fee					NUMERIC NULL,
  improvement_surcharge	    NUMERIC NULL,
  total_amount				NUMERIC NULL,
  payment_type				VARCHAR(50) NULL,
  trip_type					INTEGER NULL,
  pickup_nyct2010_gid		INTEGER NULL,
  dropoff_nyct2010_gid		INTEGER NULL,
  pickup					VARCHAR(500) NULL,
  dropoff					VARCHAR(500) NULL
);