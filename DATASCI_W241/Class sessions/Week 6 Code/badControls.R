library(data.table) # 1.9.6

nRows <- 1000
d <- data.table(preTreatCov = runif(nRows, min = -10, max = 10))
d[, ':='(yPre = rnorm(nRows, mean = 100) + preTreatCov,
         treated = sample(c(0,1), size = nRows, replace = TRUE) ) ]
d

## define two causal effects
tau1 <- rnorm(nRows, mean = 10)
tau2 <- rnorm(nRows, mean = 5)

d[ , ':='(yPost1 = yPre + treated*tau1,
          yPost2 = yPre + treated*tau2) ]

d[,summary(lm(yPost1 ~ treated))]

d[,summary(lm(yPost2 ~ treated))]
d[,summary(lm(yPost2 ~ treated + preTreatCov))]

d[,summary(lm(yPost2 ~ treated + yPost1))]
