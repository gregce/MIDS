# Clear workspace
rm(list = ls())

library(foreign)
library(ri)

# Note first must set file directory where data file is stored

#Import Data from Internet
JPE <- read.dta("http://hdl.handle.net/10079/44j100p")
attach(JPE)

#Set up Model Variables
Z <- (school_treatment - 1)/4
X <- parent_literacy_index > median(parent_literacy_index)
Y <- change

# Advanced Options
set.seed(1234567) # set random number seed (so that results can be replicated)
#the seed used for the file in the book was 1. In order to generate that image
#the seed must be set to 1 instead of 1234567
numiter <- 100000 # number of RI iterations. Use more for greater precision, fewer for greater speed.

#Plot distribution of treatment and change in score
plot(jitter(Z,factor=0.8)~Y,main="Distributions under Treatment and Control",xlab="Change Score",ylab="Treatment Condition",yaxp=c(0,1,1),ylim=c(-0.5,1.5))


estate <- mean(Y[Z==1]) - mean(Y[Z==0]) 
Y1 <- Y0 <- Y
Y0 <- Y0 - estate*Z
Y1 <- Y1 + estate*(1-Z)

estcate0 <- mean(Y1[X==0 & Z==1]) - mean(Y0[X==0 & Z==0]) 
estcate1 <- mean(Y1[X==1 & Z==1]) - mean(Y0[X==1 & Z==0]) 

lm1  <- lm(Y~Z*X)
lm2  <- lm(Y~Z+X)

Ftest  <- ((sum(lm2$residuals^2)-sum(lm1$residuals^2))/1)/(sum(lm1$residuals^2)/(numiter-4-1))

#sum((Y - estcate0*(1-X)*Z - - estcate1*(X)*Z)^2)
difftest <- (estcate1 - estcate0)
dvartest <- var(Y1[Z==1]) - var(Y0[Z==0])

Fdist <- diffdist <- dvardist <- rep(NA,numiter)

for (i in 1:numiter) {
	Zri <- sample(Z)
	estcate0ri <- mean(Y1[X==0 & Zri==1]) - mean(Y0[X==0 & Zri==0]) 
	estcate1ri <- mean(Y1[X==1 & Zri==1]) - mean(Y0[X==1 & Zri==0]) 
	Yri <- Y0*(1-Zri) + Y1*Zri

	lm1ri  <- lm(Yri~Zri*X)
	lm2ri  <- lm(Yri~Zri+X)

	Fdist[i]  <- ((sum(lm2ri$residuals^2)-sum(lm1ri$residuals^2))/1)/(sum(lm1ri$residuals^2)/(numiter-4-1))

	#SSRdist[i] <- 
	#sum(lm(Yri~Zri*X)$residuals^2)/sum(lm(Yri~Zri)$residuals^2)
	diffdist[i] <- (estcate1ri - estcate0ri)
	dvardist[i] <- var(Y1[Zri==1]) - var(Y0[Zri==0])
	if (i %% 5000 == 1) cat(i,"")
	}

#compute p-value for difference-in-variance 
mean(abs(dvardist) >= abs(dvartest))

#Compute CATE for both high and low levels of parent literacy
mean(Y[X==1 & Z==1]) - mean(Y[X==1 & Z==0]) 
mean(Y[X==0 & Z==1]) - mean(Y[X==0 & Z==0]) 

#Compute p-values for both f-test and difference test for difference in CATEs
mean(Fdist >= Ftest)
mean(abs(diffdist) >= abs(difftest))


detach(JPE)