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

#'FetchingData
#'@title FecthApiData
#'@description fecting the json data from the given url
#'@param limit It tells the number of observation to get from api
#'@return It return a dataframe having the data from api and cleaned
#'@references "https://data.montgomerycountymd.gov/resource"
#'@export

fetch_api_data <- function(url = get_url(), limit = 500, offset = 0){
  
  stopifnot(is.numeric(limit),
            length(limit) == 1,
            limit > 100)
  
  
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
