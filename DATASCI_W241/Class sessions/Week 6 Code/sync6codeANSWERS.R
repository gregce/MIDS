library(data.table)
rm(list = ls())

## The "Letter Writing Example" from p. 304
## Create Dataset

dat <- data.frame(y       = rep(NA, 400),
                  name    = rep(NA, 400),
                  grammar = rep(NA, 400) )
dat$y <- c(rep(1, 52), rep(0, 48),
           rep(1, 29), rep(0, 71),
           rep(1, 37), rep(0, 63),
           rep(1, 34), rep(0, 66) )
dat$name <- as.factor(c(rep("C", 200), rep("J",200)))
dat$grammar <- as.factor(rep(c("G", "B", "G", "B"), each = 100) )

dat$saturated <- paste(dat$name,dat$grammar, sep = ".")

## Estimate Saturated Model 
## (Hint, this is just group means)
## Second Hint: I like to use the data.table "by" call. 

## Estimate Model 
mod <- lm(y ~ name + grammar + name*grammar, data = dat)
summary(mod)

## Robust Standard Errors
library(sandwich)
library(lmtest)
mod$newse <- vcovHC(mod, type = "HC1")
coeftest(mod,mod$newse)




## Clustered Standard Errors
cl <- function(model, cluster){
    require(sandwich)
    require(lmtest)
    M <- length(unique(cluster))
    N <- length(cluster)
    K <- model$rank
    dfc <- (M/(M - 1)) * ((N - 1)/(N - K))
    uj <- apply(estfun(model), 2, function(x) tapply(x, cluster, sum));
    rcse.cov <- dfc * sandwich(model, meat = crossprod(uj)/N)
    rcse.se <- coeftest(model, rcse.cov)
    return(list(rcse.cov, rcse.se))
}
