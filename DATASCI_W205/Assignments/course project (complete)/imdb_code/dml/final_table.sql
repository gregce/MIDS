
CREATE TABLE IF NOT EXISTS cp_title_temp 
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
select max(cp.id) as movie_id
      ,cp.title as title
      ,cp.production_year as production_year 
      ,ml.string_movie as string_movie
from cp_title as cp inner join
(select regexp_replace(movie, '\\s*', '') as title, movie as string_movie from movies_list) as ml
on regexp_replace(cp.title, '\\s*', '') = ml.title where cp.kind_id = "1" and cp.production_year = "2015"
group by cp.title, cp.production_year, ml.string_movie
order by title;

CREATE TABLE IF NOT EXISTS cp_finalresults_temp
row format
delimited fields terminated by ',' 
STORED AS RCFile 
AS
select 
       title.title
      ,title.production_year 
      ,se.se_ratio 
from cp_title_temp as title inner join 
     (select movie_id, sum(positive)/sum(positive+negative) as se_ratio from movie_se_score 
      group by movie_id) as se 
     on title.title = se.movie_id


