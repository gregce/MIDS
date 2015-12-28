
# coding: utf-8

# ##DATASCI W205 - Exercise 1 - Investigations

# In[1]:

##Import pyspark.sql and hivecontext
from pyspark.sql import *
sqlContext = HiveContext(sc)


# In[2]:

##Check out all tables available in warehouse
sqlContext.sql("show tables").take(100) 


# #### Question 1: What hospitals are models of high-quality care—that is, which hospitals have the most consistently high scores for a variety of procedures?

# In[3]:

t_measuredates = sqlContext.sql("select * from t_measuredates")


# In[13]:

new_df = t_measuredates.toPandas()


# In[4]:

t_measuredates.show()


# In[5]:

##Determine Most important Measure Counts
t_measuredates.groupBy("measurestartquarter","measureendquarter").count().show()


# In[6]:

## Determine categories and procedures to score hospitals on
ecr = sqlContext.sql("select * from t_hospitalseffectivecareranges")
counts = ecr.groupBy('Condition').count()
counts.show()
counts.registerTempTable("counts")


# In[4]:

sql = 'select * from '       't_hospitalseffectivecare'
t_hospitalseffectivecare = sqlContext.sql(sql)

##define representative set of procedures by condition that will be looked at, picked 1 procedure for each condittion
measurenamelist = ['VTE_3', 'CAC_3', 'OP_23', 'OP_2', 'HF_3', 'IMM_2', 'STK_4', 'SCIP_INF_1']

## send to Pandas to easily compute
ecr = t_hospitalseffectivecare.toPandas()

#slice on procedures
sliced_ec = ecr[ecr.measureid.isin(measurenamelist)]

#create a Spark Dataframe
t_hospitalseffectivecare_filtered = sqlContext.createDataFrame(sliced_ec)

#Register as a table
t_hospitalseffectivecare_filtered.registerTempTable("t_hospitalseffectivecare_filtered")


# In[8]:

sqlContext.sql("select * from t_hospitalseffectivecare_filtered").show()


# In[5]:

##look at those procedures measured over a certain period
sql = """SELECT 
       ecf.providerid
      ,ecf.condition
      ,ecf.measureid
      ,ecf.measurename
      ,ecf.score
      ,ecf.sample
      ,m.measurestartquarter
      ,m.measureendquarter
FROM
  t_hospitalseffectivecare_filtered as ecf
  left join
  t_measuredates as m 
  on ecf.measureid = m.measureid  
  where m.measurestartquarter = '4Q2013' and m.measureendquarter = '3Q2014'
  """

t_hospitalseffectivecare_filtered_date = sqlContext.sql(sql)

#Register as a table
t_hospitalseffectivecare_filtered_date.registerTempTable("t_hospitalseffectivecare_filtered_date")


# In[6]:

##aggregate provider procedure scores
sql = """SELECT 
       sum(score) AS score_agg,
       stddev_samp(score) as score_stddev,
       sum(max) AS max_agg,
       sum(score) / sum(max) as perc_score,
       count(measureid) as cnt,
       providerid
FROM
  (SELECT ecf.providerid as providerid,
          ecf.condition as condition,
          ecf.measureid as measureid,
          ecf.measurename as measurename,
          ecf.score as score,
          ecf.sample as sample,
          ecr.max as max
   FROM t_hospitalseffectivecare_filtered_date AS ecf
   LEFT JOIN t_hospitalseffectivecareranges AS ecr ON ecf.measureid = ecr.measureid
   WHERE cast(ecf.sample AS double) > 30) AS x
GROUP BY providerid
ORDER BY cnt desc, perc_score desc, providerid"""

t_hospitalseffectivecare_filtered_scored = sqlContext.sql(sql)
t_hospitalseffectivecare_filtered_scored.registerTempTable("t_hospitalseffectivecare_filtered_scored")


# In[12]:

t_hospitalseffectivecare_filtered_scored.show()


# In[7]:

##exclude those providers with high readmission rations scores (1 = bad, 0 or null OK)
sql = """SELECT 
         score_agg,
         score_stddev,
         max_agg,
         perc_score,
         cnt,
         ecft.providerid,
         rr.aggregateexcessreadmissions
         
         FROM t_hospitalseffectivecare_filtered_scored as ecft
         left join 
              t_hospitalsreadmissionratios as rr
              on ecft.providerid = rr.providerid
         where rr.aggregateexcessreadmissions <> 1
         ORDER BY cnt desc, perc_score desc, providerid
         """

t_hospitalseffectivecare_filtered_scored_cleaned = sqlContext.sql(sql)
t_hospitalseffectivecare_filtered_scored_cleaned.registerTempTable("t_hospitalseffectivecare_filtered_scored_cleaned")


# In[8]:

##join back to provider_ids and calculate the providers with lowest score variability (< 2 stds) and highest aggregates as top 10
sql = """SELECT 
         score_agg,
         score_stddev,
         max_agg,
         perc_score,
         cnt,
         ecftc.providerid,
         aggregateexcessreadmissions,
         h.hospitalname,
         h.state,
         h.hospitaltype
         
         FROM t_hospitalseffectivecare_filtered_scored_cleaned as ecftc
         inner join 
              t_hospitals as h
              on ecftc.providerid = h.providerid
         where score_stddev < 2
         ORDER BY cnt desc, perc_score desc, providerid
         """

