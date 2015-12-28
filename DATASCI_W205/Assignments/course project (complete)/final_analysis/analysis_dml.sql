CREATE TABLE IF NOT EXISTS cp_finalresults 
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
select 





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