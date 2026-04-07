#' Get Bilateral Trade Data
#'
#' Download merchandise trade data from the UN Comtrade database.
#' Returns bilateral trade flows between reporter and partner countries,
#' optionally filtered by commodity code and trade flow direction.
#'
#' @param reporter Character. Reporter country ISO3 code (e.g., `"GBR"`,
#'   `"USA"`, `"AUS"`) or numeric M49 code. Use `"all"` for all reporters
#'   (limited to 1 per query on the free tier).
#' @param partner Character. Partner country ISO3 code, or `"0"` / `"W00"`
#'   for World (all partners aggregated). Default `"0"` (World).
#' @param commodity Character. HS commodity code(s). `"TOTAL"` for aggregate
#'   trade, `"AG2"` for all 2-digit chapters, or specific codes like `"2709"`
#'   (crude petroleum). Default `"TOTAL"`.
#' @param flow Character. Trade flow: `"X"` (exports), `"M"` (imports),
#'   `"RX"` (re-exports), `"RM"` (re-imports). Can be a vector for multiple
#'   flows. Default `c("X", "M")`.
#' @param year Integer. Year(s) to query (1962-present). Can be a vector.
#'   Maximum 12-year span per query on the free tier. Default: most recent
#'   available year.
#' @param frequency Character. `"A"` for annual (default), `"M"` for monthly.
#' @param classification Character. Commodity classification system. Default
#'   `"HS"` (latest Harmonized System revision). See `ct_commodities()` for
#'   available classifications.
#' @param cache Logical. Cache results locally for 24 hours. Default `TRUE`.
#'
#' @return A data.frame with columns:
#' \describe{
#'   \item{reporter}{Reporter country code}
#'   \item{reporter_desc}{Reporter country name}
#'   \item{partner}{Partner country code}
#'   \item{partner_desc}{Partner country name}
#'   \item{flow}{Trade flow code (X, M, RX, RM)}
#'   \item{flow_desc}{Trade flow description}
#'   \item{commodity_code}{Commodity code}
#'   \item{commodity_desc}{Commodity description}
#'   \item{year}{Reference year}
#'   \item{period}{Reference period (year or year-month)}
#'   \item{trade_value_usd}{Trade value in US dollars}
#'   \item{net_weight_kg}{Net weight in kilograms}
#'   \item{quantity}{Quantity in supplementary units}
#'   \item{quantity_unit}{Supplementary quantity unit}
#' }
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#'
#' # UK total exports to the world, 2023
#' ct_trade("GBR", year = 2023, flow = "X")
#'
#' # US imports of crude petroleum from Saudi Arabia
#' ct_trade("USA", partner = "SAU", commodity = "2709", flow = "M",
#'          year = 2020:2023)
#'
#' # Australia's top-level trade with China
#' ct_trade("AUS", partner = "CHN", year = 2023)
#'
#' options(op)
#' }
ct_trade <- function(reporter,
                     partner = "0",
                     commodity = "TOTAL",
                     flow = c("X", "M"),
                     year = NULL,
                     frequency = "A",
                     classification = "HS",
                     cache = TRUE) {

  if (missing(reporter)) {
    cli::cli_abort("{.arg reporter} is required. Use an ISO3 code (e.g., {.val GBR}).")
  }

  flow <- ct_validate_flow(flow)

  if (is.null(year)) {
    year <- as.integer(format(Sys.Date(), "%Y")) - 1L
  }
  year <- ct_validate_year(year)

  if (length(year) > 12L) {
    cli::cli_abort("Maximum 12 years per query on the free tier. Got {length(year)}.")
  }

  frequency <- match.arg(toupper(frequency), c("A", "M"))

  cache_key <- ct_cache_key(
    endpoint = "trade",
    reporter = reporter,
    partner = partner,
    commodity = paste(commodity, collapse = ","),
    flow = paste(flow, collapse = ","),
    year = paste(year, collapse = ","),
    freq = frequency,
    class = classification
  )

  if (cache) {
    cached <- ct_cache_read(cache_key)
    if (!is.null(cached)) return(cached)
  }

  params <- list(
    reporterCode = ct_resolve_country(reporter),
    partnerCode = ct_resolve_country(partner),
    cmdCode = paste(commodity, collapse = ","),
    flowCode = paste(flow, collapse = ","),
    period = paste(year, collapse = ","),
    includeDesc = "TRUE"
  )

  endpoint <- paste0("data/v1/get/C/", frequency, "/", classification)
  body <- ct_request(endpoint, params)

  records <- body$data %||% list()

  out <- ct_records_to_df(records, c(
    "reporterCode", "reporterDesc",
    "partnerCode", "partnerDesc",
    "flowCode", "flowDesc",
    "cmdCode", "cmdDesc",
    "refYear", "period",
    "primaryValue", "netWgt",
    "qty", "qtyUnitAbbr"
  ))

  if (nrow(out) > 0L) {
    names(out) <- c(
      "reporter", "reporter_desc",
      "partner", "partner_desc",
      "flow", "flow_desc",
      "commodity_code", "commodity_desc",
      "year", "period",
      "trade_value_usd", "net_weight_kg",
      "quantity", "quantity_unit"
    )
    out$trade_value_usd <- as.numeric(out$trade_value_usd)
    out$net_weight_kg <- as.numeric(out$net_weight_kg)
    out$quantity <- as.numeric(out$quantity)
    out$year <- as.integer(out$year)
  }

  if (cache) ct_cache_write(cache_key, out)
  out
}


