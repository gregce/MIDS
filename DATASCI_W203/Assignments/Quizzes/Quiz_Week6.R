prime.sieve <- function(number, first_prime=2) {
  ##hold a vector of numbers to check in a variable  
  ##start at 2 given the above note using the function's default argument
  to_check <- c(first_prime:number) 
  
  ##initatilize primes variable vector to store results into  
  primes <- NULL
  count <- 0
  
  ##initatilize loop variable  
  loop <- first_prime
  while (loop*loop < number) {
    primes <- c(primes, to_check[1])
    ##remove multiples from to_check vector
    to_check <- subset(to_check, !to_check %% loop == 0)
    
    ## update loop variable with next prime after multiples are removed
  loop <- to_check[1]
    count <- count+1
  }
  ##given the loop stops "prematurely", concatenate remaining primes from to_check vector with primes storage vector 
  primes <- c(primes,to_check)
  
  ##can comment out these two print lines, for info only
  print(paste("Loop executed ", count, " times"))
  print(paste("Your number,", number, ", contains ", length(primes), " primes up to it and they are:"))
  return(primes)
}

prime.sieve(1000)

##http://www.cyclismo.org/tutorial/R/pValues.html
##http://www.measuringu.com/zcalc.htm
##http://www.dummies.com/how-to/content/how-to-use-if133else-statements-in-r.html
##http://www.statmethods.net/management/controlstructures.html

t.test <- function(data=c(), mu, pop.sd, two.tailed=TRUE, significance=.05) {
  xbar <- mean(data)
  n <- length(data)
  z <- (xbar - mu) / (pop.sd /sqrt(n))
 
   if (two.tailed==TRUE) {
  p <- 2*pnorm(-abs(z))
  } else {
  p <- pnorm(-abs(z))
  }
  
  
  return(list(p)
  
}