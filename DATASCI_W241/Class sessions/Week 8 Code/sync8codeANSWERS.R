
rm(list = ls())

#Load Relevant packages
library(AER)
library(sandwich)
library(data.table)

d1 <- fread("http://hdl.handle.net/10079/70rxwqn")

## Select one-person households that were either pure controls or canvass only
d2 <- d1[onetreat == 1 & mailings == 0 & phongotv == 0 & persons == 1, ]

## Let's make the var names consistent with the book
setnames(d2, "v98", "VOTED")
setnames(d2, "persngrp", "ASSIGNED")
setnames(d2, "cntany", "TREATED")

## We can do this two ways: Using means and using models. 
## First lets do it using means: 

## 0. Can we make back the table 5.2 from Green and Gerber?
## Here's the future answer, Marty. 
d2[ , mean(VOTED), by = c("TREATED", "ASSIGNED")]
d2[ASSIGNED == 1 , mean(VOTED)]

## And here's one of the 1987 answers.
mean(d2[d2$ASSIGNED == 1 & d2$TREATED == 1, VOTED])
mean(d2[d2$ASSIGNED == 1 & d2$TREATED == 0, VOTED])
mean(d2[d2$ASSIGNED == 1, VOTED])
mean(d2[d2$ASSIGNED == 0, VOTED])

## 1. Estimate the ITT
ITT <- d2[ , mean(VOTED[ASSIGNED == 1]) - mean(VOTED[ASSIGNED == 0])]
ITT

## 2. What proportion of those ASSIGNED were actually treated? 
ITT_d <- d2[ , mean(TREATED/ASSIGNED, na.rm = T)]
ITT_d

## And so, the CACE is the ITT / ITT_d
ITT / ITT_d

## Second, let's do it using models 
itt_fit <- lm(VOTED ~ ASSIGNED, data = d2)
summary(itt_fit)
# robust SEs
coeftest(itt_fit, vcovHC(itt_fit))

## Box 5.5: ITT_D
## Note that results from this will vary based on the current version that you have 
## but this variation should not be a concern. 
itt_d_fit <- lm(TREATED ~ ASSIGNED, data = d2)
coeftest(itt_d_fit)
# robust SEs
coeftest(itt_d_fit,vcovHC(itt_d_fit))

itt_fit$coefficients[2] / itt_d_fit$coefficients[2]


# Box 5.6: CACE
cace_fit <- ivreg(VOTED ~ TREATED,~ASSIGNED, data = d2)
summary(cace_fit)
# robust SEs
coeftest(cace_fit, vcovHC(cace_fit))

# What if we want to do that 2SLS by hand? 
stage1 <- lm(TREATED ~ ASSIGNED, data = d2)
stage2 <- lm(VOTED ~ predict(stage1), data = d2)
summary(stage2)
