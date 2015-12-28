DROP TABLE IF EXISTS cp_movie_companies;
CREATE TABLE cp_movie_companies(
    id int,
    movie_id int,                       
    company_id int,                     
    company_type_id int,                
    note string                                                  
)
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
  stored as textfile 
  LOCATION '/root/persist/data/cp_imdb_db/movie_companies/';


DROP TABLE IF EXISTS cp_company_name;
CREATE TABLE cp_company_name(
    id int,
    name string,                                           
    country_code string,   
    imdb_id int,                      
    name_pcode_nf string,    
    name_pcode_sf string     
)
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
  stored as textfile 
  LOCATION '/root/persist/data/cp_imdb_db/company_name/';



DROP TABLE IF EXISTS cp_char_name;
CREATE TABLE cp_char_name(
id int,
name string,
imdb_index string,
imdb_id int,
name_pcode_nf string,
surname_pcode string
)
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
  stored as textfile 
  LOCATION '/root/persist/data/cp_imdb_db/char_name/';


DROP TABLE IF EXISTS cp_cast_info;
CREATE TABLE cp_cast_info(
      id int,
      person_id int,                       
      movie_id int,                     
      person_role_id int,                
      note string,
  nr_order int,
  role_id int                                            
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/cast_info/';

DROP TABLE IF EXISTS cp_aka_title;
CREATE TABLE cp_aka_title(
      id int,
      movie_id int,                       
      title string,                     
      imdb_index string,                
      kind_id int,
      production_year int,
      phonetic_code string,
      episode_of_id int,                
      season_nr int,
      episode_nr int,
      note string                                           
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/aka_title/';

DROP TABLE IF EXISTS cp_person_info;
CREATE TABLE cp_person_info(
      id int,
      person_id int,                       
      info_type_id int,                     
      info string,                
      note string                    
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/person_info/';

DROP TABLE IF EXISTS cp_name;
CREATE TABLE cp_name(
      id int,
      name string,                       
      imdb_index string,                     
      imdb_id int, 
  gender string,               
      name_pcode_cf string,
    name_pcode_nf string,
    surname_pcode string
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/name/';


DROP TABLE IF EXISTS cp_aka_name;
CREATE TABLE cp_aka_name(
      id int,
      name string,                       
      imdb_index string,                     
      imdb_id int,                
      name_pcode_cf string,
  name_pcode_nf string,
  surname_pcode string
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/aka_name/';



DROP TABLE IF EXISTS cp_keyword;
CREATE TABLE cp_keyword(
    id int,
    keyword string   
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/keyword/';




DROP TABLE IF EXISTS cp_movie_keyword;
CREATE TABLE cp_movie_keyword(
    movie_id int,
    keyword_id int   
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/movie_keyword/';



DROP TABLE IF EXISTS cp_movie_link;
CREATE TABLE cp_movie_link(
      id int,
      movie_id int,                       
      linked_movie_id int,                     
      link_type_id int                

  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/movie_link/';

DROP TABLE IF EXISTS cp_movie_info;
CREATE TABLE cp_movie_info(
      id int,
      movie_id int,                       
      info_type_id int,                     
      info string,
  note string                

  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/movie_info/';


DROP TABLE IF EXISTS cp_movie_info;
CREATE TABLE cp_movie_info(
      id int,
      movie_id int,                       
      info_type_id int,                     
      info string,
  note string                

  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/movie_info/';



DROP TABLE IF EXISTS cp_movie_info_idx;
CREATE TABLE cp_movie_info_idx(
      movie_id int,
      info_type_id int,                       
      info string,                     
      note string
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/movie_info_idx/';


DROP TABLE IF EXISTS cp_title;
CREATE TABLE cp_title(
    id int,
    title string,                       
    imdb_index string,                     
    kind_id int,                
    production_year int,
    imdb_id int,
    phonetic_code string,
    episode_of_id int,
    season_nr int,
    episode_nr int,
    series_years string
  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/title/';



DROP TABLE IF EXISTS cp_complete_cast;
CREATE TABLE cp_complete_cast(
      id int,
      movie_id int,                       
      subject_id int,                     
      status_id int

  )
    ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
    stored as textfile 
    LOCATION '/root/persist/data/cp_imdb_db/complete_cast/';



DROP TABLE IF EXISTS cp_finalresults;
CREATE TABLE cp_movie_companies(
    id int,
    movie_id int,                       
    company_id int,                     
    company_type_id int,                
    note string                                                  
)
  ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
  stored as textfile 
  LOCATION '/root/persist/data/cp_imdb_db/movie_companies/';
