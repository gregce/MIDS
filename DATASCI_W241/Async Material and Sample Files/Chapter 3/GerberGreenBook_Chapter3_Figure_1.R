rm(list=ls(all=TRUE))
library(ri)
set.seed(1234567)

Y0 <- c(0,1,2,4,4,6,6,9,14,15,16,16,17,18)
Y1 <- c(0,0,1,2,0,0,2,3,12,9,8,15,5,17)

Z <- c(1,1,0,0,0,0,0,0,0,0,0,0,1,1)

# generate all permutations of Z under _complete_ random assignment
# note that default is to do every possible permutation if less than 10,000 permutations

compperms <- genperms(Z)
numperms <- ncol(compperms)

# create empty vector
compmeans <- rep(NA,numperms)

# loop to create average treatment effect estimates for each randomization
for (i in 1:numperms) compmeans[i] <- mean(Y1[compperms[,i]==1]) - mean(Y0[compperms[,i]==0])

# randomize within blocks
block <- c(1,1,1,1,1,1,1,1,2,2,2,2,2,2)

# generate all permutations of Z under block random assignment

blockperms <- genperms(Z,block)
numperms <- ncol(blockperms)

# create empty vector
blockmeans <- rep(NA,numperms)

# loop to create average treatment effect estimates for each randomization
for (i in 1:numperms) blockmeans[i] <- weighted.mean(Y1[blockperms[,i]==1],c(8/2,8/2,6/2,6/2)) - weighted.mean(Y0[blockperms[,i]==0],c(8/6,8/6,8/6,8/6,8/6,8/6,6/4,6/4,6/4,6/4))

save(compmeans,blockmeans,file="figure3.1.Rdata")

# Draw histograms for Figure 3.1	

par(mfrow=c(2,1))
hist(compmeans,main="Sampling Distribution under Complete Randomization",xlim=c(-15,10),xlab="ATE Estimates",freq=FALSE,ylim=c(0,.3))
hist(blockmeans,main="Sampling Distribution under Blocked Randomization",xlim=c(-15,10),xlab="ATE Estimates",freq=FALSE,ylim=c(0,.3))

# calculate the proportion of esitmates that are above zero

length(compmeans[compmeans > 0])
length(compmeans[compmeans > 0])/length(compmeans)

length(blockmeans[blockmeans > 0])
length(blockmeans[blockmeans > 0])/length(blockmeans)
