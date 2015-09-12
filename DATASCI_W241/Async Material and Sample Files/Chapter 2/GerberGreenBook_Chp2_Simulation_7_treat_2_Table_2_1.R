# simulation in which 2 of 7 villages from Table 2.1 are assigned to treatment

rm(list=ls())       # clear objects in memory
library(ri)         # load the RI package
set.seed(1234567)   # random number seed, so that results are reproducible

# input full schedule of potential outcomes
# using Table 2.1

Y0 <- c(10,15,20,20,10,15,15)
Y1 <- c(15,15,30,15,20,15,30)

# create a potential outcomes object called a data frame

Ys <- data.frame(Y0,Y1)
# check column means
colMeans(Ys)

# create a vector of possible assignments 
Z  <- c(rep(1,2),rep(0,5))

# in order to randomly sample with replacement from Z
# type the command
# sample(Z)

# generate all permutations of Z under _complete_ random assignment
# note that default is to do every possible permutation if less than 10,000 permutations

library(ri)
perms <- genperms(Z)

# show number of permutations
cat(ncol(perms)," = number of permutations") 

probs <- genprobexact(Z,blockvar=NULL)  # inputs imply equal-probability assignment
# verify that probability of treatment is constant across the sample
table(probs)

# calculate the sampling distribution of estimated difference-in-means
truedist <- gendist(Ys,perms,Ypre=NULL,prob=probs,HT=FALSE)

# display the frequency distribution of the sampling distribution
table(truedist)

# graphically display the sampling distribution
dispdist(truedist,0)

# show the ATE estimate for each random assignment
truedist

# show the link between each estimate and each randomization
rbind(truedist)