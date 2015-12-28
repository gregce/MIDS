#library(PropCIs)
#PropCIs::add4ci(3,11,.95)

##############################
## Salient Notes                    
##############################
#
#Y =f(X)+ε.
#
#There are two main reasons that we may wish to estimate f: prediction
#and inference. We discuss each in turn.
#
#
#When a given method yields a small training MSE but a large test MSE
#, we are said to be overfitting the data
#
#The challenge lies in finding a method for which both the variance and the squared bias are low. 
#This trade-off is one of the most important recurring themes in this book.
#
#

##############################
## Useful functions / commands                    
##############################

## Clear environment variables
rm( list = ls())

## Set Working Directory
setwd("/Users/gregce/MIDS/ISLR/")

##
attach(d1) ##<-- adds all variable values to the namespace

names(d1)

pairs(d1)

plot(horsepower ,mpg)

identify(horsepower,mpg,name)


##############################
## 2.4 Exercises                    
##############################

1. 



