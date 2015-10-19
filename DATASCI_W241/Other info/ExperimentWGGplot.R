rm(list = ls())
summary(cars)

head(mtcars)
##example plotting mtcars
ggplot(data = mtcars, aes(x = hp, y = mpg,
                          color = factor(am), alpha=carb, size = cyl)) +
  geom_point() +
  scale_color_discrete(labels = c("Automatic", "Manual")) +
  labs(color = "Transmission", x = "Horsepower",
       y = "Miles Per Gallon")

head(diamonds)

d <- as.data.frame(diamonds)

head(d,n = 100)

by(d, d$cut, mean())

complete.cases(d)

d1 <- d[complete.cases(d),1:5]

by(d1$carat, d1$cut, mean(d$carat))

stats <- summary(d)
stats[1:5,4]
attach(d)

by(carat, d[,c("cut","color")], mean, na.rm=TRUE)

library("plyr")


dfx <- data.frame(
  group = c(rep('A', 8), rep('B', 15), rep('C', 6)),
  sex = sample(c("M", "F"), size = 29, replace = TRUE),
  age = runif(n = 29, min = 18, max = 54)
)