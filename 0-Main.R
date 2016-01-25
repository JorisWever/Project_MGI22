# Import Libraries
if(!require(rjson)){
  install.packages("rjson")
  library(rjson)
}

# Load Functions
source("r/JsonToDF.R")


# Initialize variables
JSONdataURL <- 'https://gist.githubusercontent.com/paulmillr/4524946/raw/7dc3925fe715f9fbfbc6c4a268e4dbe5f2f3766c/github-users-stats.json'
out_fn <- 'data/users_from_R.csv'



## 1 - Create a dataframe from JSON data

# Call function to transform data 'JSONdataURL' in a dataframe with 9 collumns
df <- JsonToDF(JSONdataURL, 9)

# Add names to the collumns
names(df) <- c('name','login','location','language','gravatar','followers','contributions','contributionsStreak','contributionsCurrentStreak')

# Retrieve just the collumns that are needed for further processing
users_raw <- subset(df, select = c('login','location','language'))



## 2 - Remove rows where the location field is empty

# Replace empty fields with NA in order to later remove these rows
users_raw <- sapply(users_raw, as.character)  #This also transform the data into a matrix
users_raw[users_raw==""] <- NA

# Remove rows where the location field is empty
users <- as.data.frame(users_raw)
users <- subset(users, !is.na(users$location))

# Renumber the rows from 1 to the total length of the data.frame
row.names(users) <- 1:nrow(users)



## 3 - Write a csv-file of the cleaned users dataframe for further processing in Python
write.table(users, file = out_fn, row.names = FALSE, col.names = FALSE, sep=';')