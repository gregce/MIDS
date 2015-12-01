library(data.table)
library(dplyr)




d <- fread("http://hdl.handle.net/10079/tx95xhr")
## d <- read.csv("http://hdl.handle.net/10079/tx95xhr")

## Subset data, keeping if age >= 9 & age <= 25 & checkid == 1
d <- d[ age >= 9 & age <= 25 & checkid == 1 , ]
## Set NA observations to unobserved 


d[is.na(read), read := 0] # only grabs one more NA value 

d$read[d$read==0] <- NA


## Outcome 1: What is the effect of the voucher on registration? 

d_out1 <- d %>%
  na.omit() %>%
  mutate(reg = ifelse(read == 0, 0, 1))


mean(d_out1[vouch0 == 1, reg]) - mean(d_out1[vouch0 == 0, reg])

## Outcome 2: How many don't register for the test?
##            How bad is this for you? 

prop.table(table(d_out1$reg))

table(d_out1$reg)


## Outcome 3: Is missingness related to covariates?
## 1. Create a missingness indicator
d_out1[ , missing := 1 - I(read == 0) ]


## 2. Run a regression on sex, phone, and age
mod1 <- glm(missing ~ (sex_name + phone + age),
            data = d_out1,
            family = "binomial")

summary(mod1)

## 3. Is this attrition different based on treatment group?
##    Hint: this is an interaction setup. 

mod2 <- glm(missing ~ vouch0 * (sex_name + phone + age),
            data = d_out1,
            family = "binomial")

summary(mod2)

## 4. Presume that the effects are MIPO. What is the effect on reading scores?
mod3 <- glm()

## 5. Presume MIPO | X. What now?
##    A. Calculate the probability of being observed from the
##       fitted values of the probabilty of being observed model (mod2).
##       Attach this to your dataframe as the varible pObs 


##    B. Then, estimate a model that uses these weights. If you haven't seen it
##       before, then look into the help for glm -- ?glm and look for the weights
##       argument.
##       Hint: what "family" of regression should this be? 

mod4 <- glm()

## 6. Throw away MIPO, and now do the bounds analysis.
##    A. Max effect: missing treated get 100, missing control get 0
mean() - mean()

##    B. Min effect: missing treated get 0, missing control get 100
mean() - mean() 
