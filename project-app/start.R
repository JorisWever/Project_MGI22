setwd("/media/user/Lexar/Shiny/Tutorial/Apps")
library(shiny)
runApp("project-app")

runApp("063-superzip-example")


# write to rds file
mydata <- read.table("project-app/data/test_data.txt")
mydata <- as.data.frame(mydata)
mydata

mydata3 <- read.csv("project-app/data/locations_from_Py.csv", header = FALSE, sep = ';')
mydata3

names(mydata) <- c('lon','lat','users')


for(i in names(mydata)){
	print(i)
}

names(mydata) <- c('lon','lat','users')
saveRDS(mydata, file = "project-app/data/user_data.rds")
readRDS("project-app/data/user_data.rds")

mydata2 <- read.csv("project-app/data/locations_from_Py.csv")
mydata2
head(mydata2)


saveRDS(mydata2, file = "project-app/data/user_data2.rds")
a <- readRDS("project-app/data/user_data2.rds")
a


