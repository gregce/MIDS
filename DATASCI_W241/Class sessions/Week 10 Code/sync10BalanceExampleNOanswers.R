## Example from an earlier week
library(foreign)

## browseURL("http://hdl.handle.net/10079/76hdrk5")
pth <- paste0("~/Downloads/",
             grep("Angrist", list.files("~/Downloads/"), value = TRUE))[1]
dat <- read.dta(file = pth)

## What does the missingness look like?

## Keep only the values that are fully observed. 
dat <- dat[complete.cases(dat), ]

## Set up a t.test for balance accross each of the following
## variables:
## 
## A. sex_name
## B. age
## C. phone
##
## Would you say that the randomization seemed to 'work'?
## 
## Answers here:


## Now, set up a regression model that will also test for
## to see if the randomization worked?
##
## Answers here:



## ------------------------
## 
## but is that really telling the whole story? Nope! It turns
## out that having a math or reading score of zero is /also/ an
## indicator of missingness.
## 
## on page 233 G&G run through inverse probability weighting;
##
## Buuuuuuut...
## 
## we're just going to drop for now.
## Test for these, and drop people who aren't observed in the follow
## up. "Talk amongst yourselves..." about why this is is the WRONG
## thing to do if this were your real data. But then just do it anyways...


## Now, how well balanced are we?
## 1. Run the t.tests, and
## 2. Run with a model

## 1. T-tests

## 2. model 

##
## So, what was the effect of missingness?
##

stargazer(...)

