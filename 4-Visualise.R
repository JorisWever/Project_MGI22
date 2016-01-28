## Geo-scripting WUR
## January 2016
## Joris Wever, Erwin van den Berg
## Group: MGI 22

# Launch shiny app


# Import Libraries
library(shiny)
library(leaflet)

# Import Data
user_data <- readRDS("shiny-app/data/user_data.rds")

# Launch Shiny app
runApp(appDir = paste(getwd(), '/shiny-app', sep = ''))