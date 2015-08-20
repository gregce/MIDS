rm( list = ls() )


## Wrap Ali Gen data commands into a function to create 
## data that violates homoskedasticity

gen_data <- function(N,ncol=3) {
   #sig <- matrix(mat, nrow=3)
   #M = mvrnorm(n = N, mu = rep(1,3), Sigma = sig, )
  
   ##########
   #modify function to generate heteroskedastic data
   M <- matrix(rgamma(N, shape=1, scale=1/2),ncol = ncol)
   y.cont = 1 + 2* M[,1] - 5 * M[,2] + M[,3] + rnorm(N/ncol) ##modified
   ###########
   
   y.bin = as.numeric ( y.cont > 0 )
   X = cbind (1, M )
   y = y.cont
   #df <- data.frame(X,y)
   xy <- list("X"=X,"y"=y)
   return (xy)
}

#(c(2,.5,.25,.5,1,0,.25,0,1)
#hsk <- round(abs(rnorm(9, sd=1:9,mean = 2)),2)

list <- gen_data(N= 2700)
reg <- lm(list$y ~ list$X[,3])
summary(reg)
plot(reg)
plot(list$y, list$X[,3])
