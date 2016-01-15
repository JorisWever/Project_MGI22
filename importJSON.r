#Import and convert JSON data to R table.

if(!require(rjson)){
  install.packages("rjson")
  library(rjson)
}

JSONdataURL <- 'https://gist.githubusercontent.com/paulmillr/4524946/raw/7dc3925fe715f9fbfbc6c4a268e4dbe5f2f3766c/github-users-stats.json'

test



# ERWIN: Alles tussen de lijnen komt van internet (http://stackoverflow.com/questions/20925492/how-to-import-json-into-r-and-convert-it-to-table)
# Erwin: Hier een functie van schrijven?
#---------------------------------------------
# You can pass directly the filename
my.JSON <- fromJSON(file=JSONdataURL)

df <- lapply(my.JSON, function(user) # Loop through each "play"
{
  # Convert each group to a data frame.
  # This assumes you have 6 elements each time
  data.frame(matrix(unlist(user), ncol=9, byrow=T))
})

# Now you have a list of data frames, connect them together in
# one single dataframe
df <- do.call(rbind, df)

#--------------------------------------------



# add names to the df
names(df) <- c('name','login','location','language','gravatar','followers','contributions','contributionsStreak','contributionsCurrentStreak')
users_raw <- subset(df, select = c('name','login','location','language'))
# make the text strings and set empty cells to NA
users_raw <- sapply(users_raw, as.character)
users_raw[users_raw==""] <- NA

class(users_raw)
tail(users_raw)
nrow(users_raw)

# ERWIN: beslissing en overleg noodzakelijk voor het volgende:
#--------------------------------------------
# OF 1 - Remove rows that have a NA-value in one of the fields
users <- na.omit(users_raw)

# OF 2 - Remove rows that have a NA-value in only the location collumn
users_raw <- as.data.frame(users_raw)
users <- users_raw[!is.na(users_raw$location),]
row.names(users) <- 1:nrow(users)
#--------------------------------------------
class(users)
nrow(users)
tail(users)

# write csv from users in order to process it in python
write.csv(users, file='output/UsersR.csv', sep = ";")


