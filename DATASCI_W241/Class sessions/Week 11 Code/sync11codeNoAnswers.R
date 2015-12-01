library(foreign)
library(data.table)
library(dplyr)

rm( list = ls() )
##
## Regression Discontinuity
##

d <- data.frame(running = runif(1000, min = 0, max = 10), 
                cov1    = rnorm(1000))
d$y <- d$running * .5 - .2 * d$cov1 + 1 * I(d$running > 5) + rnorm(1000)

hist(d$y)

## A. Plots
## a) Plot all the x and y data 
plot(x = d$running, y = d$y, pch = 19, col = rgb(0,1,0, .4), ylim = c(-2, 10))
lines(lowess(x = d$running , y = d$y ))

## b) Subset so that you allow a break at the cuttoff. 
##    for example, if x = d$x, you want to suset to only include 
##    x variables that are either larger than or small than the 
##    cuttoff.
## 
##     x = d$x[d$x > cuttoff]
## 
##     or in data.table-ish
##     x = d[x > cuttoff, x]

cuttoff <- 5

d$cutoff <- 3

d_lower <- d %>%
  filter(running < cutoff)

d_higher <- d %>%
  filter(running > cutoff)


plot(x = d$running , y = d$y , pch = 19, col = rgb(0,0,1, .4), ylim = c(-2, 10))
lines(lowess(x = d_lower$running, y = d_lower$y ), lwd = 2) # lower than cuttoff
lines(lowess(x = d_higher$running, y = d_higher$y), lwd = 2) # higher than cuttoff 

## c) Subset to some /other/ cuttoff that isn't where we had the effect 
##    for example, try three. 
plot(x = , y = , pch = 19, col = rgb(1,0,0, .4), ylim = c(-2, 10))
lines(lowess(x = , y = ), lwd = 2)
lines(lowess(x = , y = ), lwd = 2)

## d) Write a little loop that will do the same, but will iteratively move the 
##    cuttoff along the forcing variables.       
for(i in 1:9) {
  d$cutoff <- i
  
  d_lower <- d %>%
    filter(running < cutoff)
  
  d_higher <- d %>%
    filter(running > cutoff)  
  
  plot(x = d$running , y = d$y , pch = 19, col = rgb(0,0,1, .4), ylim = c(-2, 10))
  lines(lowess(x = d_lower$running, y = d_lower$y ), lwd = 2) # lower than cuttoff
  lines(lowess(x = d_higher$running, y = d_higher$y), lwd = 2) # higher than cuttoff 
  
}
## what is this doing? what are the different cuttoffs looking like?
## how much does this feel like a placebo test? 

## B. Models 
m1 <- lm() # only forcing variable  (not the cuttoff)
m2 <- lm() # forcing var + covariate 
m3 <- lm() # forcing + covariate + treatment effect (boom!)
summary(m3)

##
## Packages for RDD
##
## install.packages("rdrobust")
## browseURL("https://journal.r-project.org/archive/2015-1/cattaneo-calonico-titiunik.pdf")
## browseURL("https://cran.r-project.org/web/packages/rdrobust/rdrobust.pdf")

library(rdrobust)
?rdplot

## load canned data
data(rdrobust_RDsenate)
d2 <- rdrobust_RDsenate

## First default (optimally searched) binning arguments
with(d2, rdplot(y = vote, x = margin,
               title = "RD Plot - Senate Elections Data",
               y.label = "Vote Share in Election at time t+1",
               x.label = "Vote Share in Election at time t") )
     ## Second with even spacing for data points 
with(d2, rdplot(y = vote, x = margin, binselect = "es",
               title = "RD Plot - Senate Elections Data",
               y.label = "Vote Share in Election at time t+1",
               x.label = "Vote Share in Election at time t") )
with(d2, rdrobust(y = vote, x = margin, kernel = "uniform") )

## Run it on our earlier data; 

(rdplot(y = d$y, x = d$running, c = 5))
(rdrobust(y = d$y, x = d$running, c = 5))
summary(m3)

##
## Lalive Replication
##

## browseURL("https://drive.google.com/file/d/0BxwM1dZBYvxBRlRNMDgxQllfOE0/view?usp=sharing") 
d <- read.dta("~/Downloads/releaseData.dta")
## if you like: 
## d <- data.table(d)
head(d)

## now, write a model that will estimate, in the same way as above,
## what the discontinuity is at the break point;
## start from the running varible, then include covariates,
## then include the running, and covariates, and break.

## Replicate with rdplot and rdrobust 

##
## Difference in Differences
##

## Make Data 
## This isn't important, but you have to execute it to make the d2 dataset. 
d2 <- data.frame(group = rep(c("C", "T"), each = 500), 
                 time  = rep(c("B", "A"), 500))
d2$y <- NA 
tau <- rnorm(250, mean = 2, sd = .5)
##
d2[d2$time == "B" & d2$group == "C", "y"] <- 2
d2[d2$time == "B" & d2$group == "T", "y"] <- 3
d2[d2$time == "A" & d2$group == "C", "y"] <- d2[d2$time == "B" & d2$group == "C", "y"] + 1
d2[d2$time == "A" & d2$group == "T", "y"] <- d2[d2$time == "B" & d2$group == "T", "y"] + 1 + tau
d2$y <- d2$y + rnorm(1000)
## End Make Data 

## Plots 
boxplot(LHS ~  * ) # use the formula interface to make a boxplot that shows the D-in-D

## Models 
m5 <- lm(LHS ~  ) # follow the setup to estimate the d-in-d model 
summary(m5)

##
## What about Real Data?
##
## Download foder.
library(data.table)
browseURL("https://drive.google.com/folderview?id=0BxwM1dZBYvxBVWk1Y2dhNk9Qd2c&usp=sharing")
d6 <- fread("~/Downloads/IncineratorDistanceData/HPRICE3.raw")
setnames(d3, c("V1", "V8", "V13"), c("year", "price", "dist"))

## estimate a d-in-d model. and interpret it. 

