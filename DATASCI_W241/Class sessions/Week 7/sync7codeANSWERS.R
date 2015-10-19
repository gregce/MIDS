library(data.table)
library(stargazer)

makeData <- TRUE

set.seed(1)

if(makeData) {
    simSize <- 1000
    d <- data.table(female = sample(c(0,1), simSize, replace = TRUE),
                    affluence = sample(1:7, simSize, replace = TRUE),
                    preY = rnorm(simSize, mean = 100, sd = 7),
                    treat = sample(c(0,1), simSize, replace = TRUE) )
    d$literacy <- rnorm(simSize, mean = d$affluence, sd = 2)
    tau <- rnorm(simSize, mean = 5 + d$female ## + d$affluence
                 )
    d$postY <-  d$preY + tau*d$treat
}

## What is the (unobserved) true average treatment effect?

## Estimate a model that includes only the treatment effect.
## Interpret all the coefficients. 
mod0 <- lm(postY ~ treat, data = d)

## Estimate a model that includes the treatmnet effect and
## the (highly predictive!) pre-treatment Y val. 
mod1 <- lm(postY ~ preY + treat, data = d)

## Print the two next to each other, and compare what is going on.
## Tell me what is happening in the differences in the intercept
## and the preY coefficients. Tell me what is happening in the SE
## for the treatment effect. 
stargazer(mod0, mod1, type = "text")

## Subset the data into two groups based on gender and estimate
## a model that only includes the preY and treatment effects.
## Print these two models side by side, and tell me what is going
## on.

mod2 <- lm(postY ~ preY + treat, data = subset(d, female == 0))
mod3 <- lm(postY ~ preY + treat, data = subset(d, female == 1))
stargazer(mod2, mod3, type = "text")

## Based on this, would you conclude that these are different?
## Talk about the 95% CI for each.
confint(mod2)
confint(mod3)

## Now, estimate two more models:
##  1. A model with preY, treatment and gender indicator
##  2. A model with prey, treatment, gender, and treatment*gender
##     interaction
##  3. Test for the necessisity of the interaction; first using a
##     t-test. This should be really, really simple. Then, using a
##     f-test for the nested models (see the anova(...) call).
##     Is the p-value the same or different for this test?
##     Why? 

mod4 <- lm(postY ~ preY + treat + female, data = d)
mod5 <- lm(postY ~ preY + treat + female + treat*female, data = d)
stargazer(mod4, mod5, type = "text")

anova(mod5, mod4)

## Finally, use the results from model 5 to tell me what the treatment
## effect is for males and for females.

tauMale <- coef(mod5)["treat"]
tauFemale <- sum(coef(mod5)[c("treat", "female", "treat:female")])

## 
## AT HOME:
## Work to examine what including the other affluence and literacy
## triggers does to your estimates.
##
