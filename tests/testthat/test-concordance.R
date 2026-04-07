test_that("ct_concordance converts HS to SITC", {
  out <- ct_concordance("27", from = "HS", to = "SITC")
  expect_s3_class(out, "data.frame")
  expect_named(out, c("from_code", "from_desc", "to_code", "to_desc"))
  expect_equal(nrow(out), 1L)
  expect_equal(out$from_code, "27")
  expect_equal(out$to_code, "3")
})

test_that("ct_concordance converts HS to BEC", {
  out <- ct_concordance("27", from = "HS", to = "BEC")
  expect_s3_class(out, "data.frame")
  expect_equal(out$to_code, "3")
})

test_that("ct_concordance converts SITC to HS", {
  out <- ct_concordance("3", from = "SITC", to = "HS")
  expect_s3_class(out, "data.frame")
  expect_true(nrow(out) >= 1L)
  expect_true("27" %in% out$to_code)
})

test_that("ct_concordance handles multiple codes", {
  out <- ct_concordance(c("27", "84"), from = "HS", to = "SITC")
  expect_true(nrow(out) == 2L)
  expect_true("3" %in% out$to_code)
  expect_true("7" %in% out$to_code)
})

test_that("ct_concordance rejects same from and to", {
  expect_error(ct_concordance("27", from = "HS", to = "HS"), "different")
})

test_that("ct_concordance rejects invalid classification", {
  expect_error(ct_concordance("27", from = "XX", to = "HS"), "must be one of")
})

test_that("ct_concordance warns on no match", {
  expect_warning(
    out <- ct_concordance("99", from = "SITC", to = "HS"),
    "No concordance"
  )
  expect_equal(nrow(out), 0L)
})

test_that("concordance table has consistent lengths", {
  tbl <- comtrade:::ct_concordance_table()
  expect_equal(nrow(tbl), 96L)
  expect_equal(length(unique(nchar(tbl$hs_code))), 1L)
  expect_true(all(nchar(tbl$hs_code) == 2L))
})

test_that("ct_concordance covers major HS chapters", {
  # Crude oil (HS 27) -> Mineral fuels (SITC 3)
  expect_equal(ct_concordance("27", "HS", "SITC")$to_code, "3")
  # Machinery (HS 84) -> Machinery and transport (SITC 7)
  expect_equal(ct_concordance("84", "HS", "SITC")$to_code, "7")
  # Vehicles (HS 87) -> Machinery and transport (SITC 7)
  expect_equal(ct_concordance("87", "HS", "SITC")$to_code, "7")
  # Pharmaceuticals (HS 30) -> Chemicals (SITC 5)
  expect_equal(ct_concordance("30", "HS", "SITC")$to_code, "5")
})
