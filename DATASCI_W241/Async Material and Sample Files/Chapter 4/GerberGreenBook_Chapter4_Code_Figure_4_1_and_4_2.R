# Reproducing Figures 4.1 and 4.2

# clear workspace
rm(list = ls())

# Load in library to read stata files
library(foreign)

# Load in Data from website
teacherout <- read.dta("http://hdl.handle.net/10079/wwpzgz8")

# Or load in Data as a .csv file from website
#teacherout <- read.csv(file="http://hdl.handle.net/10079/1ns1rzk",head=TRUE,sep=",")

# Attach Data
attach(teacherout)

## Reproduce Figure 4.1
# Create space to draw Figure 4.1
par(family="Gill Sans MT",font.main=1)
layout(matrix(c(1,2),2,1,byrow=TRUE))

# Graph the top part of Figure 4.1 
hist(diffinmean,xlim=c(-10,20),freq=FALSE,ylim=c(0,.25),main="Sampling Distributions",xlab="Difference-in-Means")
lines(density(diffinmean))

# Graph the bottom part of Figure 4.1
hist(diffinchangemeans,xlim=c(-10,20),freq=FALSE,ylim=c(0,.25),main=NULL,xlab="Difference-in-Differences")
lines(density(diffinchangemeans))

# Detach data so can reload data with identical variable names in examples below.
detach(teacherout)

#########

## To reproduce Figure 4.2

### Reproducing the first histogram: simple randomization

attach(teacherout)

par(family="Gill Sans MT",font.main=1)
layout(matrix(c(1,2,3),3,1,byrow=TRUE))

hist(teacherout$diffinmean,xlim=c(-10,20),freq=FALSE,ylim=c(0,.30),main="Sampling Distributions",xlab="Simple Randomization")
lines(density(teacherout$diffinmean))

detach(teacherout)

### Reproducing the second histogram: block randomization (strong predictor)
teacherout <- read.dta("http://hdl.handle.net/10079/t4b8h50")

attach(teacherout)

hist(teacherout$diffinmean,xlim=c(-10,20),freq=FALSE,ylim=c(0,.30),main=NULL,xlab="Blocked Randomization (Strong Predictor)")
lines(density(teacherout$diffinmean))

detach(teacherout)

### Reproducing the third histogram: block randomization (weak predictor)

teacherout <- read.dta("http://hdl.handle.net/10079/s4mw6xr")

attach(teacherout)

hist(teacherout$diffinmean,xlim=c(-10,20),freq=FALSE,ylim=c(0,.30),main=NULL,xlab="Blocked Randomization (Weak Predictor)")
lines(density(teacherout$diffinmean))

