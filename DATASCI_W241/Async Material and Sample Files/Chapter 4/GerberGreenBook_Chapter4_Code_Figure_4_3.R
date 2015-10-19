# Create Resresplot for Figure 4.3

rm(list=ls())       # clear objects in memory
set.seed(1234567)   # random number seed, so that results are reproducible
library(ri)       # load the RI package

# Enter in Data from Table 4.2
Y1 <- c(5,15,12,19,17,18,24,11,16,25,18,21,17,24,27,26,30,37,43,39,36,27,33,37,48,39,42,37,53,50,51,43,55,49,48,52,59,52,55,63)
Y0 <- c(5,5,6,9,10,11,12,13,14,19,20,20,20,21,24,25,27,27,30,32,32,32,32,35,35,37,38,38,41,42,43,44,45,47,48,51,52,52,57,62)
Xweak <- c(25,12,25,27,10,24,21,25,35,28,41,38,30,20,24,26,22,34,37,21,40,34,36,37,48,46,25,21,19,44,50,48,46,47,47,39,50,46,54,42)

# Display Mean
mean(Y1-Y0)

### Data Generating Process

blockvar <- c(1,1,1,1,1,3,1,1,1,1,1,3,1,1,1,1,1,1,3,3,1,1,1,2,2,3,1,1,1,2,2,2,1,1,1,2,2,2,2,2)
Z <- c(0,1,0,1,0,0,1,1,1,1,1,0,0,1,0,1,1,0,1,0,0,1,0,1,0,1,1,1,0,0,1,0,0,1,1,1,0,1,1,0)
Y <- Y0*(1-Z) + Y1*(Z)

# temp-prob

prob <- genprobexact(Z,blockvar)
cat(ate <- estate(Y,Z,Xweak,prob=prob))

### Generate Confidence Intervals

perms <- genperms(Z=Z,blockvar=blockvar, maxiter = 1000)

Ys.est <- genouts(Y,Z,ate)
estdist <- gendist(Ys.est,perms,X=Xweak,prob=prob,HT=FALSE)

# Graph Distribution of the Estimated ATE 
# dispdist(estdist,ate)

mean(estdist)
ate

Ys.est <- genouts(Y,Z,ate=0)
estdist <- gendist(Ys.est,perms,X=Xweak,prob=prob,HT=FALSE)

# Graph Distribution of the Estimated ATE 
# dispdist(estdist,ate,display.plot=FALSE)

### Comparisons to Graph Figure 4.3

weights <- Z/prob + (1-Z)/(1-prob)

summary(lm(Y~Z+Xweak,weights=weights))
summary(lm(Y~Z+Xweak+factor(blockvar)))
summary(lm(Y~Z+Xweak+factor(blockvar),weights=weights))

resresplot(Y,Z,Xweak,prob,scale=10)

# True Sampling Distribution

### CIs

Ys <- data.frame(Y0,Y1)
estdist <- gendist(Ys,perms,X=Xweak,prob=prob,HT=FALSE)
dispdist(estdist,ate)$se
mean(estdist)
mean(Y1-Y0)

