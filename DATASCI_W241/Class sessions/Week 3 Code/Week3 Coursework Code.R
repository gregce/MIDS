### WEEK 3 ###
#Simulate an experiment with no effect
group <- c(rep("Man",20),rep("Woman",20))
po.control <- c(seq(from = 1, to = 20), seq(from = 51, to = 70))
po.treatment <- po.control #no effect because potential outcomes in treatment are the same
po.control
po.treatment
#Function to randomly assign units to treatment and control
randomize <- function() sample(c(rep(0,20),rep(1,20)))
randomize()
randomize()
treatment <- randomize() #Conduct randomization for this experiment
treatment
#Realized outcomes - treatment outcome for those randomized totreatment and control outcome forthose randomized to control
outcomes <- po.treatment * treatment + po.control*(1-treatment)
outcomes
#Function to estimate the average treatment effect
est.ate <- function(outcome, treat) mean(outcome[treat==1]) -
  mean(outcome[treat==0])
ate <- est.ate(outcomes, treatment) #Compute the average treatment
effect for this experiment
ate #you see a difference, despite there being no effect!
#How big is that difference likely to be on average?
#We can simulate this a few times to get a sense of how much our
treatment effect estimate would vary by chance
est.ate(outcomes, randomize())
est.ate(outcomes, randomize())
est.ate(outcomes, randomize())
#Do this 5,000 to get a sense of the distribution
distribution.under.sharp.null <- replicate(5000, est.ate(outcomes,
                                                         randomize()))
plot(density(distribution.under.sharp.null)) #It's likely we get big
differences by chance. This is a sampling distribution.
#How big was our observed difference?
plot(density(distribution.under.sharp.null))
abline(v=ate) #pretty similar to one we'd get by chance
mean(ate <= distribution.under.sharp.null) #p-value
#Simulate an experiment with a large effect
#assignment and outcomes
po.treatment <- po.control + 25
po.control
po.treatment
treatment <- randomize()
outcomes <- po.treatment * treatment + po.control*(1-treatment)
outcomes
#estimate ate
ate <- est.ate(outcomes, treatment)
ate
#what's the uncertainty?
distribution.under.sharp.null <- replicate(5000, est.ate(outcomes,
                                                         randomize()))
plot(density(distribution.under.sharp.null))
abline(v=ate)
mean(ate < distribution.under.sharp.null) #p-value
#Statistical power
#Function to simulate a study of a given treatment effect and get the
p-value
simulate.study <- function(treatment.effect.size){
  po.control <- c(seq(from = 1, to = 20), seq(from = 51, to =
                                                70))
  po.treatment <- po.control + treatment.effect.size
  treatment <- randomize()
  outcomes <- po.treatment * treatment + po.control * (1-
                                                         treatment)
  ate <- est.ate(outcomes, treatment)
  distribution.under.sharp.null <- replicate(1000,
                                             est.ate(outcomes, randomize()))
  return(mean(ate < distribution.under.sharp.null))
}
simulate.study(0) #p-value for no effect
p.values <- replicate(10000, simulate.study(0)) #distribution of pvalues
plot(density(p.values)) #uniform distribution
mean(p.values < 0.05) #how often is p.value under 0.05 when there's no
effect?
p.values <- replicate(1000, simulate.study(10))
plot(density(p.values))
mean(p.values < 0.05) #somewhat likely to detect this effect
p.values <- replicate(1000, simulate.study(20))
plot(density(p.values))
mean(p.values < 0.05) #very likely to detect this effect
#How does power behave?
simulate.study.lm <- function(baseline, effect.size, sample.size){
  control.units <- rbinom(sample.size, 1, baseline)
  treatment.units <- rbinom(sample.size, 1, baseline +
                              effect.size)
  all.units <- c(control.units, treatment.units)
  treatment.vector <- c(rep(0,sample.size), rep(1,sample.size))
  p.value <- summary(lm(all.units ~ treatment.vector))
  $coefficients[2,4]
  effect.detected <- p.value < 0.05
  return(effect.detected)
}
get.power <- function(baseline, effect.size, sample.size){
  return(mean(replicate(2000, simulate.study.lm(baseline,
                                                effect.size, sample.size))))
}
#Increasing effect size
get.power(.1, .05, 100)
get.power(.1, .1, 100)
get.power(.1, .15, 100)
get.power(.1, .2, 100)
get.power(.1, .25, 100)
#Increasing sample size
get.power(.1, .05, 100)
get.power(.1, .05, 200)
get.power(.1, .05, 300)
get.power(.1, .05, 400)
get.power(.1, .05, 500)
get.power(.1, .05, 1000)
get.power(.1, .05, 5000)
#Confidence interval
summary(lm(outcomes ~ treatment))
estimate.in.confidence.interval <- function(){
  true.effect <- 25
  #Simulate outcomes
  po.control <- c(seq(from = 1, to = 20), seq(from = 51, to =
                                                70))
  po.treatment <- po.control + true.effect
  treatment <- randomize()
  outcomes <- po.treatment * treatment + po.control*(1-
                                                       treatment)
  #Run regression
  regression <- summary(lm(outcomes ~ treatment))
  estimate <- regression$coefficients[2,1]
  standard.error <- regression$coefficients[2,2]
  lower.bound <- estimate - standard.error * 1.96
  upper.bound <- estimate + standard.error * 1.96
  #Is estimate in CI?
  estimate.in.ci <- lower.bound < true.effect & upper.bound >
    true.effect
  return(estimate.in.ci)
}
estimate.in.confidence.interval()
mean(replicate(10000, estimate.in.confidence.interval()))