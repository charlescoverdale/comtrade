test_that("ct_balance returns expected structure", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_balance("GBR", year = 2022)

  expect_s3_class(df, "data.frame")
  expect_named(df, c("partner", "partner_desc", "year", "exports", "imports", "balance"))
  expect_true(nrow(df) > 0)
  # Balance should equal exports minus imports
  expect_equal(df$balance, df$exports - df$imports)
})

test_that("ct_top_products returns ranked results", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_top_products("AUS", flow = "X", year = 2022, n = 10)

  expect_s3_class(df, "data.frame")
  expect_named(df, c("commodity_code", "commodity_desc", "value", "share_pct", "rank"))
  expect_true(nrow(df) <= 10)
  expect_true(all(diff(df$rank) == 1))
  expect_true(all(df$share_pct >= 0 & df$share_pct <= 100))
})

test_that("ct_top_partners returns ranked results", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_top_partners("GBR", flow = "X", year = 2022, n = 10)

  expect_s3_class(df, "data.frame")
  expect_named(df, c("partner", "partner_desc", "value", "share_pct", "rank"))
  expect_true(nrow(df) <= 10)
})

test_that("ct_rca returns plausible values", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_rca("AUS", year = 2022, level = 2)

  expect_s3_class(df, "data.frame")
  expect_named(df, c("commodity_code", "commodity_desc", "reporter_value",
                      "world_value", "reporter_share", "world_share",
                      "rca", "has_advantage"))
  expect_true(all(df$rca >= 0))
  expect_type(df$has_advantage, "logical")
  # Australia should have RCA > 1 in mining/ores
  ores <- df[df$commodity_code == "26", ]
  if (nrow(ores) > 0) {
    expect_true(ores$has_advantage[1])
  }
})

test_that("ct_hhi returns valid concentration measures", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_hhi("AUS", flow = "X", year = 2022, by = "partner")

  expect_s3_class(df, "data.frame")
  expect_named(df, c("year", "hhi", "concentration", "n_items",
                      "top_item", "top_share_pct"))
  expect_true(df$hhi >= 0 & df$hhi <= 10000)
  expect_true(df$concentration %in% c("low", "moderate", "high"))
})

test_that("ct_growth returns time series with growth rates", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_growth("GBR", flow = "X", years = 2020:2022)

  expect_s3_class(df, "data.frame")
  expect_named(df, c("year", "value", "growth_yoy", "growth_cumulative", "index_100"))
  expect_equal(nrow(df), 3L)
  expect_true(is.na(df$growth_yoy[1]))  # First year has no YoY
  expect_equal(df$index_100[1], 100)     # Base year is 100
})

test_that("ct_growth rejects single year", {
  expect_error(ct_growth("GBR", years = 2023), "at least 2")
})

test_that("ct_share returns percentage", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_share("AUS", commodity = "TOTAL", flow = "X", year = 2022)

  expect_s3_class(df, "data.frame")
  expect_named(df, c("commodity_code", "reporter_value", "world_value", "share_pct"))
  expect_true(all(df$share_pct >= 0 & df$share_pct <= 100))
})

test_that("ct_compare requires at least 2 reporters", {
  expect_error(ct_compare("GBR"), "at least 2")
})

test_that("ct_compare returns comparison table", {
  skip_on_cran()
  skip_if_offline()
  skip_if(is.null(comtrade:::ct_get_key()), "No Comtrade API key")

  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  df <- ct_compare(c("GBR", "DEU"), year = 2022)

  expect_s3_class(df, "data.frame")
  expect_equal(nrow(df), 2L)
  expect_named(df, c("reporter", "reporter_desc", "exports", "imports",
                      "balance", "rca"))
})
