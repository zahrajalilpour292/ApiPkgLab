library(httr)
library(jsonlite)

library(ggplot2)

url_str <-"https://data.montgomerycountymd.gov/resource/icn6-v9z3.json"
get_url <- function(){
  return(url_str)
}

fetchData <- function(){
  stopifnot(is.character(get_url))
  response <- GET(get_url)
  
  if (status_code(rep) != 200) {
    stop(
      sprintf(
        "API request failed [%s]\n%s\n<%s>", 
        status_code(rep),
        parsed$message,
        parsed$documentation_url
      ),
      call. = FALSE
    )
  }
  
  
}


str(content(rep))
# Convert to data frame
crime_parsed<-fromJSON(content(rep, "text"))
names(crime_parsed)
# get only required variables
df <- data.frame(crime_parsed$date, crime_parsed$city, crime_parsed$place,crime_parsed$crimename1,
                 crime_parsed$crimename2, crime_parsed$crimename3, crime_parsed$start_date)
head(df)
df$crime_parsed.date = as.POSIXct(df$crime_parsed.date,
                                  origin='1970-01-01',
                                  tz="GMT")
