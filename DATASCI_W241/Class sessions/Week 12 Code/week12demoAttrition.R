library(data.table)
set.seed(2)

d <- data.table(gender = sample(c("male", "female"),     100, replace = TRUE),
                edu    = sample(c("low", "med", "high"), 100, replace = TRUE),
                bum    = sample(c("bum", "notBum"),      100, replace = TRUE),
                treat  = sample(c("treat", "control"),   100, replace = TRUE) )

d[ , y := 1 + .5 * I(gender == "female") + 2 * I(edu == "high") + 1 * I(edu == "med") + 10 * I(treat == "treat") + rnorm(.N)]

d[bum == "bum",    missing := rbinom(n = .N, size = 1, prob = .8)]
d[bum == "notBum", missing := rbinom(n = .N, size = 1, prob = .2)]
                
## Full Estimate (observe all) 
mean(d[treat == "treat", y]) - mean(d[treat == "control", y])

## Naive Estimate (observed values)
mean(d[treat == "treat" & missing == 0, y]) - mean(d[treat == "control" & missing == 0, y])

## Weighted Estimate
mod <- glm(!missing ~ (gender + edu + bum), # note this klugey solution to fixing the point that 
           data   = d,                      # max brought up. max noted that i was using weighted 
           family = "binomial" )            # probability of being missing; we wanted being observed. 

mod2 <- glm(!missing ~ treat, data = d, family = "binomial")

mod3 <- glm(!missing ~ treat * (gender + edu + bum),
           data   = d,
           family = "binomial" ) # default to "logit"


summary(mod)

d[ , weights := 1 / mod$fitted ]

ateMod <- glm(y ~ treat + gender + edu + bum,
              data    = d,
              family  = "gaussian"
             , weights = weights
              ) 

summary(ateMod)

## Extreme Value Bounds
## Let's presume that the largest value possible is the largest observed in the data.frame
## And that the smallest value is the smallest observed.

d[ , extremeMax :=y]
d[missing == 1, extremeMax := NA]
d[ , extremeMin := y]
d[missing == 1, extremeMin := NA]

## Max Effect: Give Treatment highest value of observed treatment and contol
##             lowest value of observed control

yMax <- max(d[missing == 0 & treat == "treat", y])
yMin <- min(d[missing == 0 & treat == "control", y])

## Calculate the largest this could be: 
d[missing == 1, ':='(extremeMax = yMax, extremeMin = yMin)]
mean(d[treat == "treat", extremeMax]) - mean(d[treat == "control", extremeMin])

## Calculate the smallest this could be:
d[missing == 1, ':='(extremeMax = yMin, extremeMin = yMax)]
mean(d[treat == "treat", extremeMax]) - mean(d[treat == "control", extremeMin])
