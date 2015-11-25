##############################
## Setup                    
##############################

## Clear environment variables
rm( list = ls())

## Set Working Directory
setwd("MIDS/DATASCI_W241/Assignments/Project/")

## Load relevant libraries
library(pryr)
library(memisc)
library(stringr)
library(dplyr)  
library(ggplot2)
library(data.table)
library(lubridate)
library(RDSTK)

## Define Relevant Functions

coalesce2 <- function(...) {
  Reduce(function(x, y) {
    i <- which(is.na(x))
    x[i] <- y[i]
    x},
    list(...))
}


##############################
## Data Processing                    
##############################

## Read in Data

pd.raw <- read.csv("pilot_data_11-23.csv", header=TRUE, stringsAsFactors=FALSE
               , fileEncoding="latin1", na.strings=c("","NA"))


## General Information DF

pd.gen <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  ##leverage lubridate mdy_hm to convert to dates
  mutate(  gen_StartDate = mdy_hm(V8)
         , gen_EndDate = mdy_hm(V9)
         , gen_TotalTimeSpentMinutes = gen_EndDate - gen_StartDate
  ##leverage cases function from memiscv for label assignment
         , gen_Gender = cases("Male"=Q7==1,
                              "Female"=Q7==2)
         , gen_Age = as.numeric(Q5)+14
         , gen_Education = cases("Less than High School"=Q2==1,
                                "High School / GED"=Q2==2,
                                "Some College"=Q2==3,
                                "2-year College Degree"=Q2==4,
                                "4-year College Degree"=Q2==5,
                                "Masters Degree"=Q2==6,
                                "Doctoral Degree"=Q2==7,
                                "Professional Degree (JD, MD)"=Q2==8)
         , gen_Role = cases("Owner / Founder"=Q53==1,
                            "Executive Officer"=Q53==2,
                            "Director"=Q53==3,
                            "Manager"=Q53==4,
                            "Employee"=Q53==5,
                            "None of these apply"=Q53==6
                            )
         , gen_Industry = cases("Construction"=Q10==1,
                                 "Education"=Q10==2,
                                 "Financial Activities"=Q10==3,
                                 "Health Care or Pharmecuticals"=Q10==4,
                                 "Information"=Q10==5,
                                 "Leisure and Hospitality"=Q10==6,
                                 "Manufacturing"=Q10==7,
                                 "Natural Resources and Mining"=Q10==8,
                                 "Professional and Business Services"=Q10==9,
                                 "Trade, Transportation and Utilites"=Q10==10,
                                 "None of these apply"=Q10==11)
         #, gen_State = as.vector(fromJSON(coordinates2politics(LocationLatitude, LocationLongitude))))$politics.name.1)
         , gen_PageOneTimeMinutes = (as.numeric(Q56_2)-as.numeric(Q56_1))/60
         #, gen_PageOneTimePercentOfTotal = as.numeric(gen_PageOneTimeMinutes)/as.numeric(gen_TotalTimeSpentMinutes)*100
         , gen_PageOneNumberClicks = as.numeric(Q56_4)
         ) %>%
  #Only keep observations that finished
  filter(V10==1) %>%
  ##only retain IPAddress & "gen_" columns
  select(IPAddress = V6, starts_with("gen_"))


## IQ Test Information DF

pd.iq <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  mutate(  iq_Question1Response = Q25
         , iq_Question1CorrectAnswer = ifelse(Q25==1,1,0)
         , iq_Question2Response = Q26
         , iq_Question2CorrectAnswer = ifelse(Q26==3,1,0) 
         , iq_Question3Response = Q27
         , iq_Question3CorrectAnswer = ifelse(Q27==2,1,0)
         , iq_TotalCorrect = iq_Question1CorrectAnswer+iq_Question2CorrectAnswer+iq_Question3CorrectAnswer
         , iq_PercentageCorrect = iq_TotalCorrect/3
         , iq_PageTwoTimeMinutes = (as.numeric(Q57_2)-as.numeric(Q57_1))/60
         , iq_PageTwoNumberClicks = as.numeric(Q57_4)) %>%
  filter(V10==1) %>%
  ##only retain IPAddress & "iq_" columns
  select(IPAddress = V6, starts_with("iq_"))
         
  
## Experiment 1 Information DF

