-- hospitals

-- Need create statement, remove spaces and quotes

select 
       h."Provider ID",
       h."HospitalName",
       h."City",
       h."State",
       h."HospitalType",
       h."HospitalOwnership",
       h."EmergencyServices"
       from public.hospitals as h



-- hospitalTypeCountsGranular

-- Need create statement, remove spaces and quotes
select 	count(h."Provider ID") cnt,
	h."State",
	h."HospitalType",
	h."HospitalOwnership",
	h."EmergencyServices"
from
(
  
select 
       h."Provider ID",
       h."HospitalName",
       h."City",
       h."State",
       h."HospitalType",
       h."HospitalOwnership",
       h."EmergencyServices"
       from public.hospitals as h
       ) as h group by 2,3,4,5 order by 1 desc


 -- hospitalsReadmissionRatios


 SELECT 
   rr."ProviderNumber"
 , count(rr."MeasureName") as CntProcedures
 , sum(to_number(rr."PredictedReadmissionRate",'9999.9999')) 
   / 
   sum(to_number(rr."ExpectedReadmissionRate",'9999.9999'))  as AggregateReadmissionRatio
FROM 
  public.readmissionreduction as rr
  where 1=1
	 and rr."PredictedReadmissionRate" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 
	  and rr."ExpectedReadmissionRate" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 
        --and cast(rr."PredictedReadmissionRate" as float) is not null
        --and cast(rr."ExpectedReadmissionRate" as float) is not null
   group by 1
   order by 1      