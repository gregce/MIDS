rm(list = ls())

## The "Letter Writing Example" from p. 304
## Create Dataset

dat <- data.frame(y       = rep(NA, 400),
                  name    = rep(NA, 400),
                  grammar = rep(NA, 400) )
dat$y <- c(rep(1, 52), rep(0, 48),
           rep(1, 29), rep(0, 71),
           rep(1, 37), rep(0, 63),
           rep(1, 34), rep(0, 66) )
dat$name <- as.factor(c(rep("C", 200), rep("J",200)))
dat$grammar <- as.factor(rep(c("G", "B", "G", "B"), each = 100) )

## Estimate Saturated Model 9.11
## (Hint, this is just group means)
## Second Hint: I like to use the data.table "by" call. 
library(data.table)
dt <- data.table(dat)
dt

## Estimate Model 9.16
# The means look different between groups
by(dt$y, c(dt$name, dt$grammar), mean, na.rm = TRUE)

aggregate(dt$y, by=list(dt$name, dt$grammar), FUN=mean)

reg<-lm(dt$y ~ dt$name+dt$grammar)

summary(reg)
## Robust Standard Errors
library(sandwich)
library(lmtest)
?vcovHC

## Clustered Standard Errors