#' Get Services Trade Data
#'
#' Download international services trade data from the UN Comtrade database
#' using the EBOPS (Extended Balance of Payments Services) classification.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param partner Character. Partner country code. Default `"0"` (World).
#' @param service Character. EBOPS service code. Default `"TOTAL"`.
#' @param flow Character. Trade flow: `"X"` (exports), `"M"` (imports).
#'   Can be a vector. Default `c("X", "M")`.
#' @param year Integer. Year(s) to query (2000-present). Default: most
#'   recent available year.
#' @param cache Logical. Cache results locally. Default `TRUE`.
#'
#' @return A data.frame with columns: reporter, reporter_desc, partner,
#'   partner_desc, flow, flow_desc, service_code, service_desc, year,
#'   trade_value_usd.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#'
#' # UK services exports to the world
#' ct_services("GBR", year = 2022, flow = "X")
#'
#' options(op)
#' }
ct_services <- function(reporter,
                        partner = "0",
                        service = "TOTAL",
                        flow = c("X", "M"),
                        year = NULL,
                        cache = TRUE) {

  if (missing(reporter)) {
    cli::cli_abort("{.arg reporter} is required.")
  }

  flow <- ct_validate_flow(flow)

  if (is.null(year)) {
    year <- as.integer(format(Sys.Date(), "%Y")) - 2L
  }
  year <- ct_validate_year(year)

  cache_key <- ct_cache_key(
    endpoint = "services",
    reporter = reporter,
    partner = partner,
    service = paste(service, collapse = ","),
    flow = paste(flow, collapse = ","),
    year = paste(year, collapse = ",")
  )

  if (cache) {
    cached <- ct_cache_read(cache_key)
    if (!is.null(cached)) return(cached)
  }

  params <- list(
    reporterCode = ct_resolve_country(reporter),
    partnerCode = ct_resolve_country(partner),
    cmdCode = paste(service, collapse = ","),
    flowCode = paste(flow, collapse = ","),
    period = paste(year, collapse = ","),
    includeDesc = "TRUE"
  )

  body <- ct_request("data/v1/get/S/A/EB02", params)
  records <- body$data %||% list()

  out <- ct_records_to_df(records, c(
    "reporterCode", "reporterDesc",
    "partnerCode", "partnerDesc",
    "flowCode", "flowDesc",
    "cmdCode", "cmdDesc",
    "refYear",
    "primaryValue"
  ))

  if (nrow(out) > 0L) {
    names(out) <- c(
      "reporter", "reporter_desc",
      "partner", "partner_desc",
      "flow", "flow_desc",
      "service_code", "service_desc",
      "year",
      "trade_value_usd"
    )
    out$trade_value_usd <- as.numeric(out$trade_value_usd)
    out$year <- as.integer(out$year)
  }

  if (cache) ct_cache_write(cache_key, out)
  out
}
