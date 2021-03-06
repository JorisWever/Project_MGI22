JsonToDataFrame <- function(JsonData, ncol){
  ## Turns Json data into a dataframe
  #
  # JsonData (string):  input file (.json) which will be converted to a dataframe
  # ncol        (int):  number of collumns in the dataframe 
  
  
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

