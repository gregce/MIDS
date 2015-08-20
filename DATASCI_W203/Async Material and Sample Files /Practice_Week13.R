rm( list = ls() )
setwd("/Users/ceccarelli/MIDS/DATASCI_W203/Async Material and Sample Files /")

my.data <- read.table("Album Sales 1.dat", 
          header=TRUE)


album.sales <- lm(sales ~ adverts, data = my.data)
summary(album.sales)

cor.test(my.data$sales, my.data$adverts)


plot(my.data)
abline(album.sales)

album.sales$model


predict.lm(album.sales, newdata = data.frame(adverts = c(100,1000,666000)))



pubs <- read.table("pubs.dat", 
                      header=TRUE)

plot(pubs)
pub.lm <- lm(pubs$mortality ~ pubs$pubs)

  pub.lm$effects


##Multiple Linear regression 

album.sales2 <- read.table("Album Sales 2.dat", header = TRUE)

album.sales2.lm <- lm(sales ~ adverts, data = album.sales2)
album.sales3.lm <- lm(sales ~ adverts + airplay +attract, data = album.sales2)

summary(album.sales3.lm)

anova(album.sales2.lm, album.sales3.lm)

## -- Storing relevant model diagnostics in the dataframe of interest
#album2$standardized.residuals<- rstandard(albumSales.3)
#album2$studentized.residuals<-rstudent(albumSales.3)
#album2$cooks.distance<-cooks.distance(albumSales.3)
#album2$dfbeta<-dfbeta(albumSales.3)
#album2$dffit<-dffits(albumSales.3)
#album2$leverage<-hatvalues(albumSales.3)
#album2$covariance.ratios<-covratio(albumSales.3)


dwt(album.sales3.lm)
plot(album.sales3.lm)


