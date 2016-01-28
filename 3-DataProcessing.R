## 1 - Import Python all_users csv from 2-main pythons output.

# Initialize
in_path <- 'output/locations_from_Py.csv'
out_path <- 'project-app/data/user_data.rds'

# Import csv as dataframe
all_users_df <- read.csv(in_path, header = FALSE, sep = ';')
names(all_users_df) <- c('Login','Location','Language','Latitude','Longitude','Country')



## 2 - Count the amount of unique locations there are.

# Get unique combos of latitude + longitude
Coords <- paste(all_users_df$Latitude,all_users_df$Longitude) # combine 2 cols
unique_users <- as.data.frame(table(Coords)) # Get frequency
count <- unique_users[,2] # subtract the frequency from the df

# Initialize empty vectors before they will be filled during the for-loop
lons <- c(rep(unique_users[,1]))
lats <- c(rep(unique_users[,1]))
locations <- c(rep(unique_users[,1]))

## Main for-loop
# Store the result in a dataframe
for(i in 1:length(unique_users[,1])){
  # split the combined coords again
  text <- strsplit(as.character(unique_users[i,1]), ' ')
  # store the lat and long in a vector
  lats[i] <- as.numeric(text[[1]][1])
  lons[i] <- as.numeric(text[[1]][2])
}

# get location for the frequency table
for(j in 1:length(locations)){
  for(k in 1:length(all_users_df$Location)){
    if((round(all_users_df$Latitude[k], digits = 6) == round(lats[j], digits = 6))
       &&
       (round(all_users_df$Longitude[k], digits = 6) == round(lons[j], digits = 6)))
      
      {locations[j] <- as.character(all_users_df$Location[k])}
  }
}

# Create a unique users dataframe
unique_users_df <- data.frame(lons,lats,count,locations)
names(unique_users_df) <- c('lon','lat','users','location')



## 3 - Expand the table with collumns for all languages, and count them

# Get count of Languages
lang_levels <- as.character(levels(all_users_df$Language)) # get all unique languages

# Initialize dataframe
language_df <- data.frame(matrix(ncol = (length(lang_levels)+4), nrow = length(count)))
colnames(language_df) <- append(c('longitude','latitude','users','location'), as.vector(lang_levels))

# Fill longitude, latitude, amount of users and the location
for(i in 1:length(language_df$latitude)){
  language_df$longitude[i] <- unique_users_df$lon[i]
  language_df$latitude[i] <- unique_users_df$lat[i]
  language_df$users[i] <- unique_users_df$users[i]
  language_df$location[i] <- as.character(unique_users_df$location[i])
}

# Replace NA's by 0's
language_df[is.na(language_df)] <- 0

# Keep track of number of processed users.
counter = 0

# fill languages with the amount of times they occur at the given location
# loop over the complete user dataset
for(i in 1:length(all_users_df$Language)){
  # retrieve stats of the current user that the loops takes a look at
  current_language <- as.character(all_users_df$Language[i])
  current_lat <- all_users_df$Latitude[i]
  current_lon <- all_users_df$Longitude[i]
  # loop for a match in language_df:
  for(j in 1:length(language_df$longitude)){
    if((round(current_lat, digits = 6) == round(language_df$latitude[j], digits = 6))
        &&
        (round(current_lon, digits = 6) == round(language_df$longitude[j], digits = 6))){
      for(k in names(language_df)){
        if(k == current_language){
          counter <- counter +1
          language_df[[k]][j] <- language_df[[k]][j] +1
        }
      }
    }
  }
}

# If the counter is equal to the length of the comple user list, 
# Then all user-language combinations where processed and inputted in the language_df
if(counter == length(all_users_df$Latitude)){
  print("Hooray, it worked!")
}else{
  print("Language_df was not filled properly...")
}



## 4 - Export to Shiny 

# Update the colnames, since the original onces contain special characters that can not be recognized by leaflet.
colnames(language_df)[6] <- 'Csharp'
colnames(language_df)[7] <- 'Cplusplus'
colnames(language_df)[14] <- 'EmacsLisp'
colnames(language_df)[27] <- 'ObjectiveC'
colnames(language_df)[28] <- 'ObjectiveCandRuby'
colnames(language_df)[31] <- 'PHPandHTML'
colnames(language_df)[34] <- 'PythonAndJavascript'

# Sort data
output_users_df <- language_df[order(language_df$users, decreasing = TRUE),]

# write date to a RDS
saveRDS(output_users_df, out_path)




# The next part wasn't used because of insufficient time!

# Get count of Countries

# countries_df <- as.data.frame(table(all_usersdf$Country))
# countries_df
# length(countries_df[,2]) # number of unique countries with freq
# levels(all_users_df$Country) # gets al lthe unique countries
