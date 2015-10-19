rm(list=ls())       # clear objects in memory

set.seed(1)

library(foreign)

setwd("/Users/donaldgreen/Dropbox/Field Experimentation Book/Possibly interesting examples/Rosen Data")
rosen <- read.dta("Rosen Experimental Data 2009 -- subset with exactly 50 cases in each cell.dta")

Response <- rosen$Response
J<-rosen$Colin_Jose
G<-rosen$Good_Bad_Grammar
JG<-J*G
H<-rosen$Hispanic
JH<-J*H
GH<-G*H
JGH<-J*G*H


# First Specification

lm1 <- lm(Response~J+G)     # two nested models
lm2 <- lm(Response~J*G)

N <- length(Response)
Fstat <- function(lm1,lm2,N)  ((sum(lm1$residuals^2)-sum(lm2$residuals^2))/(length(lm2$coefficients)-length(lm1$coefficients)))/(sum(lm2$residuals^2)/(N-length(lm2$coefficients)))

Ftest <- Fstat(lm1,lm2,N)   # conventional F-test

a <- lm1$coefficients[2]
b <- lm1$coefficients[3]

Y <- Response               # create potential outcomes
Y00 <- Y - a*J - b*G
Y01 <- Y00 + b
Y10 <- Y00 + a
Y11 <- Y00 + a + b

treatvec <- J*10+G

numiter <- 100000

Fdist <- rep(NA,numiter)

for (i in 1:numiter) {
	treatvecri <- c(sample(treatvec[1:200]),sample(treatvec[201:400]))
	Yri <- Y00
	Yri[treatvecri == 10] <- Y10[treatvecri == 10]
	Yri[treatvecri == 01] <- Y01[treatvecri == 01]
	Yri[treatvecri == 11] <- Y11[treatvecri == 11]
	Jri <- treatvecri > 1
	Gri <- treatvecri %% 10
	lm1ri <- lm(Yri~Jri+Gri)
	lm2ri <- lm(Yri~Jri*Gri)
	Fdist[i] <- Fstat(lm1ri,lm2ri,N)
	if(i %% 5000 == 1) cat(i,"")
		}
		
mean(Fdist >= Ftest)       # calculate p-value
sum(Fdist >= Ftest)



# Second Specification

set.seed(1)

lm1 <- lm(Response~J*G+H)   # another two nested models
lm2 <- lm(Response~J*G*H)

N <- length(Response)
Fstat <- function(lm1,lm2,N)  ((sum(lm1$residuals^2)-sum(lm2$residuals^2))/(length(lm2$coefficients)-length(lm1$coefficients)))/(sum(lm2$residuals^2)/(N-length(lm2$coefficients)))

Ftest <- Fstat(lm1,lm2,N)    # conventional F-test

a <- lm1$coefficients[2]
b <- lm1$coefficients[3]
c <- lm1$coefficients[5]

Y <- Response
Y00 <- Y - a*J - b*G - c*J*G
Y01 <- Y00 + b
Y10 <- Y00 + a
Y11 <- Y00 + a + b + c

treatvec <- J*10+G

numiter <- 100000

Fdist <- rep(NA,numiter)

for (i in 1:numiter) {
	treatvecri <- c(sample(treatvec[1:200]),sample(treatvec[201:400]))
	Yri <- Y00
	Yri[treatvecri == 10] <- Y10[treatvecri == 10]
	Yri[treatvecri == 01] <- Y01[treatvecri == 01]
	Yri[treatvecri == 11] <- Y11[treatvecri == 11]
	Jri <- treatvecri > 1
	Gri <- treatvecri %% 10
	lm1ri <- lm(Yri~Jri*Gri+H)
	lm2ri <- lm(Yri~Jri*Gri*H)
	Fdist[i] <- Fstat(lm1ri,lm2ri,N)
	if(i %% 5000 == 1) cat(i,"")
		}
		
mean(Fdist >= Ftest)      # calculate p-values
sum(Fdist >= Ftest)



# Third Specification

set.seed(1)

lmfit <- lm(Response~J*G*H)   # focus on the sampling distrbution of a single estimated parameter

N <- length(Response)

a <- lmfit$coefficients[2]
b <- lmfit$coefficients[3]
c <- lmfit$coefficients[5]
d <- lmfit$coefficients[6]
e <- lmfit$coefficients[7]
f <- lmfit$coefficients[8]

Y <- Response                   # generate potential outcomes
Y00 <- Y - a*J - b*G - c*J*G - d*J*H - e*G*H - f*J*G*H
Y01 <- Y00 + b + e*H
Y10 <- Y00 + a + d*H
Y11 <- Y00 + a + b + c + d*H + e*H + f*H

treatvec <- J*10+G

numiter <- 100000

threewaydist <- rep(NA,numiter)

for (i in 1:numiter) {
	treatvecri <- c(sample(treatvec[1:200]),sample(treatvec[201:400]))
	Yri <- Y00
	Yri[treatvecri == 10] <- Y10[treatvecri == 10]
	Yri[treatvecri == 01] <- Y01[treatvecri == 01]
	Yri[treatvecri == 11] <- Y11[treatvecri == 11]
	Jri <- treatvecri > 1
	Gri <- treatvecri %% 10
	lmri <- lm(Yri~Jri*Gri*H)
	threewaydist[i] <- lmri$coefficients[8]
	if(i %% 5000 == 1) cat(i,"")
		}

quantile(threewaydist,c(0.025,0.975))        # report confidence interval for 3-way interaction


