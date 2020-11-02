#'FetchingData
#'@title CrimeData
#'@description fecting the json data from the given url
#'@return Dataframe
#'@references "https://data.montgomerycountymd.gov/resource"
#'

crime_api <- function(){
  url <- "https://data.montgomerycountymd.gov/resource/icn6-v9z3.json"
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
  colnames(crime_df)<- c("Date", "no_victims", "District", "City", "Location", "Crime_type1", "Crime_type2", "Crime_type3") 
  return(summary(crime_df))

  
}
#crime_api()
