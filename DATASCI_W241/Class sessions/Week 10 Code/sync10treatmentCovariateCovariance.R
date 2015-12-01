##
## What do we do if we have a bad randomization?
##
## a. What are the consequences for the ATE, in theory?
##    That is, is the ATE a biased or unbaised estimator?
## b. What will be the consequences for our estimated ATE
##    from the actual sample? 
##

sim.bad.rand <- function(sim.size = 200, n = 400) {
    ## make Results objects 
    res.list <- vector("list", 4)
    names(res.list) <- c("Y", "covariance", "b.ate", "u.ate")
    ## do work
    for(i in 1:sim.size) {
        Z  <- sample(c(0,1), n, T)
        X  <- sample(c(0,2), n, T)
        ## Create PO to control
        Y0 <- runif(n, min = 10, max = 11) + X
        ## Create PO to treatment
        Y1 <- Y0 + 2*Z + rnorm(n)
        ## Observe either Y_1 if treated or Y_0 if control
        Y  <- Z*Y1 + (1-Z)*Y0
        res.list$Y <- Y
        res.list$covariance[i] <- cov(X,Z)
        res.list$b.ate[i] <- lm(Y~Z)$coefficients[2]
        res.list$u.ate[i] <- lm(Y~Z+X)$coefficients[2]
    }
    return(res.list)
}

out1 <- sim.bad.rand(sim.size = 1, n = 400)

out1[c(2,3,4)]

out <- sim.bad.rand(n=400)


out <- sim.bad.rand(sim.size = 200, n = 100)


plot(x = c(-.1, .1), y = c(1.5,2.5), type ='n')
points(x=out$covariance, y=out$b.ate, col = rgb(1,0,0,.5), pch = 4)
abline(lm(out$b.ate~out$covariance))
abline(lm(out$u.ate~out$covariance), col = "blue")
points(x=out$covariance, y=out$u.ate, col = rgb(0,0,1,.5), pch = 19)

bias.ratio <- out$b.ate / out$u.ate
hist(bias.ratio)


plot(x = c(-.1, .1), y = c(1.5,2.5), type ='n')
  points(x=out$covariance, y=out$b.ate, col = rgb(1,0,0,.5), pch = 4)
  points(x=out$covariance, y=out$u.ate, col = rgb(0,0,1,.5), pch = 19)

plot(x = c(-0.01,0.01), y = c(1.5, 2.5), type = 'n')
  points(x=out$covariance, y=out$b.ate, col = rgb(1,0,0,.5), pch = 4)
  points(x=out$covariance, y=out$u.ate, col = rgb(0,0,1,.5), pch = 19)

plot(x = c(-0.005,0.005), y = c(1.5, 2.5), type = 'n')
  points(x=out$covariance, y=out$b.ate, col = rgb(1,0,0,.5), pch = 4)
  points(x=out$covariance, y=out$u.ate, col = rgb(0,0,1,.5), pch = 19)
