-- t_measurenames 

CREATE TABLE t_measurenames as
SELECT 
  measuredates."Measure Name", 
  measuredates."MeasureID", 
  measuredates."MeasureStartQuarter", 
  measuredates."MeasureEndQuarter"
FROM 
  public.measuredates;




-- t_hospitals

-- Need create statement, remove spaces and quotes
CREATE TABLE t_hospitals as
SELECT 
       h."Provider ID",
       h."HospitalName",
       h."City",
       h."State",
       h."HospitalType",
       h."HospitalOwnership",
       h."EmergencyServices"
       from public.hospitals as h

-- t_hospitalsTypeCountsGranular

-- Need create statement, remove spaces and quotes
CREATE TABLE t_hospitalsTypeCountsGranular AS
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
       ) as h group by 2,3,4,5 


 -- t_hospitalsReadmissionRatios
CREATE TABLE t_hospitalsReadmissionRatios AS
 SELECT 
   rr."ProviderNumber"
 , count(rr."MeasureName") as CntProcedures
 , sum(to_number(rr."PredictedReadmissionRate",'9999.9999')) 
   / 
   sum(to_number(rr."ExpectedReadmissionRate",'9999.9999'))  as AggregateReadmissionRatio
 , case when 
   sum(to_number(rr."PredictedReadmissionRate",'9999.9999')) 
   / 
   sum(to_number(rr."ExpectedReadmissionRate",'9999.9999')) > 1 then 1 else 0 end as AggregateExcessReadmissions
FROM 
  public.readmissionreduction as rr
  where 1=1
	 and rr."PredictedReadmissionRate" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 
	  and rr."ExpectedReadmissionRate" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 
        --and cast(rr."PredictedReadmissionRate" as float) is not null
        --and cast(rr."ExpectedReadmissionRate" as float) is not null
   group by 1
     


-- t_hospitalsEffectiveCare

CREATE TABLE t_hospitalsEffectiveCare AS
SELECT 
   ec."Provider ID" 
   , ec."Condition"
   , ec."MeasureID"
   , ec."MeasureName"
   , ec."Score"
   , ec."Sample"
   
FROM 
  public.effective_care as ec 
where 1=1
	 and ec."Score" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 
	  and ec."Sample" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 


-- t_hospitalsEffectiveCareRanges
CREATE TABLE t_hospitalsEffectiveCareRanges AS
SELECT  
      ec."Condition"
    , ec."MeasureName"
    , ec."MeasureID"
    , min(to_number(ec."Score",'9999.9999')) as Min
    , max(to_number(ec."Score",'9999.9999')) as Max
    , max(to_number(ec."Score",'9999.9999'))
      -
      min(to_number(ec."Score",'9999.9999')) as MinMaxRange
FROM
(
SELECT 
   ec."Provider ID" 
   , ec."Condition"
   , ec."MeasureID"
   , ec."MeasureName"
   , ec."Score"
   , ec."Sample"
   
FROM 
  public.effective_care as ec 
where 1=1
	 and ec."Score" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 
	  and ec."Sample" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 
) as ec
  group by 1,2,3

  

-- t_hospitalsReadmissions

CREATE TABLE t_hospitalsReadmissions AS
select   r."Provider ID"
       , r."MeasureName"
       , r."MeasureID"
       , r."ComparedtoNational"
       , r."Denominator"
       , r."Score"
        from
public.readmissions as r


-- t_hospitalsReadmissionsScaledScoresByCat
CREATE TABLE t_hospitalsReadmissionsScaledScoresByCat AS
select   r."Provider ID"
       , r."category" 
       , count(*)
       , sum(ScaledScore) as ss
       , (sum(ScaledScore)+count(*))/ cast(count(*) as float) as ratioScore
from
(
select   
   r."Provider ID"
 , case when substring(r."MeasureID" for 1) = 'M' then 'MORT'
        when substring(r."MeasureID" for 1) = 'R' then 'READM' end as category
 , case when r."ComparedtoNational" = 'No different than the National Rate' then 0
	when r."ComparedtoNational" = 'Better than the National Rate' then 1
	when r."ComparedtoNational" = 'Worse than the National Rate' then -1 end as ScaledScore
from
        public.readmissions as r 
	where 1=1
	and r."ComparedtoNational" not in ('Number of Cases Too Small','Not Available')
) as r group by 1,2


-- t_hospitalsPatientExperienceScaledScore
CREATE TABLE t_hospitalsPatientExperienceScaledScore AS
SELECT 
  pe."Provider Number", 
  pe."CommunicationwithNursesDimensionScore", 
  pe."CommunicationwithDoctorsDimensionScore", 
  pe."ResponsivenessofHospitalStaffDimensionScore", 
  pe."PainManagementDimensionScore", 
  pe."CommunicationaboutMedicinesDimensionScore", 
  pe."CleanlinessandQuietnessofHospitalEnvironmentDimensionScore", 
  pe."DischargeInformationDimensionScore", 
  pe."OverallRatingofHospitalDimensionScore", 
  pe."HCAHPSBaseScore", 
  pe."HCAHPSConsistencyScore",
  cast( pe."HCAHPSBaseScore" as float)/80 as ScaledScoreAverage
FROM 
  public.hosp_patientexperience as pe
  where 1=1
	 and pe."HCAHPSBaseScore" ~ '^([0-9]+[.]?[0-9]*|[.][0-9]+)$' = true 



     