#' Trade Balance by Partner
#'
#' Compute the trade balance (exports minus imports) for a reporter country
#' against each trading partner.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param partner Character. Partner country code, or `"0"` for World.
#'   Default `"0"`.
#' @param year Integer. Year(s) to query.
#' @param commodity Character. Commodity code. Default `"TOTAL"`.
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: partner, partner_desc, year, exports,
#'   imports, balance.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_balance("GBR", year = 2023)
#' options(op)
#' }
ct_balance <- function(reporter, partner = "0", year = NULL, commodity = "TOTAL",
                       cache = TRUE) {
  df <- ct_trade(reporter, partner, commodity,
                 flow = c("X", "M"), year = year, cache = cache)
  if (nrow(df) == 0L) return(ct_empty_balance())

  exports <- df[df$flow == "X", ]
  imports <- df[df$flow == "M", ]

  exp_agg <- stats::aggregate(
    trade_value_usd ~ partner + partner_desc + year,
    data = exports, FUN = sum, na.rm = TRUE
  )
  names(exp_agg)[4] <- "exports"

  imp_agg <- stats::aggregate(
    trade_value_usd ~ partner + partner_desc + year,
    data = imports, FUN = sum, na.rm = TRUE
  )
  names(imp_agg)[4] <- "imports"

  out <- merge(exp_agg, imp_agg,
               by = c("partner", "partner_desc", "year"),
               all = TRUE)
  out$exports[is.na(out$exports)] <- 0
  out$imports[is.na(out$imports)] <- 0
  out$balance <- out$exports - out$imports

  out <- out[order(out$year, -abs(out$balance)), ]
  rownames(out) <- NULL
  out
}


#' Top Export or Import Products
#'
#' Rank a country's traded products by value, showing the top N with
#' percentage shares.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param flow Character. `"X"` for exports, `"M"` for imports.
#' @param year Integer. Year to query.
#' @param n Integer. Number of top products to return. Default 20.
#' @param level Integer. HS digit level: 2, 4, or 6. Default 2.
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: commodity_code, commodity_desc, value,
#'   share_pct, rank.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_top_products("AUS", flow = "X", year = 2023)
#' options(op)
#' }
ct_top_products <- function(reporter, flow = "X", year = NULL, n = 20L,
                            level = 2L, cache = TRUE) {
  flow <- ct_validate_flow(flow)[1]
  if (is.null(year)) year <- as.integer(format(Sys.Date(), "%Y")) - 1L
  year <- ct_validate_year(year)[1]

  commodity <- switch(as.character(level),
    "2" = "AG2",
    "4" = "AG4",
    "6" = "AG6",
    cli::cli_abort("{.arg level} must be 2, 4, or 6.")
  )

  df <- ct_trade(reporter, partner = "0", commodity = commodity,
                 flow = flow, year = year, cache = cache)

  if (nrow(df) == 0L) {
    return(data.frame(
      commodity_code = character(0), commodity_desc = character(0),
      value = numeric(0), share_pct = numeric(0), rank = integer(0),
      stringsAsFactors = FALSE
    ))
  }

  agg <- stats::aggregate(trade_value_usd ~ commodity_code + commodity_desc,
                          data = df, FUN = sum, na.rm = TRUE)
  names(agg)[3] <- "value"
  agg <- agg[order(-agg$value), ]
  total <- sum(agg$value, na.rm = TRUE)
  agg$share_pct <- round(agg$value / total * 100, 2)
  agg$rank <- seq_len(nrow(agg))

  out <- utils::head(agg, n)
  rownames(out) <- NULL
  out
}


