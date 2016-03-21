CREATE TABLE gregce.downsampled_trips AS
select * 
from trips
order by md5('seed' || ID)
limit 3492576;