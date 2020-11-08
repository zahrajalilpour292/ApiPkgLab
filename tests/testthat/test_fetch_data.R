test_that("Check Url",{
  url <- get_url()
  expect_true(class(url) == "character")
  expect_true(substr(url,1,8) == "https://")
})

test_that("Check key names",{
  key_names <- get_key_names()
  expect_true(class(key_names) == "character")
  expect_true(length(key_names) == 10)
  expect_true(c("Crime_type1") == key_names[6])
})

test_that("check inputs and ouputs",{
  expect_error(fetch_api_data(limit = -1))
  expect_error(fetch_api_data(limit = "500"))
  expect_error(fetch_api_data(limit = 20))
  expect_error(fetch_api_data(url = ""))
  expect_error(fetch_api_data(url = "hello1111"))
  data <- fetch_api_data()
  expect_true(class(data) == "data.frame")
  expect_true(length(data) == 10)
  expect_equal(colnames(data[6:8]) , c("Crime_type1","Crime_type2","Crime_type3"))
})

test_that("Big query test",{
  df <- fetch_api_data(limit = 1000)
  expect_true(nrow(df) == 1000)
  df <- fetch_api_data(limit = 3000)
  expect_true(nrow(df) == 3000)
})

test_that("test user crimes function",{
  df <- get_crime_dataframe(limit = 200)
  expect_true(nrow(df) >= 200)
  expect_true(length(df) == 10)
  expect_true(class(df) == "data.frame")
  
  loc <- get_city_crimes_loc("All Cities",df)
  if(is.matrix(loc)){
    expect_true(class(loc) == "matrix")
    expect_true(dim(loc)[1] == 200)
    expect_true(dim(loc)[2] == 2)
  }
})