pd.exp1 <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  mutate(  temp_Treat1 = ifelse(Q19==1,"Nonordered chart junk",NA)
          ,temp_Treat2 = ifelse(Q20==1,"Nonordered table",NA)
          ,temp_Treat3 = ifelse(Q21==1,"Nonordered tufte",NA)
          ,temp_Treat4 = ifelse(Q23==1,"Ordered chart junk",NA)
          ,temp_Treat5 = ifelse(Q24==1,"Ordered Table",NA)
          ,temp_Treat6 = ifelse(Q25.1==1,"Ordered tufte",NA)
          ##use coalesce function to get everything in a single column
          ,exp1_Treatment = coalesce2(temp_Treat1,temp_Treat2,temp_Treat3,temp_Treat4,temp_Treat5,temp_Treat6)
          ,exp1_Question1Response = Q27.1
          ,exp1_Question1CorrectAnswer = ifelse(Q27.1==3,1,0)
          ,exp1_Question2Response = Q29
          ,exp1_Question2CorrectAnswer = ifelse(Q29==3,1,0) 
          ,exp1_Question3Response = Q28
          ,exp1_Question3CorrectAnswer = ifelse(Q28==3,1,0)
          ,exp1_Question4Response = Q29
          ,exp1_Question4CorrectAnswer = ifelse(Q29==1,1,0)
          ,exp1_TotalCorrect = exp1_Question1CorrectAnswer+exp1_Question2CorrectAnswer+exp1_Question3CorrectAnswer+exp1_Question4CorrectAnswer
          ,exp1_PercentageCorrect = exp1_TotalCorrect/4
          ,exp1_Question5Response = Q30
          ,exp1_PageThreeTimeMinutes = (as.numeric(Q20_2)-as.numeric(Q20_1))/60
          ,exp1_PageThreeNumberClicks = as.numeric(Q20_4)
  ) %>%
  filter(V10==1) %>%
  ##only retain IPAddress & "iq_" columns
  select(IPAddress = V6, starts_with("exp1_"))


## Recall Information DF
## Could include Treatment but this can be joined on if necessary


pd.recall <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  mutate(    recall_Question1Response = Q31
            ,recall_Question1CorrectAnswer = ifelse(Q31==6,1,0)
            ,recall_Question2Response = Q32
            ,recall_Question2CorrectAnswer = ifelse(Q32==6,1,0) 
            ,recall_TotalCorrect = recall_Question1CorrectAnswer+recall_Question2CorrectAnswer
            ,recall_PercentageCorrect = recall_TotalCorrect/2
            ,recall_PageFourTimeMinutes = (as.numeric(Q34_2)-as.numeric(Q34_1))/60
            ,recall_PageFourNumberClicks = as.numeric(Q34_4)) %>%
  filter(V10==1) %>%
  ##only retain IPAddress & "iq_" columns
  select(IPAddress = V6, starts_with("recall_"))


## Experiment 2 Information DF

pd.exp2 <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  mutate(  temp_Treat1 = ifelse(Q40==1,"Log scatterplot",NA)
           ,temp_Treat2 = ifelse(Q41==1,"No Log scatterplot",NA)
           ,temp_Treat3 = ifelse(Q42==1,"Ordered Table",NA)
           ,temp_Treat4 = ifelse(Q43==1,"Unordered Table",NA)
           ##use coalesce function to get everything in a single column
           ,exp2_Treatment = coalesce2(temp_Treat1,temp_Treat2,temp_Treat3,temp_Treat4)
           ,exp2_Question1Response = Q35_1
           ##Should Question 1 have a correct answer??
           ,exp2_Question2Response = Q36
           ,exp2_Question2CorrectAnswer = ifelse(Q36==1,1,0) 
           ,exp2_Question3Response = Q38
           ,exp2_Question3CorrectAnswer = ifelse(Q28==3,1,0)
           ,exp2_TotalCorrect = #exp2_Question1CorrectAnswer+
            exp2_Question2CorrectAnswer+exp2_Question3CorrectAnswer
           ,exp2_PercentageCorrect = exp2_TotalCorrect/2
           ,exp2_PageFiveTimeMinutes = (as.numeric(Q23_2)-as.numeric(Q23_1))/60
           ,exp2_PageFiveNumberClicks = as.numeric(Q23_4)
  ) %>%
  filter(V10==1) %>%
  ##only retain IPAddress & "iq_" columns
  select(IPAddress = V6, starts_with("exp2_"))


##############################
## Data Output                    
##############################

pd.cleaned <- left_join(pd.gen,pd.iq, by = "IPAddress") %>%
  left_join(pd.exp1, by = "IPAddress") %>%
  left_join(pd.recall, by = "IPAddress") %>%
  left_join(pd.exp2, by = "IPAddress")

## Write Out Data For Easy Import
save(pd.cleaned, file="CourseProjectCleanedData.rda")

