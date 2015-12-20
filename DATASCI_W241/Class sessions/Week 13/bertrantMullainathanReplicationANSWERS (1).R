library(data.table)
library(foreign)
library(stargazer)
library(dplyr)

## data from FEDAI
d <- read.dta("http://hdl.handle.net/10079/0cfxq05")
dt <- data.table(d)

## data from authors 
##   browseURL("https://www.aeaweb.org/aer/data/sept04_data_bertrand.zip")
##   d <- read.dta("~/Downloads/lakisha_aer.dta")

## meta data:
##   h: high quality candidate == 1
##   city: factor identifying if in city b or city c
##   race: b == "black name"; w == "white name"
##   call: did subject receive a call back?

## 1: code using means, sems,  and subsets
sem <- function(x) sqrt(var(x) / length(x))

dt[ , .(m  = mean(call),
        se = sem(call)),
   by = c("h","race") ]

d %>%
    group_by(h, race) %>%
    summarise(m  = mean(call),
              se = sem(call))

## 2: code using interaction

m <- lm(call ~ h*race, data = dt)
summary(m)


## 3. Compare the results that you read in the book table
##    why does the book claim a significant difference of
##    quality among white names? are you seeing that here? 

m2 <- lm(call ~ h, data = dt[race == "w", ])
summary(m2)
m3 <- lm(call ~ h, data = dt[race == "b", ])
summary(m3)
