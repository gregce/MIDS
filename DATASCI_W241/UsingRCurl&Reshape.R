
pew <- read.delim(
  file = "https://ramnathv.github.io/pycon2014-r/explore/data/pew.txt",
  header = TRUE,
  stringsAsFactors = FALSE,
  check.names = F
)

pew <- read.table.url

pew <- read.table("https://ramnathv.github.io/pycon2014-r/explore/data/pew.txt",
                       header=TRUE, sep="", na.strings="NA", strip.white=TRUE )

##reading from HTTPS
require(RCurl)
mydata <- getURL("https://ramnathv.github.io/pycon2014-r/explore/data/pew.txt")
pew <- read.table(textConnection(mydata), header=TRUE)
View(pew)

library(reshape2)
pew_tidy <- melt(
  data = pew,
  id = "religion",
  variable.name = "income",
  value.name = "frequency"
)
