##setwd("/Users/ceccarelli/DataSets/")
##table <- read.table(file = "Customer.txt", header = TRUE, sep = "|", fill = TRUE, na.strings = "NA")
##hist(x=table$DiscountPercent,scale="frequency")

##initatilize primes vector to store results into
##initialize looping variable to firt prime number



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