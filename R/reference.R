#' List Reporter Countries
#'
#' Get the list of countries that report trade data to UN Comtrade,
#' with their ISO3 codes and M49 numeric codes.
#'
#' @param cache Logical. Cache the reference table locally. Default `TRUE`.
#'
#' @return A data.frame with columns:
#' \describe{
#'   \item{code}{M49 numeric country code (used in API queries)}
#'   \item{iso3}{ISO 3166-1 alpha-3 code (e.g., GBR, USA, AUS)}
#'   \item{name}{Country name}
#'   \item{is_group}{Logical. TRUE for country groups (e.g., EU, OECD)}
#' }
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' reporters <- ct_reporters()
#' head(reporters)
#' options(op)
#' }
ct_reporters <- function(cache = TRUE) {
  cache_key <- "reporters.rds"

  if (cache) {
    cached <- ct_cache_read(cache_key, max_age = 604800)
    if (!is.null(cached)) return(cached)
  }

  body <- ct_request("public/v1/getDA/C/A/HS", params = list(), require_key = FALSE)

  records <- body$data %||% body
  if (is.null(records) || length(records) == 0L) {
    cli::cli_abort("Failed to retrieve reporter list from Comtrade.")
  }

  reporters <- unique(vapply(records, function(x) {
    as.integer(x$reporterCode %||% NA_integer_)
  }, integer(1)))
  reporters <- reporters[!is.na(reporters)]

  out <- data.frame(
    code = reporters,
    stringsAsFactors = FALSE
  )

  ref <- ct_country_ref()
  out <- merge(out, ref, by = "code", all.x = TRUE, sort = FALSE)
  out <- out[order(out$name), ]
  rownames(out) <- NULL

  if (cache) ct_cache_write(cache_key, out)
  out
}


#' Search Commodity Codes
#'
#' Search the HS (Harmonized System) commodity classification for codes
#' matching a keyword or code pattern. Uses a built-in table of 96
#' two-digit HS chapters with descriptions.
#'
#' @param query Character. Search term (matched against commodity
#'   descriptions) or a partial HS code (e.g., `"27"` for mineral fuels).
#'   Default `NULL` (return all).
#' @param level Integer. HS digit level to return. Currently only level 2
#'   is available from the built-in table. Default `NULL` (all levels).
#'
#' @return A data.frame with columns:
#' \describe{
#'   \item{code}{HS 2-digit chapter code}
#'   \item{description}{Chapter description}
#'   \item{level}{Digit level (always 2 for built-in table)}
#'   \item{parent}{Parent code (NA for 2-digit chapters)}
#' }
#'
#' @export
#'
#' @examples
#' # Search for petroleum-related codes
#' ct_commodities("petroleum")
#'
#' # List all 2-digit HS chapters
#' ct_commodities()
#'
#' # Find codes starting with "27" (mineral fuels)
#' ct_commodities("27")
ct_commodities <- function(query = NULL, level = NULL) {
  # Use built-in concordance table for HS chapter lookup
  tbl <- ct_concordance_table()

  out <- data.frame(
    code = tbl$hs_code,
    description = tbl$hs_desc,
    level = 2L,
    parent = NA_character_,
    stringsAsFactors = FALSE
  )

  ct_filter_commodities(out, query, level)
}