#' Top Trading Partners
#'
#' Rank a country's trading partners by total trade value.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param flow Character. `"X"` for exports, `"M"` for imports. Default `"X"`.
#' @param year Integer. Year to query.
#' @param n Integer. Number of top partners to return. Default 20.
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: partner, partner_desc, value,
#'   share_pct, rank.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_top_partners("GBR", flow = "X", year = 2023)
#' options(op)
#' }
ct_top_partners <- function(reporter, flow = "X", year = NULL, n = 20L,
                            cache = TRUE) {
  flow <- ct_validate_flow(flow)[1]
  if (is.null(year)) year <- as.integer(format(Sys.Date(), "%Y")) - 1L
  year <- ct_validate_year(year)[1]

  # Need partner-level data: query all partners
  df <- ct_trade(reporter, partner = "all", commodity = "TOTAL",
                 flow = flow, year = year, cache = cache)

  if (nrow(df) == 0L) {
    return(data.frame(
      partner = character(0), partner_desc = character(0),
      value = numeric(0), share_pct = numeric(0), rank = integer(0),
      stringsAsFactors = FALSE
    ))
  }

  # Remove "World" aggregate
  df <- df[df$partner != 0 & df$partner_desc != "World", ]

  agg <- stats::aggregate(trade_value_usd ~ partner + partner_desc,
                          data = df, FUN = sum, na.rm = TRUE)
  names(agg)[3] <- "value"
  agg <- agg[order(-agg$value), ]
  total <- sum(agg$value, na.rm = TRUE)
  agg$share_pct <- round(agg$value / total * 100, 2)
  agg$rank <- seq_len(nrow(agg))

  out <- utils::head(agg, n)
  rownames(out) <- NULL
  out
}


#' Revealed Comparative Advantage (Balassa Index)
#'
#' Compute the Revealed Comparative Advantage for a country's exports.
#' RCA > 1 indicates the country has a comparative advantage in that product.
#'
#' The Balassa index is defined as:
#' RCA = (country exports of product i / country total exports) /
#'       (world exports of product i / world total exports)
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param year Integer. Year to query.
#' @param level Integer. HS digit level: 2, 4, or 6. Default 2.
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: commodity_code, commodity_desc,
#'   reporter_value, world_value, reporter_share, world_share, rca,
#'   has_advantage.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' rca <- ct_rca("AUS", year = 2023)
#' # Products where Australia has comparative advantage
#' rca[rca$has_advantage, ]
#' options(op)
#' }
ct_rca <- function(reporter, year = NULL, level = 2L, cache = TRUE) {
  if (is.null(year)) year <- as.integer(format(Sys.Date(), "%Y")) - 1L
  year <- ct_validate_year(year)[1]

  commodity <- switch(as.character(level),
    "2" = "AG2", "4" = "AG4", "6" = "AG6",
    cli::cli_abort("{.arg level} must be 2, 4, or 6.")
  )

  # Country exports by product
  country <- ct_trade(reporter, partner = "0", commodity = commodity,
                      flow = "X", year = year, cache = cache)
  # World exports by product
  world <- ct_trade("0", partner = "0", commodity = commodity,
                    flow = "X", year = year, cache = cache)

  if (nrow(country) == 0L || nrow(world) == 0L) {
    return(data.frame(
      commodity_code = character(0), commodity_desc = character(0),
      reporter_value = numeric(0), world_value = numeric(0),
      reporter_share = numeric(0), world_share = numeric(0),
      rca = numeric(0), has_advantage = logical(0),
      stringsAsFactors = FALSE
    ))
  }

  country_total <- sum(country$trade_value_usd, na.rm = TRUE)
  world_total <- sum(world$trade_value_usd, na.rm = TRUE)

  out <- merge(
    country[, c("commodity_code", "commodity_desc", "trade_value_usd")],
    world[, c("commodity_code", "trade_value_usd")],
    by = "commodity_code", suffixes = c("_reporter", "_world"),
    all = TRUE
  )

  names(out) <- c("commodity_code", "commodity_desc", "reporter_value", "world_value")
  out$reporter_value[is.na(out$reporter_value)] <- 0
  out$world_value[is.na(out$world_value)] <- 0

  out$reporter_share <- out$reporter_value / country_total
  out$world_share <- out$world_value / world_total

  out$rca <- ifelse(
    out$world_share > 0,
    round(out$reporter_share / out$world_share, 4),
    0
  )
  out$has_advantage <- out$rca > 1

  out <- out[order(-out$rca), ]
  rownames(out) <- NULL
  out
}


