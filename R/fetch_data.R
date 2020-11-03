#'ApiUrl
#'@title GetUrl
#'@description This function return the base url of api.
#'@return It return a valid charater string
#'
get_url <- function(){
  return("https://data.montgomerycountymd.gov/resource/icn6-v9z3.json")
}

#'KeysName
#'@title KeysName
#'@description This function return the name of the keys to extrat from Json file
#'@return It returen a character vaector
#'
get_key_names <- function(){
  json_keys <- c("Date", 
                 "no_victims",
                 "District",
                 "City",
                 "Location",
                 "Crime_type1",
                 "Crime_type2",
                 "Crime_type3")
  return(json_keys)
}

#'AddingLimit
#'@title UrlFilter
#'@description Adds the filters in the url
#'@param new_limit The number of rows api will return
#'@return return the character
#'
extend_base_url <- function(new_limit){
  new_url <- paste0(get_url(),"?","$limit=",new_limit)
  return(new_url)
}

#'FetchingData
#'@title FecthApiData
#'@description fecting the json data from the given url
#'@param limit It tells the number of observation to get from api
#'@param url The url of our api from where we fetch data
#'@param offset The number of json pages to load from the api
#'@return It return a dataframe having the data from api and cleaned
#'@references "https://data.montgomerycountymd.gov/resource"
#'@export

fetch_api_data <- function(url = get_url(), limit = 200, offset = 0){
  # checks for the inputs of the function 
  stopifnot(is.numeric(limit),
            length(limit) == 1,
            limit > 100)
  stopifnot(is.character(url),
            length(url) == 1,
            url != "",
            url == get_url())
  
  stopifnot(is.numeric(offset),
            offset >= 0,
            length(offset) == 1)
  
  url <- extend_base_url(new_limit =limit )
  #print(url)
  
  rep <- httr::GET(url)
  # Check rep format is json
  if(httr::http_type(rep) != "application/json"){
    stop("API did not return json", call. = FALSE)
  }
  parsed <- jsonlite::fromJSON(httr::content(rep, "text"))
  if (httr::status_code(rep) != 200) {
    stop(
      sprintf(
        " API request failed ", 
        httr::status_code(rep),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }
  
  crime_objects <- names(parsed)
  crime_df <- data.frame(parsed$date, parsed$victims,parsed$district, parsed$city,parsed$location, parsed$crimename1, parsed$crimename2, parsed$crimename3)
  crime_df$parsed.date = as.POSIXct(crime_df$parsed.date,
                                    origin='1970-01-01',
                                    tz="GMT")
  colnames(crime_df)<- get_key_names()
  return(crime_df)
}
