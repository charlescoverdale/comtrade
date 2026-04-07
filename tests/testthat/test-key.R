test_that("ct_set_key stores key as option", {
  old <- getOption("comtrade.key")
  on.exit(options(comtrade.key = old))

  ct_set_key("test-key-12345")
  expect_equal(getOption("comtrade.key"), "test-key-12345")
})

test_that("ct_set_key rejects empty key", {
  expect_error(ct_set_key(""), "non-empty")
  expect_error(ct_set_key(123), "non-empty")
})

test_that("ct_set_key with install sets env var", {
  old_opt <- getOption("comtrade.key")
  old_env <- Sys.getenv("COMTRADE_API_KEY")
  on.exit({
    options(comtrade.key = old_opt)
    Sys.setenv(COMTRADE_API_KEY = old_env)
  })

  ct_set_key("test-env-key", install = TRUE)
  expect_equal(Sys.getenv("COMTRADE_API_KEY"), "test-env-key")
})

test_that("ct_cache_clear works on empty cache", {
  op <- options(comtrade.cache_dir = tempdir())
  on.exit(options(op))

  expect_no_error(ct_cache_clear())
})
