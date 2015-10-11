library(data.table)


dt2 <- data.table(x1 = rnorm(100))
dt2[ , x2 := rnorm(100, mean = 5, sd = 2)]
dt2[ , y  := 2 + x1 + x2 + rnorm(100, sd = 4)]
            
mod1 <- lm(y ~ x1 + x2, data = dt2)
summary(mod1)

dt2[ , D := sample(c(1,0), size = 100, TRUE)]
tau <- 2
dt2[ , expY := y + tau*D]

summary(lm(expY ~ D, data = dt2))
summary(lm(expY ~ x1 + x2 + D, data = dt2))

nSims <- 1000
tau <- 2
res <- array(NA, dim = c(nSims, 2))
for(i in 1:1000) { 
  dt2 <- data.table(x1 = rnorm(100))
  dt2[ , x2 := rnorm(100, mean = 5, sd = 2)]
  dt2[ , y  := 2 + x1 + x2 + rnorm(100, sd = 4)]
  dt2[ , D  := sample(c(1,0), size = 100, TRUE)]
  dt2[ , expY := y + tau*D]
  ## fit models 
  res[i, 1] <- summary(lm(expY ~ D, data = dt2))$coefficients[2,2]
  res[i, 2] <- summary(lm(expY ~ x1 + x2 + D, data = dt2))$coefficients[4,2]
  }

table(res[,1] > res[,2])

