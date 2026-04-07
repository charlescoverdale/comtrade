test_that("ct_trade requires reporter", {
  expect_error(ct_trade(), "reporter")
})

test_that("ct_trade rejects invalid year", {
  expect_error(ct_trade("GBR", year = 1900), "1962")
})

test_that("ct_trade rejects too many years", {
  expect_error(ct_trade("GBR", year = 2000:2015), "Maximum 12")
})

test_that("ct_trade rejects invalid flow", {
  expect_error(ct_trade("GBR", flow = "Z"), "must be one of")
})

test_that("ct_trade returns expected structure", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_trade("GBR", partner = "0", commodity = "TOTAL",
                 flow = "X", year = 2022)

  expect_s3_class(df, "data.frame")
  expect_named(df, c(
    "reporter", "reporter_desc", "partner", "partner_desc",
    "flow", "flow_desc", "commodity_code", "commodity_desc",
    "year", "period", "trade_value_usd", "net_weight_kg",
    "quantity", "quantity_unit"
  ))
  expect_true(nrow(df) > 0)
  expect_type(df$trade_value_usd, "double")
  expect_type(df$year, "integer")
})

test_that("ct_services requires reporter", {
  expect_error(ct_services(), "reporter")
})

test_that("ct_services returns expected structure", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_services("GBR", year = 2021, flow = "X")

  expect_s3_class(df, "data.frame")
  expect_true("trade_value_usd" %in% names(df))
})
