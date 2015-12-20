##############################
## Setup                    
##############################

## Clear environment variables
rm( list = ls())

## Set Working Directory
setwd("C:/Users/marks/OneDrive/School/Field_Experiments")

## Load relevant libraries
library(pryr)
library(memisc)
library(stringr)
library(stargazer)
library(dplyr)  
library(ggplot2)
library(data.table)
library(lubridate)
library(RDSTK)
library(tidyr)

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

pd.raw <- read.csv("Full Data Collection - Cleaned.csv", header=TRUE, stringsAsFactors=FALSE, na.strings=c("","NA"))

#remove dups
by_ips <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  select(V6) %>%
  mutate(ip=V6) %>%
  group_by(V6) %>%
  summarise(bpcnt = count(ip)) 

duplicate_ips <- data.frame(by_ips$bpcnt$x, by_ips$bpcnt$freq)
names(duplicate_ips) <- c("x","freq")

duplicate_ips <- duplicate_ips %>%
  filter(freq>1)

#recreate with dups removed
pd.raw <- pd.raw %>% 
  filter(!(V6 %in% duplicate_ips$x))

## General Information DF

pd.gen <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  ##leverage lubridate mdy_hm to convert to dates
  mutate(  gen_StartDate = mdy_hm(V8)
         , gen_EndDate = mdy_hm(V9)
         , gen_TotalTimeSpentMinutes = gen_EndDate - gen_StartDate
  ##leverage cases function from memiscv for label assignment
         , gen_Gender = cases("Male"=Q7==1,
                              "Female"=Q7==2,
                              "Prefer not to respond"=Q7==3)
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
         , iq_Question2Response = Q59
         , iq_Question2CorrectAnswer = ifelse(Q59==4,1,0) 
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
          ##added this since pages were split up
          ,exp1_PageFourTimeMinutes = (as.numeric(Q71_2)-as.numeric(Q71_1))/60
          ,exp1_PageFourNumberClicks = as.numeric(Q71_4)
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
            ,recall_Invalid = ifelse(!Q63==3,1,0)
            ,recall_TotalCorrect = recall_Question1CorrectAnswer+recall_Question2CorrectAnswer
            ,recall_PercentageCorrect = recall_TotalCorrect/2
            ,recall_PageFiveTimeMinutes = (as.numeric(Q34_2)-as.numeric(Q34_1))/60
            ,recall_PageFiveNumberClicks = as.numeric(Q34_4)) %>%
  filter(V10==1) %>%
  ##only retain IPAddress & "iq_" columns
  select(IPAddress = V6, starts_with("recall_"))


## Experiment 2 Information DF

pd.exp2 <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  mutate(  temp_Treat1 = ifelse(Q40==1,"Log scatterplot",NA)
           ,temp_Treat2 = ifelse(Q58==1,"No Log scatterplot",NA)
           ,temp_Treat3 = ifelse(Q42==1,"Unordered Table",NA)
           ,temp_Treat4 = ifelse(Q43==1,"Ordered Table",NA)
           ##use coalesce function to get everything in a single column
           ,exp2_Treatment = coalesce2(temp_Treat1,temp_Treat2,temp_Treat3,temp_Treat4)
           ,exp2_DisplayedTreatment = Q76
           ,exp2_Question1Response = Q35_1
           ,exp2_Question2Response = Q36
           ,exp2_Question2CorrectAnswer = ifelse(Q36==1,1,0) 
           ##Should Question 1 have a correct answer??
           ,exp2_Question3Response = Q61
           ,exp2_Question3CorrectAnswer = ifelse(Q61==2,1,0) 
           ,exp2_Question4Response = Q62
           ,exp2_Question4CorrectAnswer = ifelse(Q62==2,1,0)
           ,exp2_TotalCorrect = exp2_Question2CorrectAnswer+exp2_Question3CorrectAnswer+exp2_Question4CorrectAnswer
            exp2_Question2CorrectAnswer+exp2_Question3CorrectAnswer+exp2_Question4CorrectAnswer
           ,exp2_PercentageCorrect = exp2_TotalCorrect/3
           ,exp2_PageSixTimeMinutes = (as.numeric(Q23_2)-as.numeric(Q23_1))/60
           ,exp2_PageSixNumberClicks = as.numeric(Q23_4)
           ,exp2_PageSevenTimeMinutes = (as.numeric(Q79_2)-as.numeric(Q79_1))/60
           ,exp2_PageSevenNumberClicks = as.numeric(Q79_4)
  ) %>%
  filter(V10==1) %>%
  ##only retain IPAddress & "iq_" columns
  select(IPAddress = V6, starts_with("exp2_"))

