### WEEK 4 ###
#Benefits of blocking
group #recall the group variable
randomize <- function() sample(c(rep(0,20),rep(1,20)))
#on average groups are split evenly, but fr any partiuclar
randomization they often are not
table(group, randomize())
table(group, randomize())
table(group, randomize())
est.ate <- function(outcome, treat) mean(outcome[treat==1]) -
  mean(outcome[treat==0])
sim.normal.study <- function(){
  po.control <- c(seq(from = 1, to = 20), seq(from = 51, to =
                                                70))
  po.treatment <- po.control
  treatment <- randomize()
  outcomes <- po.treatment * treatment + po.control * (1-
                                                         treatment)
  ate <- est.ate(outcomes, treatment)
  n.women.treatment <- table(group, treatment)[2,2]
  return(list(ate = ate, n.women.treatment = n.women.treatment))
}
results <- t(replicate(1000, sim.normal.study()))
plot(results)
randomize.blocked <- function(){
  c(
    sample(c(rep(0,10),rep(1,10))), #group A
    sample(c(rep(0,10),rep(1,10))) #group B
  )
}
#now groups are always balanced
table(group, randomize.blocked())
table(group, randomize.blocked())
table(group, randomize.blocked())
#results of the experiment with blocking
po.control <- c(seq(from = 1, to = 20), seq(from = 51, to = 70))
po.treatment <- po.control + 10 #simulate effect of 10
treatment.blocked <- randomize.blocked()
outcomes.blocked <- po.treatment * treatment.blocked + po.control *
  (1-treatment.blocked)
ate <- est.ate(outcomes.blocked, treatment.blocked)
ate
distribution.under.sharp.null.blocked <- replicate(5000,
                                                   est.ate(outcomes.blocked, randomize.blocked()))
plot(density(distribution.under.sharp.null), col="red", ylim=c(0,.17))
#distribution without blocking
abline(v=ate)
mean(ate < distribution.under.sharp.null)
lines(density(distribution.under.sharp.null.blocked), col="blue")
#distribution with blocking
mean(ate < distribution.under.sharp.null.blocked)
#Similar gains when using regression
po.control <- c(seq(from = 1, to = 20), seq(from = 51, to = 70))
po.treatment <- po.control + 10 #simulate effect of 10
treatment <- randomize()
outcomes <- po.treatment * treatment + po.control * (1-treatment)
summary(lm(outcomes ~ treatment)) #without block indicator
summary(lm(outcomes ~ treatment + factor(group))) #with block
indicator
#Clustering can decrease power
n.classrooms <- 8
n.students <- 16
classroom.ids <- unlist(lapply(1:n.classrooms, function(x)
  rep(x,times=n.students)))
classroom.ids
all.classrooms <- unique(classroom.ids)
all.classrooms
classroom.level.noise <- rnorm(length(all.classrooms))
classroom.level.noise
student.outcomes.control <- rnorm(length(classroom.ids)) +
  classroom.level.noise[classroom.ids]
student.outcomes.control
student.outcomes.treat <- student.outcomes.control + 0.75
randomize.clustered <- function(){
  treat.classroom.ids <- sample(all.classrooms, n.classrooms/2)
  return(
    as.numeric(classroom.ids %in% treat.classroom.ids)
  )
}
randomize.clustered()
randomize.clustered()
randomize.clustered()
#Clustered
treat <- randomize.clustered()
outcomes <- treat * student.outcomes.treat + (1-treat) *
  student.outcomes.control
ate <- est.ate(outcomes, treat)
ate
distribution.under.sharp.null <- replicate(5000, est.ate(outcomes,
                                                         randomize.clustered()))
plot(density(distribution.under.sharp.null))
abline(v=ate)
mean(ate < distribution.under.sharp.null) #p-value
#What if we ignore clustering?
randomize.ignorning.clustering <- function()
  sample(c(rep(0,n.classrooms*n.students/
                 2),rep(1,n.classrooms*n.students/2)))
randomize.ignorning.clustering()
distribution.under.sharp.null.wrong <- replicate(5000,
                                                 est.ate(outcomes, randomize.ignorning.clustering()))
plot(density(distribution.under.sharp.null), ylim=c(0,1.5))
lines(density(distribution.under.sharp.null.wrong))
abline(v=ate)
mean(ate < distribution.under.sharp.null.wrong) #p-value
#No cluster level noise
plot(density(replicate(5000, est.ate(rnorm(length(classroom.ids)),
                                     randomize.clustered()))), xlim=c(-2,2)) #no classroom level noise
added
lines(density(replicate(5000, est.ate(rnorm(length(classroom.ids)) +
                                        classroom.level.noise[classroom.ids], randomize.clustered()))))
#classroom level noise added
lines(density(replicate(5000, est.ate(rnorm(length(classroom.ids)) + 
                                        rnorm(length(classroom.ids)), randomize.clustered())))) #not clustered
noise of same size