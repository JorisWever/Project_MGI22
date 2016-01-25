# Import Libraries
if(!require(rjson)){
  install.packages("rjson")
  library(rjson)
}

# Load Functions



# Initialize variables
JSONdataURL <- 'https://gist.githubusercontent.com/paulmillr/4524946/raw/7dc3925fe715f9fbfbc6c4a268e4dbe5f2f3766c/github-users-stats.json'
out_fn <- 'data/usersR.csv'



## 1 - Create a dataframe from JSON data


# Create a list from the JSON data
JSONdata <- fromJSON(file=JSONdataURL)

# Convert the list (and lists inside it) to a data frame
df <- lapply(JSONdata, function(x)
{
  # Convert each group to a data frame.This assumes you have 9 elements each time
  data.frame(matrix(unlist(x), ncol=9, byrow=T))
})

# df containts now a list of data frames, connect them together in one single dataframe
df <- do.call(rbind, df)



## 2 - Remove rows where the location field is empty


# Add names to the collumns
names(df) <- c('name','login','location','language','gravatar','followers','contributions','contributionsStreak','contributionsCurrentStreak')

# Retrieve just the collumns that are needed for further processing
users_raw <- subset(df, select = c('login','location','language'))

# Replace empty fields with NA in order to later remove these rows
users_raw <- sapply(users_raw, as.character)  #This also transform the data into a matrix
users_raw[users_raw==""] <- NA

# Remove rows where the location field is empty
users <- as.data.frame(users_raw)
users <- subset(users, !is.na(users$location))

# Renumber the rows from 1 to the total length of the data.frame
row.names(users) <- 1:nrow(users)



## 3 - Write a csv-file of the cleaned users dataframe for further processing in Python
write.csv2(users, file = out_fn,row.names = FALSE)