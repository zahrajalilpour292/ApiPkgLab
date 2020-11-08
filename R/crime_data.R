#'CrimeData
#'@description  This ftech the api data and return dataframe
#'@param limit The number of observations to be fetched from the api
#'@title CrimesDataframe
#'@return Returns the dataframe with observations
#'@export
#'
get_crime_dataframe <- function(limit){
  
  stopifnot(is.numeric(limit),
            length(limit) == 1,
            limit >= 200)
  
  df <- fetch_api_data(limit = limit)
  return(df)
}

#'CityCordinates
#'@description The function returns the locations of crime in specific city
#'@param city_name The city for which crime locations to filter
#'@title CityCrimeLocations
#'@return Returns the matrix with latitude and longitude
#'@export
#'
get_city_crimes_loc <- function(city_name, cities_df){
  
  stopifnot(is.character(city_name),
            length(city_name) == 1)
  
  stopifnot(is.data.frame(cities_df),
            ncol(cities_df) == 10)
  
  #df <- get_crime_dataframe(200)
  new_df <- NA
  if(city_name == "" | city_name == "All Cities"){
    new_df <- df
  }else{
    new_df <- df[df$City == city_name]
  }
  longitude <- unlist(lapply(as.vector(cities_df[,9]),as.double))
  latitude <- unlist(lapply(as.vector(cities_df[,10]),as.double))
  loc_df <- data.frame(longitude = longitude,latitude =latitude)
  return(as.matrix(loc_df))
}