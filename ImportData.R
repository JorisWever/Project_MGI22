if(!require(rjson)){
  install.packages("rjson")
  library(rjson)
}

JSONdataURL <- 'https://gist.githubusercontent.com/paulmillr/4524946/raw/7dc3925fe715f9fbfbc6c4a268e4dbe5f2f3766c/github-users-stats.json'

#Erwin: Het volgende gedeelte komt van internet: (http://stackoverflow.com/questions/20925492/how-to-import-json-into-r-and-convert-it-to-table)
#-----------------------------------------------
# You can pass directly the filename
JSONdata <- fromJSON(file=JSONdataURL)

df <- lapply(JSONdata, function(x)
{
  # Convert each group to a data frame.This assumes you have 9 elements each time
  data.frame(matrix(unlist(x), ncol=9, byrow=T))
})

# Now you have a list of data frames, connect them together in one single dataframe
df <- do.call(rbind, df)
#-----------------------------------------------

names(df) <- c('name','login','location','language','gravatar','followers','contributions','contributionsStreak','contributionsCurrentStreak')
class(df)
nrow(df)
tail(df)


users_raw <- subset(df, select = c('login','location','language'))
users_raw <- sapply(users_raw, as.character)
users_raw[users_raw==""] <- NA

class(users_raw)
nrow(users_raw)
tail(users_raw)

# Erwin: Beslissen of alle rijen met lege cellen eruit moeten, of alleen alle rijen waar de location een lege cel bevat
#-----------------------------------------------
# Optie 1: alle rijen met lege cellen eruit (872 van de 973 rijen)
users <- na.omit(users_raw)

# Optie 2: alle rijen met een lege cel in de 'location' kolom verwijderen (875 rijen van de 973 rijen)
users <- as.data.frame(users_raw)
users <- subset(users, !is.na(users$location))
row.names(users) <- 1:nrow(users)
#-----------------------------------------------

class(users)
nrow(users)
tail(users)

write.csv2(users, file = 'output/usersR.csv',row.names = FALSE)