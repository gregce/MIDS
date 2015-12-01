## Download the data here:
## https://drive.google.com/file/d/0B_Qj0otlErJqTWZsM0VLMVR4ZmM/view?usp=sharing

library(data.table)

d <- fread("~/Downloads/Incentives_JPE_HTEs.csv")
names(d)

## VARIABLES WE CARE ABOUT:
## - cheaters_y2: people who cheated in the study window;
##   we don't want their data
## - y2_nts_level_mean: the DV
## - y0_nts: the individual's year prior national test score
## - incentive: the treatment indicator
## - parent_literacy_index: the 1-4 indicators for parental literacy
## - hh_affluence_index: the 1-7 affluence index 
## - U_MC: the mandal
## - apfschoolcode: the school code (which we will eventually use
##   to cluster the standard errors. 

## 1. We only want to use the data for people who didn't cheat
## how would you subset this?
d[cheaters_y2 == 0, ]

## 2. Print summary statistics for those who didn't cheat
d[cheaters_y2 == 0, hist(y2_nts_level_mean)]
d[cheaters_y2 == 0, hist(y0_nts)]
d[cheaters_y2 == 0, table(incentive)]
d[cheaters_y2 == 0, table(parent_literacy_index)]

## 3. Estimate a model that only includes the treatment effect
mod3 <- lm(y2_nts_level_mean ~ y0_nts, data = d[cheaters_y2 == 0, ])

## 4. Estimate a model that looks at the heterogeneity of the treatment
##    effect with the other covariates that SM use.

## SPECIFICALLY: LOOK AT THE TREATMENT BY COVARIATE INTERACTION FOR:
##               parent_literacy_index

##    a. Estimate a model that does not include an interaction
##    b. Estimate a model that DOES include an interaction
##    c. Compare the two. 
mod4a <- lm(y2_nts_level_mean ~ y0_nts
            + incentive
            + parent_literacy_index
            + as.factor(U_MC),
            data = d[cheaters_y2 == 0, ])
mod4b <- lm(y2_nts_level_mean ~ y0_nts
            + incentive
            + parent_literacy_index
            + parent_literacy_index * incentive
            + as.factor(U_MC),
            data = d[cheaters_y2 == 0, ])
stargazer(mod4a, mod4b, type = "text", omit = "U_MC")

## 5. Estimate a model that looks at the heterogeneity of the treatment
##    effect with the other covariates that SM use.

## SPECIFICALLY: LOOK AT THE TREATMENT BY COVARIATE INTERACTION FOR:
##               hh_affluence_index 


##    a. Estimate a model that does not include an interaction
##    b. Estimate a model that DOES include an interaction
##    c. Compare the two. 

mod5a <- lm(y2_nts_level_mean ~ y0_nts
            + incentive
            + hh_affluence_index
            + as.factor(U_MC),
            data = d[cheaters_y2 == 0, ])
mod5b <- lm(y2_nts_level_mean ~ y0_nts
            + incentive
            + hh_affluence_index
            + hh_affluence_index * incentive
            + as.factor(U_MC),
            data = d[cheaters_y2 == 0, ])
stargazer(mod5a, mod5b, type = "text", omit = "U_MC")

## Wait a second. This looks VASLY more "significant" that it did
## when the authors reported it. What gives?
## When they report their results, they are clustering at the school level.
## They cluster at the school level because there is likely to be positive
## covariance in the potential outcomes at the school level.

## Download the code here:
## https://drive.google.com/file/d/0B_Qj0otlErJqbl85UkNPQkZ3c1k/view?usp=sharing
source("~/Downloads/cl.R")
cl

## in this function, which we wrote (borrowing liberally from the internet)
## fm is the fit model; cluster is an indicator for the clutering variable.

## Because it is hand-coded, it is a little bit particular.
## Note:
##   1. There can't be any missing values
##   2. The way it is written, specify the clustering variable as
##      a variable in the object. Meaning, d.cc$apfschoolcode.

## Typically, I don't like to make a bunch of objects... but it makes
## sense in this limited case.

d.cc <- na.omit(d[cheaters_y2 == 0, c("y2_nts_level_mean", "y0_nts", "incentive",
                      "hh_affluence_index", "U_MC", "apfschoolcode"), with = F])

## Estimate the models again on this set of the data that is complete.

mod6a <- lm(y2_nts_level_mean ~ y0_nts
            + incentive
            + hh_affluence_index
            + as.factor(U_MC),
            data = d.cc)
mod6b <- lm(y2_nts_level_mean ~ y0_nts
            + incentive
            + hh_affluence_index
            + hh_affluence_index * incentive
            + as.factor(U_MC),
            data = d.cc)

## Call the clustering function on the new models. 
cl(mod6b, d.cc$apfschoolcode)

## Finally, Compare the regressions for models 6a and 6b when you do and
## don't cluster the standard errors. N.B.: the stargazer function that we've
## been smashing today will accept the results of a cl(...) object.

stargazer(mod6a, 
          cl(mod6a, d.cc$apfschoolcode),
          mod6b, 
          cl(mod6b, d.cc$apfschoolcode),
          type = "text",
          omit = "U_MC")

