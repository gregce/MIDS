library(data.table)
library(stargazer)

## define function
sem <- function(x) sqrt(var(x)/length(x))

set.seed(2)

d <- data.table(id = 1:52)
d[ , firm := rep(LETTERS, each = 2) ]


d[ , tau   := rep(sample(c(1,0), size = 26, replace = TRUE), each = 2)]
d[ , treat := rep(c(0,1), times = 26)] 
d[ , yPre  := rep(rnorm(26), each = 2)]
d[ , yPost := yPre + tau * treat ]

## with a model
m <- lm(yPost ~ treat, data = d)
m1 <- lm(yPost ~ treat + as.factor(firm), data = d)
stargazer(m, m1, type = "text", omit = "as.factor")
## notes:
##   - note that the intercept changes
##   - note that the point estiamte on the causal effect does not
##   - note the improvement in the performance of the causal estimator
##     in the case that we condition on the firm level, pre-treatment
##     differences 

## with a matched pairs design
d[, calcTau := yPost - yPre,
  by = "firm"][treat == 1, .(m  = mean(calcTau),   # note the 'chaining' 
                             se = sem(calcTau) ) ] # hizzah 

## we've just derived the matched pairs estimator from
## getting lucky in section. (on the fly). 
##
## you're going to have to define what are the comparisons that
## you want to make? online vs. offline? MIDS vs. Phoenix? 
d[, calcTau := yPost[treat == 1] - yPost[treat == 0],
  by = "firm"][ , .(m  = mean(calcTau),
                    se = sem(calcTau) ) ] 

## now we're really making hay! if we were looking at this with a
## standard framework, we would at best be looking at m1.
## we're realizing a 30% reduction in our SE vs. m1. 

##
## Another Example: binomial 
## 

d <- data.table(id = 1:52)
d[ , firm := rep(LETTERS, each = 2) ]

tau <- rep(sample(c(1,0), size = 26, replace = TRUE), each = 2)
treat <- rep(c(0,1), times = 26)
d[ , tau   := tau]
d[ , treat := treat] 
d[ , yPre  := rep(rbinom(26, size = 1, prob = .5), each = 2)]
d[ , yPost := yPre + tau * treat ]

## 
## Punchline: 
##
## is this going to decrease our sample size?
## yes! in fact, it will, but it will decrease our variance 
## and in most cases that i can think of, this variance improvement
## will outweigh our sample size penalty (which is in \sqrt{n}) .
##
