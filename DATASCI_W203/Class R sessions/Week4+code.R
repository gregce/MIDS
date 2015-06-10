# probability dist. demo
setwd('~/Desktop/MIDS W203/Live Sessions/W4/')
rm( list = ls() )
pop = c(12,4,8,9,2,5,12,11 )

pop.mean = mean(pop)
pop.sd = sd(pop)
print(pop.mean)
print(pop.sd)
hist(pop)

# CLT demo
sample.size = 30
samp = sample( pop, sample.size , replace = TRUE)
sample.mean = mean(samp)
#hist(samp,main = sample.mean)


rep.size = 1000
mysamplemean = function(){
  samp = sample( pop, sample.size , replace = TRUE)
  sample.mean = mean(samp)
}

mean.hat = replicate( rep.size, mysamplemean()  )

hist(mean.hat)
abline(v  = mean(mean.hat) , col= 'red' , lwd = 2, lty=3)

library(ggplot2)
qplot(mean.hat)+ 
  geom_histogram(color='darkblue',fill='lightblue',binwidth=.01)+
  geom_vline( xintercept = mean(mean.hat) , col='red',size=1)

