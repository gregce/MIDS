-- redshift data type reference http://docs.aws.amazon.com/redshift/latest/dg/c_Supported_data_types.html

CREATE TABLE bike_stations 
(
  id      					INTEGER NOT NULL,
  name    					VARCHAR(255) NULL,
  latitude   				NUMERIC NULL,
  longitude					NUMERIC NULL,
  nyct2010_gid				INTEGER NULL,
  boroname					VARCHAR(255) NULL,
  ntacode					VARCHAR(255) NULL,
  ntaname					VARCHAR(255) NULL
);

CREATE TABLE bike_trips 
(
  id      					INTEGER NOT NULL,
  trip_duration				NUMERIC NULL,
  start_time				DATE NULL,
  stop_time					DATE NULL,
  start_station_id			INTEGER NOT NULL,
  end_station_id			INTEGER NOT NULL,
  bike_id					INTEGER NOT NULL,
  user_type					VARCHAR(255) NULL,
  birth_year				INTEGER NOT NULL,
  gender					INTEGER NOT NULL);