## Final Questions Information DF


pd.fq <- pd.raw %>%
  slice(2:nrow(pd.raw)) %>%
  mutate(finalq_Question1Response = Q38
         ,finalq_Question1CorrectAnswer = ifelse(Q38==5,1,0)
         ,finalq_Question2Response = Q37_1
         ,finalq_Question3Response = Q37_2
         ,finalq_PercentageCorrect = finalq_Question1CorrectAnswer
  ) %>%
  filter(V10==1) %>%
  ##only retain IPAddress & "iq_" columns
  select(IPAddress = V6, starts_with("finalq_"))


##############################
## Data Output                    
##############################

pd.cleaned <- inner_join(pd.gen, pd.iq, by = "IPAddress") %>%
  inner_join(pd.exp1, by = "IPAddress") %>%
  inner_join(pd.recall, by = "IPAddress") %>%
  inner_join(pd.exp2, by = "IPAddress") %>%
  inner_join(pd.fq, by = "IPAddress")


## Write Out Data For Easy Import
save(pd.cleaned, file="CourseProjectCleanedData.rda")
# write.csv(pd.cleaned, file = "CourseProjectCleanedData.csv",row.names=FALSE, na="")


##############################
## Data Analysis                    
##############################


##########################################
# Exploratory Analysis
##########################################

options("scipen"=100, "digits"=4)

#Reoder factors so non-ordered table is the control
pd.cleaned$exp1_Treatment <- factor(pd.cleaned$exp1_Treatment,levels(factor(pd.cleaned$exp1_Treatment))[c(2,1,3,5,4,6)])

#Creating Health Care dummy
pd.cleaned$health_care <- pd.cleaned$gen_Industry == "Health Care or Pharmecuticals"

#Creating treatment variable for experiment 2 that excludes the invalid respondents
pd.cleaned$valid_treat2 <- ifelse(pd.cleaned$exp2_Treatment == "Unordered Table" & pd.cleaned$exp2_DisplayedTreatment != 1, NA, pd.cleaned$exp2_Treatment)
pd.cleaned$valid_treat2 <- factor(pd.cleaned$valid_treat2,levels(factor(pd.cleaned$valid_treat2))[c(4,3,2,1)])
#Creating roll-up ordered variable for experiment 1 to compare ordered overall
pd.cleaned$exp1_Treat_ordered <- ifelse(pd.cleaned$exp1_Treatment == "Ordered Table" | 
                                          pd.cleaned$exp1_Treatment == "Ordered chart junk" | 
                                          pd.cleaned$exp1_Treatment == "Ordered Tufte", 1, 0)

#Create numeric variable for education level. Assumes linearity.
pd.cleaned <- pd.cleaned %>% mutate(Education_Num = cases('0'=gen_Education=="Less than High School",
                       '1'=gen_Education=="High School / GED",
                       '2'=gen_Education=="Some College",
                       '3'=gen_Education=="2-year College Degree",
                       '4'=gen_Education=="4-year College Degree",
                       '5'=gen_Education=="Masters Degree",
                       '6'=gen_Education=="Doctoral Degree"|gen_Education=="Professional Degree (JD, MD)"
                       ))