#' Check Data Availability
#'
#' Check which years and classifications have data available for a given
#' reporter country.
#'
#' @param reporter Character. Reporter country ISO3 code.
#' @param cache Logical. Cache results. Default `TRUE`.
#'
#' @return A data.frame with columns: year, classification, type (C/S),
#'   frequency (A/M).
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_available("GBR")
#' options(op)
#' }
ct_available <- function(reporter, cache = TRUE) {
  if (missing(reporter)) {
    cli::cli_abort("{.arg reporter} is required.")
  }

  code <- ct_resolve_country(reporter)
  cache_key <- ct_cache_key(endpoint = "available", reporter = code)

  if (cache) {
    cached <- ct_cache_read(cache_key, max_age = 604800)
    if (!is.null(cached)) return(cached)
  }

  body <- ct_request(
    "public/v1/getDA/C/A/HS",
    params = list(reporterCode = code),
    require_key = FALSE
  )

  records <- body$data %||% body
  if (is.null(records) || length(records) == 0L) {
    return(data.frame(
      year = integer(0),
      classification = character(0),
      type = character(0),
      frequency = character(0),
      stringsAsFactors = FALSE
    ))
  }

  rows <- lapply(records, function(x) {
    data.frame(
      year = as.integer(x$period %||% NA),
      classification = x$classificationCode %||% NA_character_,
      type = x$typeCode %||% NA_character_,
      frequency = x$freqCode %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, rows)
  out <- unique(out)
  out <- out[order(out$year, decreasing = TRUE), ]
  rownames(out) <- NULL

  if (cache) ct_cache_write(cache_key, out)
  out
}


# --- Internal helpers ---

#' Resolve a country name/ISO3 to M49 code
#' @noRd
ct_resolve_country <- function(x) {
  if (is.numeric(x)) return(as.character(x))
  x <- toupper(trimws(x))
  if (x == "WORLD" || x == "W00") return("0")
  if (nchar(x) == 3L && grepl("^[A-Z]+$", x)) {
    ref <- ct_country_ref()
    match_row <- ref[toupper(ref$iso3) == x, ]
    if (nrow(match_row) > 0L) return(as.character(match_row$code[1]))
  }
  if (grepl("^[0-9]+$", x)) return(x)
  x
}

#' Built-in country reference table (common countries)
#' @noRd
ct_country_ref <- function() {
  data.frame(
    code = c(
      36L, 40L, 56L, 76L, 124L, 156L, 170L, 208L, 246L, 250L,
      276L, 300L, 344L, 348L, 356L, 360L, 372L, 376L, 380L, 392L,
      410L, 458L, 484L, 528L, 554L, 566L, 578L, 586L, 604L, 608L,
      616L, 620L, 642L, 643L, 682L, 702L, 710L, 724L, 752L, 756L,
      764L, 792L, 804L, 826L, 840L, 704L
    ),
    iso3 = c(
      "AUS", "AUT", "BEL", "BRA", "CAN", "CHN", "COL", "DNK", "FIN", "FRA",
      "DEU", "GRC", "HKG", "HUN", "IND", "IDN", "IRL", "ISR", "ITA", "JPN",
      "KOR", "MYS", "MEX", "NLD", "NZL", "NGA", "NOR", "PAK", "PER", "PHL",
      "POL", "PRT", "ROU", "RUS", "SAU", "SGP", "ZAF", "ESP", "SWE", "CHE",
      "THA", "TUR", "UKR", "GBR", "USA", "VNM"
    ),
    name = c(
      "Australia", "Austria", "Belgium", "Brazil", "Canada", "China", "Colombia",
      "Denmark", "Finland", "France", "Germany", "Greece", "Hong Kong", "Hungary",
      "India", "Indonesia", "Ireland", "Israel", "Italy", "Japan", "Korea, Rep.",
      "Malaysia", "Mexico", "Netherlands", "New Zealand", "Nigeria", "Norway",
      "Pakistan", "Peru", "Philippines", "Poland", "Portugal", "Romania",
      "Russian Federation", "Saudi Arabia", "Singapore", "South Africa", "Spain",
      "Sweden", "Switzerland", "Thailand", "Turkiye", "Ukraine",
      "United Kingdom", "United States", "Viet Nam"
    ),
    is_group = FALSE,
    stringsAsFactors = FALSE
  )
}

#' Filter commodities by query and level
#' @noRd
ct_filter_commodities <- function(df, query = NULL, level = NULL) {
  if (!is.null(level)) {
    df <- df[df$level == level, ]
  }
  if (!is.null(query) && nchar(query) > 0L) {
    query_lower <- tolower(query)
    match_code <- grepl(paste0("^", query), df$code)
    match_desc <- grepl(query_lower, tolower(df$description %||% ""), fixed = TRUE)
    df <- df[match_code | match_desc, ]
  }
  rownames(df) <- NULL
  df
}