t_best_hospitals = sqlContext.sql(sql)
#t_best_hospitals.show()


# In[9]:

## send to Pandas finalize
best_hospitals_df = t_best_hospitals.toPandas()


# In[10]:

out = best_hospitals_df[['hospitalname','score_agg','perc_score','score_stddev']].head(10)


# In[11]:

out.to_csv("/usr/local/w205-hw/exercise_1/investigations/best_hospitals/best_hospitals.txt")


# #### Question 2: What states are models of high-quality care?

# In[12]:

#register table from answering question 1
#create a Spark Dataframe
t_best_hospitals = sqlContext.createDataFrame(best_hospitals_df)

#Register as a table
t_best_hospitals.registerTempTable("t_best_hospitals")


# In[13]:

t_best_hospitals.schema.fields


# In[14]:

##Recompute state scores on procedures using a similar methodology (based on the best hosptials)
sql = """SELECT 
       sum(score_agg) AS score_agg,
       stddev_samp(score_agg) as score_stddev,
       sum(max_agg) AS max_agg,
       sum(score_agg) / sum(max_agg) as perc_score,
       count(providerid) as cnt_providers,
       state
FROM
       t_best_hospitals AS x
GROUP BY state
ORDER BY cnt_providers desc, perc_score desc, state"""


t_best_states = sqlContext.sql(sql)
t_best_states.registerTempTable("t_best_states")


# In[17]:

#write output
#t_best_states.show()
best_states_df = t_best_states.toPandas()
out = best_states_df[['state','score_agg','perc_score','score_stddev']].head(10)
out.to_csv("/usr/local/w205-hw/exercise_1/investigations/best_states/best_states.txt")


# In[15]:

t_best_states.count()


# ####Question 3: Which procedures have the greatest variability between hospitals?  
# 

# In[26]:

##Review variability in scores, not just those originally sampled

##look at all procedures measured over a certain period 4Q2013 and 3Q2014
sql = """SELECT 
       variance(score) AS score_variance,
       stddev_samp(score) as score_stddev,
       count(measureid) as cnt,
       measurename
  FROM
  (SELECT ecf.providerid as providerid,
          ecf.condition as condition,
          ecf.measureid as measureid,
          ecf.measurename as measurename,
          ecf.score as score,
          ecf.sample as sample,
          ecr.max as max
   FROM t_hospitalseffectivecare AS ecf
   LEFT JOIN t_hospitalseffectivecareranges AS ecr ON ecf.measureid = ecr.measureid
   LEFT JOIN t_measuredates as m on ecf.measureid = m.measureid  
   WHERE cast(ecf.sample AS double) > 30 and ecr.max = 100
         and m.measurestartquarter = '4Q2013' and m.measureendquarter = '3Q2014'
   
   ) AS x
GROUP BY measurename
ORDER BY score_variance desc, cnt desc, measurename"""


t_scorevariability = sqlContext.sql(sql)

#Register as a table
t_scorevariability.registerTempTable("t_scorevariability")
##t_scorevariability.show()

#write output
#t_scorevariability.show()
scorevariability_df = t_scorevariability.toPandas()
out = scorevariability_df[['score_variance','score_stddev','cnt','measurename']].head(10)
out.to_csv("/usr/local/w205-hw/exercise_1/investigations/hospital_variability/scorevariability.txt")


# ####Question 4: Are average scores for hospital quality or procedural variability correlated with patient survey responses?
# 
# 

# In[35]:

##Just look at correlation between hospital quality and patient survey responses... More indicative IMO
##

#import seaborn as sns
#import matplotlib.pyplot as plt
##sns.pairplot(nba[["ast", "fg", "trb"]])
##plt.show()

#print(df.corr())

sql = """SELECT 
         ecftc.perc_score,
         hess.scaledscoreaverage,
         ecftc.providerid,
         h.hospitalname,
         h.state,
         h.hospitaltype
         FROM t_hospitalseffectivecare_filtered_scored_cleaned as ecftc
         inner join 
              t_hospitals as h
              on ecftc.providerid = h.providerid
         inner join
              t_hospitalspatientexperiencescaledscore as hess
               on ecftc.providerid = hess.providerid
         ORDER BY perc_score desc, providerid
         """

t_quality_to_experience_correlation = sqlContext.sql(sql)

#Register as a table
t_quality_to_experience_correlation.registerTempTable("t_quality_to_experience_correlation")

quality_to_experience_correlation_df = t_quality_to_experience_correlation.toPandas()


# In[38]:

quality_to_experience_correlation_df[['perc_score','scaledscoreaverage']]


# In[43]:

print(quality_to_experience_correlation_df[['perc_score','scaledscoreaverage']].corr())


# In[51]:

out = quality_to_experience_correlation_df[['perc_score','scaledscoreaverage']].corr()
out.to_csv("/usr/local/w205-hw/exercise_1/investigations/hospitals_and_patients/qualitycorrelation.txt")