pd.cleaned$Education_Num <- as.numeric(as.character(pd.cleaned$Education_Num))


  
#Roll up the Job Role into three categories
pd.cleaned <- pd.cleaned %>% mutate(Job_Role = cases('Other'=gen_Role=="None of these apply",
                                                          'Employee'=gen_Role=="Employee",
                                                          'ManagerDirector'=gen_Role=="Manager"|gen_Role=="Director"|gen_Role=="Executive Officer"|gen_Role=="Owner / Founder"
))


#Use the overall pct correct not including question 4.
pd.cleaned <- pd.cleaned %>% mutate(exp1_PctCorrect_q123 = (exp1_Question1CorrectAnswer+exp1_Question2CorrectAnswer+exp1_Question3CorrectAnswer)/3
)
colnames(pd.cleaned)
d<-pd.cleaned

str(d)
##### Check covariate distributions
hist(as.numeric(d$gen_TotalTimeSpentMinutes), breaks = 100)

as.data.frame(prop.table(table(d$gen_Gender)))

hist(as.numeric(d$gen_Age))`

as.data.frame(prop.table(table(d$gen_Education)))

as.data.frame(prop.table(table(d$gen_Role)))

as.data.frame(prop.table(table(d$gen_Industry)))

summary(lm(iq_PercentageCorrect ~ gen_Gender + Education_Num + Job_Role + gen_Industry, d))

d %>%
  dplyr::select(gen_Gender, iq_PercentageCorrect) %>%
  dplyr::group_by(gen_Gender) %>%
  dplyr::summarise(mean(iq_PercentageCorrect))

###
#Experiment 1
###

summary(lm(exp1_TotalCorrect ~ exp1_Treatment, d))

summary(lm(exp1_TotalCorrect ~ exp1_Treatment + gen_Gender + gen_Education + gen_Role + gen_Industry, d))

stargazer(lm(exp1_TotalCorrect ~ exp1_Treatment, d), lm(exp1_TotalCorrect ~ exp1_Treatment + gen_Gender + gen_Education + gen_Role + gen_Industry, d), type = "text")

summary(lm(iq_PercentageCorrect ~ gen_Gender + gen_Education + gen_Role + gen_Industry, d))


d %>%
  dplyr::select(exp1_Treatment, exp1_TotalCorrect) %>%
  dplyr::group_by(exp1_Treatment) %>%
  dplyr::summarise(ate = mean(exp1_TotalCorrect)) %>%
  dplyr::arrange(ate)

###
#Experiment 2
###

summary(lm(exp2_TotalCorrect ~ exp2_Treatment, d))

d %>%
  dplyr::select(exp2_Treatment, exp2_TotalCorrect) %>%
  dplyr::group_by(exp2_Treatment) %>%
  dplyr::summarise(ate = mean(exp2_TotalCorrect)) %>%
  dplyr::arrange(ate)

d %>%
  dplyr::select(exp2_Treatment, exp2_Question1Response) %>%
  dplyr::group_by(exp2_Treatment) %>%
  dplyr::summarise(ate = mean(as.numeric(exp2_Question1Response)) %>%
  dplyr::arrange(ate)

d %>%
  dplyr::filter(exp2_Treatment == 'Unordered Table') %>%
  dplyr::select(exp2_Treatment, exp2_DisplayedTreatment)


ggplot(d, aes(x=d$email)) + geom_histogram(binwidth=.5) ##yep, unbalanced
str(d$gen_Education)

##### Check conversions by treatment w/ dplyr
d.group <- d %>%
  select(email, converted) %>%
  group_by(email) %>%
  summarise(mean(converted))
d.group

##### Build a quick univariate linear model to do the same 
mod.sum <- summary(lm(converted ~ email, d))
##pull out the estimates
ate <- mod.sum$coefficients[2,1]
##compare estimate to difference in means 
##great they're equivalent
c(ate, (as.numeric(d.group[2,2]) - as.numeric(d.group[1,2]))) 

##compute a 95% confidence interval from the regression
## first grab the standard error
se <- mod.sum$coefficients[2,2]
##compute the confidence interval
ci <- c(ate-1.96 *se, ate+1.96*se)

##graph the above
ggplot(d, aes(x=email, y=converted)) +
  geom_point(shape=1) +    # Use hollow circles
  geom_smooth(method=lm, aes(group=1))   # Add linear regression line w/ 95% confidence


colnames(pd.cleaned)
###################################################################
##Create graphs for presentation and paper. 
###################################################################
se <- function(x) sd(x, na.rm = TRUE)/sqrt(length(x)-sum(is.na(x)))

Exp1_Data <- pd.cleaned[c(22,24,26,28,32,34,36,39,41,45,63,72,44)]
Exp1_Graph_Data <- gather(Exp1_Data,key=Outcome_Variable,value = Value,-exp1_Treatment) %>% group_by(exp1_Treatment,Outcome_Variable)%>% dplyr::summarise(avg = mean(Value), se = se(Value))
colnames(pd.cleaned)

Exp2_Data <- pd.cleaned[c(68,49,51,53,55,57,58,60)][complete.cases(pd.cleaned$valid_treat2),]
Exp2_Data$exp2_Question1Response <- as.numeric(Exp2_Data$exp2_Question1Response)
Exp2_Graph_Data <- gather(Exp2_Data,key=Outcome_Variable,value = Value,-valid_treat2) %>% group_by(valid_treat2,Outcome_Variable)%>% dplyr::summarise(avg = mean(Value, na.rm = TRUE), se = se(Value))

levels(pd.cleaned$exp1_Treatment)
levels(pd.cleaned$valid_treat2)
pd.cleaned <- pd.cleaned %>% mutate(exp1_Treat_Rollup = cases("Table"=(exp1_Treatment=="Nonordered table"|exp1_Treatment=="Ordered Table"),
                                                              "Chart_Junk"=(exp1_Treatment=="Nonordered chart junk"|exp1_Treatment=="Ordered chart junk"),
                                                              "Tufte"=(exp1_Treatment=="Nonordered tufte"|exp1_Treatment=="Ordered tufte"))
                                    ,exp2_Treat_Rollup = cases("Table"=(exp2_Treatment=="Unordered Table"|valid_treat2=="Ordered Table"),
                                                               "Non_Log_Scale"=(exp2_Treatment=="No Log scatterplot"),
                                                               "Log_Scale"=(exp2_Treatment=="Log scatterplot"))) %>% mutate(Overall_Treatment = paste(exp1_Treat_Rollup,exp2_Treat_Rollup,sep="-"))
Pursuasion_Exp_Data <- pd.cleaned[c(65,64,74)]
Pursuasion_Exp_Data$finalq_Question2Response <- as.numeric(Pursuasion_Exp_Data$finalq_Question2Response)
Pursuasion_Exp_Data$finalq_Question3Response <- as.numeric(Pursuasion_Exp_Data$finalq_Question3Response)
Pursuasion_Exp_Graph_Data <- gather(Pursuasion_Exp_Data,key=Outcome_Variable,value = Value,-Overall_Treatment) %>% group_by(Overall_Treatment,Outcome_Variable)%>% dplyr::summarise(avg = mean(Value, na.rm = TRUE), se = se(Value))



limits <- aes(ymax = avg + se, ymin=avg - se)
#plot all outcomes for experiment 1
Plot <- ggplot(Exp1_Graph_Data, aes(y=avg,x=exp1_Treatment,color=exp1_Treatment,fill=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity")
Plot <- Plot + geom_errorbar(limits,color="grey10",width=.6)
Plot <- Plot + geom_text(data=Exp1_Graph_Data,aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='grey30',vjust=0,size=3)
Plot <- Plot + facet_wrap(~ Outcome_Variable,scales="free")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1))
Plot

library(scales)
library(grid)
#Overall
#exp1_PctCorrect_q123
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_PctCorrect_q123',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_PctCorrect_q123',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp1_PctCorrect_q123 ~ exp1_Treatment, pd.cleaned)
Cov <- lm(exp1_PctCorrect_q123 ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_PercentageCorrect, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp1_PctCorrect_q123.html') #write html output file


#Overall
#recall_PercentageCorrect
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='recall_PercentageCorrect',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='recall_PercentageCorrect',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(recall_PercentageCorrect ~ exp1_Treatment, pd.cleaned)
Cov <- lm(recall_PercentageCorrect ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_PercentageCorrect, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'recall_PercentageCorrect.html') #write html output file




#exp1_Question1CorrectAnswer
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_Question1CorrectAnswer',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_Question1CorrectAnswer',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp1_Question1CorrectAnswer ~ exp1_Treatment, pd.cleaned)
Cov <- lm(exp1_Question1CorrectAnswer ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp1_Question1CorrectAnswer.html') #write html output file



#exp1_Question2CorrectAnswer
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_Question2CorrectAnswer',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_Question2CorrectAnswer',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp1_Question2CorrectAnswer ~ exp1_Treatment, pd.cleaned)
Cov <- lm(exp1_Question2CorrectAnswer ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp1_Question2CorrectAnswer.html') #write html output file


#exp1_PageThreeTimeMinutes
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_PageThreeTimeMinutes',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_PageThreeTimeMinutes',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp1_PageThreeTimeMinutes ~ exp1_Treatment, pd.cleaned)
Cov <- lm(exp1_PageThreeTimeMinutes ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp1_PageThreeTimeMinutes.html') #write html output file


#exp1_Question3CorrectAnswer
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_Question3CorrectAnswer',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_Question3CorrectAnswer',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp1_Question3CorrectAnswer ~ exp1_Treatment, pd.cleaned)
Cov <- lm(exp1_Question3CorrectAnswer ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp1_Question3CorrectAnswer.html') #write html output file

#exp1_PageFourTimeMinutes
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_PageFourTimeMinutes',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,1.25,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='exp1_PageFourTimeMinutes',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp1_PageFourTimeMinutes ~ exp1_Treatment, pd.cleaned)
Cov <- lm(exp1_PageFourTimeMinutes ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp1_PageFourTimeMinutes.html') #write html output file


#recall_Question1CorrectAnswer
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='recall_Question1CorrectAnswer',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='recall_Question1CorrectAnswer',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(recall_Question1CorrectAnswer ~ exp1_Treatment, pd.cleaned)
Cov <- lm(recall_Question1CorrectAnswer ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'recall_Question1CorrectAnswer.html') #write html output file

#recall_Question2CorrectAnswer.html
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='recall_Question1CorrectAnswer',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='recall_Question1CorrectAnswer',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(recall_Question2CorrectAnswer ~ exp1_Treatment, pd.cleaned)
Cov <- lm(recall_Question2CorrectAnswer ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'recall_Question2CorrectAnswer.html') #write html output file


#finalq_Question1CorrectAnswer
Plot <- ggplot(Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='finalq_Question1CorrectAnswer',], aes(y=avg,x=exp1_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .8)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp1_Graph_Data[Exp1_Graph_Data$Outcome_Variable =='finalq_Question1CorrectAnswer',],aes(y=avg,x=exp1_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot


No_Cov <- lm(finalq_Question1CorrectAnswer ~ exp1_Treatment, pd.cleaned)
Cov <- lm(finalq_Question1CorrectAnswer ~ exp1_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'finalq_Question1CorrectAnswer.html') #write html output file








###################################################################
##Experiment 2 graphs
###################################################################

#exp2_PercentageCorrect
Plot <- ggplot(Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_PercentageCorrect',], aes(y=avg,x=valid_treat2))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_hline(yintercept = seq(0,1,.25),color='white', size =.01)
Plot <- Plot + geom_errorbar(limits,color="black",width=.5)
Plot <- Plot + geom_text(data=Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_PercentageCorrect',],aes(y=avg,x=valid_treat2,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp2_PercentageCorrect ~ valid_treat2, pd.cleaned)
Cov <- lm(exp2_PercentageCorrect ~ valid_treat2+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_PercentageCorrect, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp2_PercentageCorrect.html') #write html output file


#exp2_Question1Response
Plot <- ggplot(Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question1Response',], aes(y=avg,x=valid_treat2))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_hline(yintercept = seq(0,4,1),color='white', size =.01)
Plot <- Plot + geom_errorbar(limits,color="black",width=.5)
Plot <- Plot + geom_text(data=Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question1Response',],aes(y=avg,x=valid_treat2,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp2_Question1Response ~ valid_treat2, pd.cleaned)
Cov <- lm(exp2_Question1Response ~ valid_treat2+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_PercentageCorrect, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp2_Question1Response.html') #write html output file



#exp2_Question2CorrectAnswer
Plot <- ggplot(Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question2CorrectAnswer',], aes(y=avg,x=valid_treat2))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_errorbar(limits,color="black",width=.5)
Plot <- Plot + geom_text(data=Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question2CorrectAnswer',],aes(y=avg,x=valid_treat2,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp2_Question2CorrectAnswer ~ valid_treat2, pd.cleaned)
Cov <- lm(exp2_Question2CorrectAnswer ~ valid_treat2+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp2_Question2CorrectAnswer.html') #write html output file



#exp2_Question3CorrectAnswer
Plot <- ggplot(Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question3CorrectAnswer',], aes(y=avg,x=valid_treat2))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_errorbar(limits,color="black",width=.5)
Plot <- Plot + geom_text(data=Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question3CorrectAnswer',],aes(y=avg,x=valid_treat2,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp2_Question3CorrectAnswer ~ valid_treat2, pd.cleaned)
Cov <- lm(exp2_Question3CorrectAnswer ~ valid_treat2+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp2_Question3CorrectAnswer.html') #write html output file


#exp2_Question4CorrectAnswer
Plot <- ggplot(Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question4CorrectAnswer',], aes(y=avg,x=valid_treat2))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_Question4CorrectAnswer',],aes(y=avg,x=valid_treat2,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp2_Question4CorrectAnswer ~ valid_treat2, pd.cleaned)
Cov <- lm(exp2_Question4CorrectAnswer ~ valid_treat2+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp2_Question4CorrectAnswer.html') #write html output file


#exp2_PageSixTimeMinutes
Plot <- ggplot(Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_PageSixTimeMinutes',], aes(y=avg,x=valid_treat2))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_hline(yintercept = seq(0,1.5,.5),color='white', size =.01)
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_text(data=Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_PageSixTimeMinutes',],aes(y=avg,x=valid_treat2,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp2_PageSixTimeMinutes ~ valid_treat2, pd.cleaned)
Cov <- lm(exp2_PageSixTimeMinutes ~ valid_treat2+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp2_PageSixTimeMinutes.html') #write html output file


#exp2_PageSevenTimeMinutes
Plot <- ggplot(Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_PageSevenTimeMinutes',], aes(y=avg,x=valid_treat2))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Exp2_Graph_Data[Exp2_Graph_Data$Outcome_Variable =='exp2_PageSevenTimeMinutes',],aes(y=avg,x=valid_treat2,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(exp2_PageSevenTimeMinutes ~ valid_treat2, pd.cleaned)
Cov <- lm(exp2_PageSevenTimeMinutes ~ valid_treat2+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'exp2_PageSevenTimeMinutes.html') #write html output file





###################################################################
#Pursuasion Experiment
###################################################################
Pursuasion_Exp_Data1 <- pd.cleaned[c(65,64,72)]
Pursuasion_Exp_Data1$finalq_Question2Response <- as.numeric(Pursuasion_Exp_Data1$finalq_Question2Response)
Pursuasion_Exp_Data1$finalq_Question3Response <- as.numeric(Pursuasion_Exp_Data1$finalq_Question3Response)
Pursuasion_Exp_Graph_Data1 <- gather(Pursuasion_Exp_Data1,key=Outcome_Variable,value = Value,-exp1_Treat_Rollup) %>% group_by(exp1_Treat_Rollup,Outcome_Variable)%>% dplyr::summarise(avg = mean(Value, na.rm = TRUE), se = se(Value))

Pursuasion_Exp_Data2 <- pd.cleaned[c(65,64,73)]
Pursuasion_Exp_Data2$finalq_Question2Response <- as.numeric(Pursuasion_Exp_Data2$finalq_Question2Response)
Pursuasion_Exp_Data2$finalq_Question3Response <- as.numeric(Pursuasion_Exp_Data2$finalq_Question3Response)
Pursuasion_Exp_Graph_Data2 <- gather(Pursuasion_Exp_Data2,key=Outcome_Variable,value = Value,-exp2_Treat_Rollup) %>% group_by(exp2_Treat_Rollup,Outcome_Variable)%>% dplyr::summarise(avg = mean(Value, na.rm = TRUE), se = se(Value))


Pursuasion_Exp_Data <- pd.cleaned[c(65,64,74)]
Pursuasion_Exp_Data$finalq_Question2Response <- as.numeric(Pursuasion_Exp_Data$finalq_Question2Response)
Pursuasion_Exp_Data$finalq_Question3Response <- as.numeric(Pursuasion_Exp_Data$finalq_Question3Response)
Pursuasion_Exp_Graph_Data <- gather(Pursuasion_Exp_Data,key=Outcome_Variable,value = Value,-Overall_Treatment) %>% group_by(Overall_Treatment,Outcome_Variable)%>% dplyr::summarise(avg = mean(Value, na.rm = TRUE), se = se(Value))

Plot <- ggplot(Pursuasion_Exp_Graph_Data[Pursuasion_Exp_Graph_Data$Outcome_Variable =='finalq_Question2Response',], aes(y=avg,x=Overall_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Pursuasion_Exp_Graph_Data[Pursuasion_Exp_Graph_Data$Outcome_Variable =='finalq_Question2Response',],aes(y=avg,x=Overall_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot


Plot <- ggplot(Pursuasion_Exp_Graph_Data[Pursuasion_Exp_Graph_Data$Outcome_Variable =='finalq_Question3Response',], aes(y=avg,x=Overall_Treatment))
Plot <- Plot + geom_bar(stat="identity", fill = "grey50", color = "grey50",width = .7)
Plot <- Plot + theme_bw()
Plot <- Plot + geom_errorbar(limits,color="black",width=.6)
Plot <- Plot + geom_hline(yintercept = seq(0,.75,.25),color='white', size =.01)
Plot <- Plot + geom_text(data=Pursuasion_Exp_Graph_Data[Pursuasion_Exp_Graph_Data$Outcome_Variable =='finalq_Question3Response',],aes(y=avg,x=Overall_Treatment,label=round(avg,2)),color='white',vjust=1,size=5,fontface="bold")
Plot <- Plot + theme(axis.text.x=element_text(angle=45,hjust=1,vjust = 0.5,size=12))
Plot <- Plot + theme(
  plot.background = element_blank()
  ,panel.grid.major = element_blank()
  ,panel.grid.minor = element_blank()
  ,panel.border = element_blank()
)
Plot <- Plot + theme(axis.ticks.x=element_blank())
Plot <- Plot + theme(axis.ticks.y=element_blank())
Plot <- Plot + theme(axis.text.y = element_blank(),title = element_blank())
Plot <- Plot + theme(plot.margin = unit(c(1,1,1.7,1), "cm"))
Plot

No_Cov <- lm(finalq_Question2Response ~ Overall_Treatment, pd.cleaned)
Cov <- lm(finalq_Question2Response ~ Overall_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'finalq_Question2Response.html') #write html output file

No_Cov <- lm(finalq_Question3Response ~ Overall_Treatment, pd.cleaned)
Cov <- lm(finalq_Question3Response ~ Overall_Treatment+gen_Age+gen_Gender+health_care+Education_Num+Job_Role + iq_PageTwoTimeMinutes + iq_Question1CorrectAnswer + iq_Question2CorrectAnswer + iq_Question3CorrectAnswer, pd.cleaned)
write(stargazer(No_Cov,Cov,type="html"),file = 'finalq_Question3Response.html') #write html output file