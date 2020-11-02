require(httr)
require(jsonlite)


crime_api <- function(){
  
  url <- "https://data.montgomerycountymd.gov/resource/icn6-v9z3.json"
  rep <- GET(url)
  # Chech rep format is jason
  if(http_type(rep) != "application/json"){
    stop("API did not return json", call. = FALSE)
  }
  parsed <- fromJSON(content(rep, "text"))
  if (status_code(rep) != 200) {
    stop(
      sprintf(
        " API request failed ", 
        status_code(rep),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }
  
  crime_objects <- names(parsed)
  crime_df <- data.frame(parsed$date, parsed$victims,parsed$district, parsed$city,parsed$location, parsed$crimename1, parsed$crimename2, parsed$crimename3)
  colnames(crime_df)<- c("Date", "no_victims", "District", "City", "Location", "Crime_type1", "Crime_type2", "Crime_type3") 
  return(summary(crime_df))

  
}
crime_api()
