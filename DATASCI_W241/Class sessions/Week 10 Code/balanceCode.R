library(data.table)

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

mod <- glm(treat ~ x1 + x2 + x3 + block, data = d, family = "binomial")

## 
## What if we block assign though?
##

rm(d)
rows <- 201
d <- data.table(id = 1:rows)
d[ ,':='(treat = sample(c(0,1), rows, replace = TRUE),
         block = sample(c("A", "B", "C"), rows, replace = TRUE)) ]

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

## wrong... why? 
d[ , .(p1 = t.test(x1 ~ treat)$p.value, 
       p2 = t.test(x2 ~ treat)$p.value, 
       p3 = chisq.test(x3, treat)$p.value) ]


## right 
d[ , .(p1 = t.test(x1 ~ treat)$p.value, 
       p2 = t.test(x2 ~ treat)$p.value, 
       p3 = chisq.test(x3, treat)$p.value),
  by = block ]

## also
d[ , print(summary(glm(treat ~ x1 + x2 + x3))), by = block]


##
## What if you are checking a bunch of covariates? 
##
## This will demonstrate why bf correcting is important
## when we're making a large number of comparisons...
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
