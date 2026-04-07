test_that("ct_cache_dir respects option", {
  op <- options(comtrade.cache_dir = "/tmp/test-comtrade-cache")
  on.exit(options(op))

  expect_equal(comtrade:::ct_cache_dir(), "/tmp/test-comtrade-cache")
})

test_that("ct_cache_dir uses default when option not set", {
  op <- options(comtrade.cache_dir = NULL)
  on.exit(options(op))

  dir <- comtrade:::ct_cache_dir()
  expect_true(grepl("comtrade", dir))
})

test_that("ct_validate_year rejects invalid years", {
  expect_error(comtrade:::ct_validate_year(1900), "1962")
  expect_error(comtrade:::ct_validate_year("abc"), "numeric")
  expect_error(comtrade:::ct_validate_year(3000), "current year")
})

test_that("ct_validate_year accepts valid years", {
  expect_equal(comtrade:::ct_validate_year(2023), 2023L)
  expect_equal(comtrade:::ct_validate_year(c(2020, 2021)), c(2020L, 2021L))
})

test_that("ct_validate_flow accepts valid flows", {
  expect_equal(comtrade:::ct_validate_flow("X"), "X")
  expect_equal(comtrade:::ct_validate_flow("m"), "M")
  expect_equal(comtrade:::ct_validate_flow(c("X", "M")), c("X", "M"))
})

test_that("ct_validate_flow rejects invalid flows", {
  expect_error(comtrade:::ct_validate_flow("Z"), "must be one of")
})

test_that("ct_records_to_df handles empty input", {
  out <- comtrade:::ct_records_to_df(list(), c("a", "b"))
  expect_s3_class(out, "data.frame")
  expect_equal(nrow(out), 0L)
  expect_named(out, c("a", "b"))
})

test_that("ct_records_to_df converts records", {
  records <- list(
    list(a = 1, b = "x"),
    list(a = 2, b = "y")
  )
  out <- comtrade:::ct_records_to_df(records, c("a", "b"))
  expect_equal(nrow(out), 2L)
  expect_equal(out$a, c(1, 2))
  expect_equal(out$b, c("x", "y"))
})

test_that("ct_records_to_df handles missing fields", {
  records <- list(
    list(a = 1),
    list(a = 2, b = "y")
  )
  out <- comtrade:::ct_records_to_df(records, c("a", "b"))
  expect_equal(nrow(out), 2L)
  expect_true(is.na(out$b[1]))
})

test_that("ct_resolve_country handles ISO3 codes", {
  code <- comtrade:::ct_resolve_country("GBR")
  expect_equal(code, "826")
})

test_that("ct_resolve_country handles numeric codes", {
  code <- comtrade:::ct_resolve_country(826)
  expect_equal(code, "826")
})

test_that("ct_resolve_country handles World", {
  expect_equal(comtrade:::ct_resolve_country("WORLD"), "0")
  expect_equal(comtrade:::ct_resolve_country("W00"), "0")
})

test_that("ct_cache_read returns NULL for missing file", {
  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  result <- comtrade:::ct_cache_read("nonexistent.rds")
  expect_null(result)
})

test_that("ct_cache write and read roundtrip works", {
  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  test_data <- data.frame(x = 1:3, y = letters[1:3])
  comtrade:::ct_cache_write("test_roundtrip.rds", test_data)
  result <- comtrade:::ct_cache_read("test_roundtrip.rds", max_age = 60)

  expect_equal(result, test_data)

  # Clean up
  file.remove(file.path(tempdir(), "test_roundtrip.rds"))
})
