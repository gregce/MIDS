library(foreign)
library(data.table)

##
## Regression Discontinuity
##

d <- data.frame(running = runif(1000, min = 0, max = 10), 
                cov1    = rnorm(1000))
d$y <- d$running * 0.1 - .2 * d$cov1 + 1 * I(d$running > 5) + rnorm(1000)

## Plots
## a) 
plot(x = d$running, d$y, pch = 19, col = rgb(0,1,0, .4))
lines(lowess(d$running, d$y))

## b) 
with(d, plot(running, y, pch = 19, col = rgb(0,0,1, .2)))
lines(lowess(d$running[d$running < 5], d$y[d$running < 5]), lwd = 2)
lines(lowess(d$running[d$running > 5], d$y[d$running > 5]), lwd = 2)

## c) 
with(d, plot(running, y, pch = 19, col = rgb(1,0,0, .2)))
lines(lowess(d$running[d$running < 3], d$y[d$running < 3]), lwd = 2)
lines(lowess(d$running[d$running > 3], d$y[d$running > 3]), lwd = 2)

for(i in 1:9) {
  with(d, plot(running, y, pch = 19, col = rgb(1,0,0, .2)))
  lines(lowess(d$running[d$running < i], d$y[d$running < i]), lwd = 2)
  lines(lowess(d$running[d$running > i], d$y[d$running > i]), lwd = 2)
}

## Models 
m1 <- lm(y ~ running, data = d)
m2 <- lm(y ~ running + cov1, data = d)
m3 <- lm(y ~ running + I(running > 5) + cov1, data = d)
summary(m3)

m4 <- lm(y ~ I(running > 5), data = d[d$running > 4.8 & d$running < 5.2, ])


##
## Packages for RDD
##
## install.packages("rdrobust")
## browseURL("https://journal.r-project.org/archive/2015-1/cattaneo-calonico-titiunik.pdf")
## browseURL("https://cran.r-project.org/web/packages/rdrobust/rdrobust.pdf")
##
library(rdrobust)
?rdplot

## load canned data
data(rdrobust_RDsenate)
d2 <- rdrobust_RDsenate

## First default (optimally searched) binning arguments
(with(d2, rdplot(y = vote, x = margin,
               title = "RD Plot - Senate Elections Data",
               y.label = "Vote Share in Election at time t+1",
               x.label = "Vote Share in Election at time t") ))
## Second with even spacing for data points 
with(d2, rdplot(y = vote, x = margin, binselect = "es",
               title = "RD Plot - Senate Elections Data",
               y.label = "Vote Share in Election at time t+1",
               x.label = "Vote Share in Election at time t") )
with(d2, rdrobust(y = vote, x = margin, kernel = "uniform") )
with(d2, rddensity(X = margin, c = 0))
## Run it on our earlier data; 

(rdplot(y = d$y, x = d$running, c = 5))
(rdrobust(y = d$y, x = d$running, c = 5))
summary(m3)

## What about manipulation checks?
## These are, did people manipulate the cuttoff?
## browseURL("http://www-personal.umich.edu/~cattaneo/software/rddensity/R/")
## library(rdd)

##
## Lalive Replication
##

## browseURL("https://drive.google.com/file/d/0BxwM1dZBYvxBRlRNMDgxQllfOE0/view?usp=sharing") 
d <- read.dta("~/Downloads/releaseData.dta")
d <- data.table(d)
head(d)

m1 <- d[ , lm(unemployment_duration ~ age + I(age > 50))]
m2 <- d[ , lm(unemployment_duration ~ age + I(age > 50) * female)]
m3 <- d[age > 49 & age < 51 , lm(unemployment_duration ~ age50
              + marr + single + educ_med + educ_hi + foreign + rr
              + lwage_ljob + previous_experience + white_collar
              + landw + versorg + nahrung + textil + holzind
              + elmasch + andfabr + bau + gasthand + verkehr
              + dienstl
              + age) ]
summary(m3)

## Replicate with rdplot and rdrobust
dUse <- d[sample(1:nrow(d), size = 1e4), ]
dUse[ , rdplot(y = unemployment_duration, x = age, c = 50) ]
dUse[ , rdrobust(y = unemployment_duration, x = age, c = 50) ]

## Difference in Differences 
d2 <- data.frame(group = rep(c("C", "T"), each = 500), 
                 time  = rep(c("B", "A"), 500))
d2$y <- NA 
tau <- rnorm(250, mean = 2, sd = .5)

d2[d2$time == "B" & d2$group == "C", "y"] <- 2
d2[d2$time == "B" & d2$group == "T", "y"] <- 3
d2[d2$time == "A" & d2$group == "C", "y"] <- d2[d2$time == "B" & d2$group == "C", "y"] + 1
d2[d2$time == "A" & d2$group == "T", "y"] <- d2[d2$time == "B" & d2$group == "T", "y"] + 1 + tau
d2$y <- d2$y + rnorm(1000)

## Plots 
boxplot(y ~ group * time, data = d2)

## Models 

## y ~ \beta_{0} + \beta_{1} * G + \beta_{2} * D + \tau * G * D

m5 <- lm(y ~ I(group == "T") + I(time == "A") + I(group == "T") * I(time == "A") , data = d2)
summary(m5)

## What about real data?
browseURL("https://drive.google.com/folderview?id=0BxwM1dZBYvxBVWk1Y2dhNk9Qd2c&usp=sharing")
d6 <- ("~/Downloads/IncineratorDistanceData/HPRICE3.raw")
setnames(d3, c("V1", "V8", "V13"), c("year", "price", "dist"))

m6 <- lm(price ~ as.factor(year) * dist, data = d3)
summary(m3)
