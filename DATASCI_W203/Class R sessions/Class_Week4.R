# 
# #attempting to produce the normal (gaussian) and univariate distributions
# #number of trials
# size <- c(500)
# 
# #run uniniform
# ruv <- runif(size, min = 5, max = 15)
# 
# #run normal dist
# rnv <- rnorm(n= size, mean = 10, sd = 2)
# 
# #produce histogram
# hist(ruv)
rm(list = ls())

pop = c(12,4,8,9,2,5,12,11)

### CLt DEMO
sample.size <- 3
samp <- sample(pop, sample.size, replace=TRUE)
