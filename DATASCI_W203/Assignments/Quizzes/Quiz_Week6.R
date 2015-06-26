##http://www.cyclismo.org/tutorial/R/pValues.html
##http://www.measuringu.com/zcalc.htm
##http://www.dummies.com/how-to/content/how-to-use-if133else-statements-in-r.html
##http://www.statmethods.net/management/controlstructures.html
library(plyr)

testfun <- function(data=c(), mu, pop.sd, two.tailed=TRUE, significance=.05) {
      ##computed sample mean
      xbar <- mean(data)
      ##computed sample size
      n <- length(data) 
      ##compute z score
      z <- (xbar - mu) / (pop.sd /sqrt(n))
     
      #modify and compute pvalue depending on type of test required
       if (two.tailed==TRUE) {
      p <- 2 * pnorm(z, lower.tail = FALSE)
      } else if (two.tailed==FALSE & xbar > mu) {
      p <- pnorm((z), lower.tail = FALSE)
      } else if (two.tailed==FALSE & xbar < mu) {
      p <- pnorm((z))
      }
      
      #create boolean value depending on 
      if (p>significance) {
      pass <- FALSE
      } else {
      pass <- TRUE
      }
    
    df <- data.frame(p, pass)
    colnames(df) <- c("pvalue","pass")
    return(df)
    ##return both the p value and pass boolean value
    #return(list(output1=p,output2=pass))
 
}