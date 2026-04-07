test_that("ct_reporters returns data.frame", {
  skip_on_cran()
  skip_if_offline()

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_reporters()
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 100)
  expect_true("code" %in% names(df))
})

test_that("ct_available requires reporter", {
  expect_error(ct_available(), "reporter")
})

test_that("ct_available returns data.frame", {
  skip_on_cran()
  skip_if_offline()

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_available("GBR")
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) > 0)
  expect_true("year" %in% names(df))
})

test_that("ct_commodities returns all HS chapters", {
  df <- ct_commodities()
  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 96L)
  expect_named(df, c("code", "description", "level", "parent"))
  expect_true("27" %in% df$code)
})

test_that("ct_commodities filters by query", {
  df <- ct_commodities("fuel")
  expect_true(nrow(df) >= 1)

  df2 <- ct_commodities("27")
  expect_true(nrow(df2) >= 1)
  expect_true("27" %in% df2$code)
})

test_that("country reference table includes major economies", {
  ref <- comtrade:::ct_country_ref()
  expect_true("GBR" %in% ref$iso3)
  expect_true("USA" %in% ref$iso3)
  expect_true("AUS" %in% ref$iso3)
  expect_true("CHN" %in% ref$iso3)
  expect_true("DEU" %in% ref$iso3)
  expect_equal(ref$code[ref$iso3 == "GBR"], 826L)
  expect_equal(ref$code[ref$iso3 == "USA"], 840L)
})
