CREATE TABLE IF NOT EXISTS t_measuredates
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS 
SELECT 
  measuredates.MeasureName, 
  measuredates.MeasureID, 
  measuredates.MeasureStartQuarter, 
  measuredates.MeasureEndQuarter
FROM 
  measuredates;


CREATE TABLE IF NOT EXISTS t_hospitals 
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
SELECT 
       h.ProviderID,
       h.HospitalName,
       h.City,
       h.State,
       h.HospitalType,
       h.HospitalOwnership,
       h.EmergencyServices
from hospitals as h;



CREATE TABLE IF NOT EXISTS t_hospitalsTypeCountsGranular 
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS 
SELECT
count(h.ProviderID) cnt,
h.State,
h.HospitalType,
h.HospitalOwnership,
h.EmergencyServices
from
(
select 
h.ProviderID,
h.HospitalName,
h.City,
h.State,
h.HospitalType,
       h.HospitalOwnership,
       h.EmergencyServices
       from hospitals as h
       ) as h 
group by 
h.State,
h.HospitalType,
h.HospitalOwnership,
h.EmergencyServices;


CREATE TABLE IF NOT EXISTS t_hospitalsReadmissionRatios 
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
 SELECT 
   rr.ProviderID
 , count(rr.MeasureName) as CntProcedures
 , sum(cast(rr.PredictedReadmissionRate as double)) 
   / 
   sum(cast(rr.ExpectedReadmissionRate as double))  as AggregateReadmissionRatio
 , case when 
   sum(cast(rr.PredictedReadmissionRate as double)) 
   / 
   sum(cast(rr.ExpectedReadmissionRate as double)) > 1 then 1 else 0 end as AggregateExcessReadmissions
FROM 
  readmissionreduction as rr
  where 1=1
        and cast(rr.PredictedReadmissionRate as float) is not null
        and cast(rr.ExpectedReadmissionRate as float) is not null
   group by rr.ProviderID;
   

CREATE TABLE IF NOT EXISTS t_hospitalsEffectiveCare 
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
SELECT
 ec.ProviderID 
, ec.Condition
, ec.MeasureID
, ec.MeasureName
, ec.Score
, ec.Sample
FROM 
effective_care as ec 
where 1=1
and cast(ec.Score as float) is not null
and cast(ec.Sample as float) is not null;
	 
 
CREATE TABLE IF NOT EXISTS t_hospitalsEffectiveCareRanges
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
SELECT  
      ec.Condition
    , ec.MeasureName
    , ec.MeasureID
    , min(cast(ec.Score as double)) as Min
    , max(cast(ec.Score as double)) as Max
    , max(cast(ec.Score as double)) 
      -
      min(cast(ec.Score as double)) as MinMaxRange
FROM
(
SELECT 
   ec.ProviderID 
   , ec.Condition
   , ec.MeasureID
   , ec.MeasureName
   , ec.Score
   , ec.Sample
   
FROM 
  effective_care as ec 
where 1=1
 and cast(ec.Score as float) is not null
 and cast(ec.Sample as float) is not null
) as ec
  group by 
  ec.Condition,
  ec.MeasureName,
  ec.MeasureID;



CREATE TABLE IF NOT EXISTS t_hospitalsReadmissionsScaledScoresByCat 
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
select   r.ProviderID
       , r.category 
       , count(*)
       , sum(ScaledScore) as ss
       , (sum(ScaledScore)+count(*))/ cast(count(*) as double) as ratioScore
from
(
select   
   r.ProviderID
 , case when substr(r.MeasureID, 1,1) = 'M' then 'MORT'
        when substr(r.MeasureID, 1,1) = 'R' then 'READM' end as category
 , case when r.ComparedtoNational = 'No different than the National Rate' then 0
when r.ComparedtoNational = 'Better than the National Rate' then 1
when r.ComparedtoNational = 'Worse than the National Rate' then -1 end as ScaledScore
from
      readmissions as r 
where  (r.ComparedtoNational = 'No different than the National Rate'
    or r.ComparedtoNational = 'Better than the National Rate'
or r.ComparedtoNational = 'Worse than the National Rate')
) as r group by 
 r.ProviderID
 , r.category;
 
 

 CREATE TABLE IF NOT EXISTS t_hospitalsPatientExperienceScaledScore 
 row format
 delimited fields terminated by ',' 
 STORED AS RCFile
 AS
 SELECT 
   pe.ProviderID, 
   pe.CommunicationwithNursesDimensionScore, 
   pe.CommunicationwithDoctorsDimensionScore, 
   pe.ResponsivenessofHospitalStaffDimensionScore, 
   pe.PainManagementDimensionScore, 
   pe.CommunicationaboutMedicinesDimensionScore, 
   pe.CleanlinessandQuietnessofHospitalEnvironmentDimensionScore, 
   pe.DischargeInformationDimensionScore, 
   pe.OverallRatingofHospitalDimensionScore, 
   pe.HCAHPSBaseScore, 
   pe.HCAHPSConsistencyScore,
   cast(pe.HCAHPSBaseScore as float)/80 as ScaledScoreAverage
 FROM 
   hosp_patientexperience as pe
   where 1=1
   and cast(pe.HCAHPSBaseScore as float) is not null;
