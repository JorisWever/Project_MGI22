JSONdataURL <- 'https://gist.githubusercontent.com/paulmillr/4524946/raw/7dc3925fe715f9fbfbc6c4a268e4dbe5f2f3766c/github-users-stats.json'

JsonToDF <- function(JsonData, ncol){
  ## Turns Json data into a dataframe
  #
  # JsonData: input file (.json) which will be converted to a dataframe
  # ncol:     number of collumns in the dataframe 
  
  
  # Create a list from the JSON data
  List <- fromJSON(file=JsonData)
  
  # Convert the list (and lists inside it) to a data frame
  df <- lapply(List, function(x)
  {
    # Convert each group to a data frame.This assumes you have 9 elements each time
    data.frame(matrix(unlist(x), ncol=ncol, byrow=T))
  })
  
  # df containts now a list of data frames, connect them together in one single dataframe
  df <- do.call(rbind, df)
  
  return(df)
}

