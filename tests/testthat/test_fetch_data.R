test_that("Check Url",{
  url <- get_url()
  expect_true(class(url) == "character")
  expect_true(substr(url,1,8) == "https://")
})

test_that("Check key names",{
  key_names <- get_key_names()
  expect_true(class(key_names) == "character")
  expect_true(length(key_names) == 8)
  expect_true(c("Crime_type1") == key_names[6])
})

test_that("check inputs and ouputs",{
  expect_error(fetch_api_data(limit = -1))
  expect_error(fetch_api_data(limit = "500"))
  expect_error(fetch_api_data(limit = 20))
  expect_true(class(fetch_api_data()) == "data.frame")
})