#' Trade Concentration Index (HHI)
#'
#' Compute the Herfindahl-Hirschman Index measuring the concentration of
#' a country's trade across partners or products.
#'
#' HHI ranges from 0 (perfectly diversified) to 10,000 (single
#' partner/product). Interpretation: < 1,500 = low concentration,
#' 1,500-2,500 = moderate, > 2,500 = high.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param flow Character. `"X"` or `"M"`. Default `"X"`.
#' @param year Integer. Year to query.
#' @param by Character. Concentrate by `"partner"` or `"product"`.
#'   Default `"partner"`.
#' @param level Integer. HS digit level (only used when `by = "product"`).
#'   Default 2.
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: year, hhi, concentration, n_items,
#'   top_item, top_share_pct.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#'
#' # Export partner concentration
#' ct_hhi("AUS", flow = "X", year = 2023, by = "partner")
#'
#' # Export product concentration
#' ct_hhi("AUS", flow = "X", year = 2023, by = "product")
#'
#' options(op)
#' }
ct_hhi <- function(reporter, flow = "X", year = NULL, by = "partner",
                   level = 2L, cache = TRUE) {
  flow <- ct_validate_flow(flow)[1]
  if (is.null(year)) year <- as.integer(format(Sys.Date(), "%Y")) - 1L
  by <- match.arg(by, c("partner", "product"))

  results <- lapply(year, function(y) {
    y <- ct_validate_year(y)

    if (by == "partner") {
      df <- ct_top_partners(reporter, flow, y, n = 500L, cache = cache)
      if (nrow(df) == 0L) return(NULL)
      shares <- df$share_pct / 100
      top_item <- df$partner_desc[1]
    } else {
      df <- ct_top_products(reporter, flow, y, n = 500L, level = level,
                            cache = cache)
      if (nrow(df) == 0L) return(NULL)
      shares <- df$share_pct / 100
      top_item <- df$commodity_desc[1]
    }

    hhi <- round(sum(shares^2) * 10000, 0)
    concentration <- if (hhi < 1500) "low" else if (hhi < 2500) "moderate" else "high"

    data.frame(
      year = y,
      hhi = hhi,
      concentration = concentration,
      n_items = nrow(df),
      top_item = top_item %||% NA_character_,
      top_share_pct = round(shares[1] * 100, 2),
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, results[!vapply(results, is.null, logical(1))])
  if (is.null(out)) {
    return(data.frame(
      year = integer(0), hhi = numeric(0), concentration = character(0),
      n_items = integer(0), top_item = character(0), top_share_pct = numeric(0),
      stringsAsFactors = FALSE
    ))
  }
  rownames(out) <- NULL
  out
}


#' Trade Growth Over Time
#'
#' Compute year-on-year and cumulative trade growth for a bilateral flow.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param partner Character. Partner country code. Default `"0"` (World).
#' @param commodity Character. Commodity code. Default `"TOTAL"`.
#' @param flow Character. `"X"` or `"M"`. Default `"X"`.
#' @param years Integer vector. Years to query (at least 2).
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: year, value, growth_yoy,
#'   growth_cumulative, index_100.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_growth("GBR", flow = "X", years = 2018:2023)
#' options(op)
#' }
ct_growth <- function(reporter, partner = "0", commodity = "TOTAL",
                      flow = "X", years = NULL, cache = TRUE) {
  flow <- ct_validate_flow(flow)[1]
  if (is.null(years)) {
    current <- as.integer(format(Sys.Date(), "%Y")) - 1L
    years <- (current - 4L):current
  }
  years <- ct_validate_year(years)
  if (length(years) < 2L) {
    cli::cli_abort("{.arg years} must contain at least 2 years.")
  }

  df <- ct_trade(reporter, partner, commodity, flow, year = years, cache = cache)
  if (nrow(df) == 0L) {
    return(data.frame(
      year = integer(0), value = numeric(0), growth_yoy = numeric(0),
      growth_cumulative = numeric(0), index_100 = numeric(0),
      stringsAsFactors = FALSE
    ))
  }

  agg <- stats::aggregate(trade_value_usd ~ year, data = df, FUN = sum, na.rm = TRUE)
  names(agg)[2] <- "value"
  agg <- agg[order(agg$year), ]

  base <- agg$value[1]
  agg$growth_yoy <- c(NA_real_, diff(agg$value) / utils::head(agg$value, -1) * 100)
  agg$growth_yoy <- round(agg$growth_yoy, 2)
  agg$growth_cumulative <- round((agg$value / base - 1) * 100, 2)
  agg$index_100 <- round(agg$value / base * 100, 2)

  rownames(agg) <- NULL
  agg
}


#' World Trade Share
#'
#' Compute a country's share of world trade in a given commodity.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param commodity Character. Commodity code. Default `"TOTAL"`.
#' @param flow Character. `"X"` or `"M"`. Default `"X"`.
#' @param year Integer. Year to query.
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: commodity_code, reporter_value,
#'   world_value, share_pct.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_share("AUS", commodity = "2601", flow = "X", year = 2023)
#' options(op)
#' }
ct_share <- function(reporter, commodity = "TOTAL", flow = "X",
                     year = NULL, cache = TRUE) {
  flow <- ct_validate_flow(flow)[1]
  if (is.null(year)) year <- as.integer(format(Sys.Date(), "%Y")) - 1L
  year <- ct_validate_year(year)[1]

  country <- ct_trade(reporter, "0", commodity, flow, year, cache = cache)
  world <- ct_trade("0", "0", commodity, flow, year, cache = cache)

  if (nrow(country) == 0L || nrow(world) == 0L) {
    return(data.frame(
      commodity_code = character(0), reporter_value = numeric(0),
      world_value = numeric(0), share_pct = numeric(0),
      stringsAsFactors = FALSE
    ))
  }

  out <- merge(
    stats::aggregate(trade_value_usd ~ commodity_code, data = country, FUN = sum),
    stats::aggregate(trade_value_usd ~ commodity_code, data = world, FUN = sum),
    by = "commodity_code", suffixes = c("_reporter", "_world")
  )
  names(out) <- c("commodity_code", "reporter_value", "world_value")
  out$share_pct <- round(out$reporter_value / out$world_value * 100, 4)
  out <- out[order(-out$share_pct), ]
  rownames(out) <- NULL
  out
}


#' Compare Countries
#'
#' Compare multiple countries' trade in a given commodity, showing exports,
#' imports, balance, and revealed comparative advantage.
#'
#' @param reporters Character vector. ISO3 codes for countries to compare.
#' @param commodity Character. Commodity code. Default `"TOTAL"`.
#' @param year Integer. Year to query.
#' @param cache Logical. Default `TRUE`.
#'
#' @return A data.frame with columns: reporter, reporter_desc, exports,
#'   imports, balance, rca.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_compare(c("GBR", "DEU", "FRA"), commodity = "87", year = 2023)
#' options(op)
#' }
ct_compare <- function(reporters, commodity = "TOTAL", year = NULL,
                       cache = TRUE) {
  if (length(reporters) < 2L) {
    cli::cli_abort("{.arg reporters} must contain at least 2 countries.")
  }
  if (is.null(year)) year <- as.integer(format(Sys.Date(), "%Y")) - 1L
  year <- ct_validate_year(year)[1]

  results <- lapply(reporters, function(r) {
    bal <- ct_balance(r, "0", year, commodity, cache)
    if (nrow(bal) == 0L) {
      return(data.frame(
        reporter = r, reporter_desc = NA_character_,
        exports = 0, imports = 0, balance = 0, rca = NA_real_,
        stringsAsFactors = FALSE
      ))
    }
    data.frame(
      reporter = r,
      reporter_desc = bal$partner_desc[1],
      exports = sum(bal$exports, na.rm = TRUE),
      imports = sum(bal$imports, na.rm = TRUE),
      balance = sum(bal$balance, na.rm = TRUE),
      rca = NA_real_,
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, results)
  rownames(out) <- NULL
  out
}


#' Empty balance data.frame
#' @noRd
ct_empty_balance <- function() {
  data.frame(
    partner = character(0), partner_desc = character(0),
    year = integer(0), exports = numeric(0),
    imports = numeric(0), balance = numeric(0),
    stringsAsFactors = FALSE
  )
}
