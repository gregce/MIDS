library(data.table) #1.9.5 from github

set.seed(1)
rows <- 101
d <- data.table(id = 1:rows) 
d[ , ':='(treat = sample(c(0,1), rows, replace = TRUE), 
          x1 = rnorm(rows), 
          x2 = rbinom(rows, 2, .25),
          x3 = sample(c("green", "blue", "red"), rows, replace = TRUE), 
          block = factor(sample(c("A", "B", "C"), rows , replace = TRUE)))
  ]

d[ , t.test(x1 ~ treat)]
d[ , t.test(x2 ~ treat)]
d[ , chisq.test(x3, treat)]

d[ , .(p1 = t.test(x1 ~ treat)$p.value, 
       p2 = t.test(x2 ~ treat)$p.value, 
       p3 = chisq.test(x3, treat)$p.value) ]

rm(d)
rows <- 201
d <- data.table(id = 1:rows)
d[ ,':='(treat = sample(c(0,1), rows, replace = TRUE),
         block = sample(c("A", "B", "C"), rows, replace = TRUE)) ]

## What if we block assign though? 
blocks <- c("A", "B", "C")
probs <- list(c(0.2, 0.2, 0.6),
              c(0.3, 0.3, 0.4),
              c(0.8, 0.1, 0.1) )

for(b in 1:3) {
    d[block == blocks[b], ':='(
          x1 = rnorm(.N, mean = b),
          x2 = rbinom(.N, 2*b, .25),
          x3 = sample(c("green", "blue", "red"), .N,
              replace = TRUE, prob = probs[[b]]) )
      ]
}

d[ , .(p1 = t.test(x1 ~ treat)$p.value, 
       p2 = t.test(x2 ~ treat)$p.value, 
       p3 = chisq.test(x3, treat)$p.value) ]


## What if you block assigned (I didn't in the code above...)
d[ , .(p1 = t.test(x1 ~ treat)$p.value, 
       p2 = t.test(x2 ~ treat)$p.value, 
       p3 = chisq.test(x3, treat)$p.value),
  by = block ]

##
## What if you are checking a bunch of covariates? 
##

df        <- data.frame(array(data=NA, dim = c(rows, 101)))
names(df) <- c("treat", paste0("x", 1:100))
df$treat  <- sample(c(0,1), size = rows, replace = TRUE)

df[,2:101] <- apply(df[,2:101], 2, rnorm) 

res      <- NA
for(j in 1:100) { 
    res[j] <- t.test(df[,j+1]~df[,1])$p.value
}
table(res < 0.05)
table(res < 0.1)

summary(glm(treat~., data = df), family = "binomial")


## Example from last week
library(foreign)

## browseURL("http://hdl.handle.net/10079/76hdrk5")
pth <- paste0("~/Downloads/",
             grep("Angrist", list.files("~/Downloads/"), value = TRUE))[1]
dat <- read.dta(file = pth)

## What does the missingness look like?
apply(dat, 2, function(x) {sum(is.na(x))})
dat <- dat[complete.cases(dat), ]

## So, how would we set up a test for covaraite balance? 
t.test(sex_name ~ vouch0, data = dat)
t.test(age ~ vouch0, data = dat)
t.test(phone ~ vouch0, data = dat)

mod1 <- glm(vouch0 ~ sex_name + age + phone, data = dat)
summary(mod1)

## but is that really telling the whole story? Nope! It turns
## out that having a math or reading score of zero is /also/ an
## indicator of missingness.
## 
## on page 233 G&G run through inverse probability weighting;
##
## we're just goign to drop for now.
##
missing <- dat$math == 0
dat <- dat[!missing, ]

t.test(dat$sex_name ~ dat$vouch0)
t.test(dat$age ~ dat$vouch0)
t.test(phone ~ vouch0, data = dat)

mod2 <- glm(vouch0 ~ sex_name + age + phone, data = dat)
summary(mod2)

##
## So, what was the effect of missingness?
##
stargazer(mod1, mod2, type = "text")


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

out400 <- sim.bad.rand(n=400)


out <- sim.bad.rand(sim.size = 200, n = 100)
plot(x = c(-.1, .1), y = c(1.5,2.5), type ='n')
points(x=out$covariance, y=out$b.ate, col = rgb(1,0,0,.5), pch = 4)
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




