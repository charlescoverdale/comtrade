# Internal utility functions

#' Get the Comtrade API base URL
#' @noRd
ct_base_url <- function() {

"https://comtradeapi.un.org"
}

#' Get the Comtrade API key
#'
#' Checks the option first, then the environment variable.
#'
#' @return Character string with the API key, or NULL if not set.
#' @noRd
ct_get_key <- function() {
  key <- getOption("comtrade.key", default = Sys.getenv("COMTRADE_API_KEY", ""))
  if (nchar(key) == 0L) return(NULL)
  key
}

#' Get the cache directory
#' @noRd
ct_cache_dir <- function() {
  getOption("comtrade.cache_dir",
            default = tools::R_user_dir("comtrade", "cache"))
}

#' Build a cache key from request parameters
#' @noRd
ct_cache_key <- function(...) {
  args <- list(...)
  args <- args[!vapply(args, is.null, logical(1))]
  paste0(
    paste(names(args), args, sep = "=", collapse = "_"),
    ".rds"
  )
}

#' Read from cache if available and fresh
#' @param key Cache file name
#' @param max_age Maximum cache age in seconds (default: 24 hours)
#' @return Cached data or NULL
#' @noRd
ct_cache_read <- function(key, max_age = 86400) {
  path <- file.path(ct_cache_dir(), key)
  if (!file.exists(path)) return(NULL)
  info <- file.info(path)
  age <- as.numeric(difftime(Sys.time(), info$mtime, units = "secs"))
  if (age > max_age) return(NULL)
  tryCatch(readRDS(path), error = function(e) NULL)
}

#' Write to cache
#' @param key Cache file name
#' @param data Data to cache
#' @noRd
ct_cache_write <- function(key, data) {
  dir <- ct_cache_dir()
  if (!dir.exists(dir)) dir.create(dir, recursive = TRUE, showWarnings = FALSE)
  tryCatch(
    saveRDS(data, file.path(dir, key)),
    error = function(e) invisible(NULL)
  )
}

#' Perform a Comtrade API request
#' @param endpoint API endpoint path
#' @param params Named list of query parameters
#' @param require_key Whether to require an API key
#' @return Parsed JSON response
#' @noRd
ct_request <- function(endpoint, params = list(), require_key = TRUE) {
  key <- ct_get_key()
  if (require_key && is.null(key)) {
    cli::cli_abort(c(
      "Comtrade API key not found.",
      "i" = "Get a free key at {.url https://comtradedeveloper.un.org/}",
      "i" = "Then run: {.code ct_set_key(\"your-key\")}"
    ))
  }

  url <- paste0(ct_base_url(), "/", endpoint)

  req <- httr2::request(url)
  req <- httr2::req_url_query(req, !!!params)

  if (!is.null(key)) {
    req <- httr2::req_url_query(req, `subscription-key` = key)
  }

  req <- httr2::req_throttle(req, rate = 5 / 10)
  req <- httr2::req_retry(req, max_tries = 3L, backoff = ~ 5)
  req <- httr2::req_error(req, is_error = function(resp) FALSE)

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(e) {
      cli::cli_abort(c(
        "Failed to connect to the Comtrade API.",
        "i" = "Check your internet connection.",
        "i" = "Original error: {conditionMessage(e)}"
      ))
    }
  )

  status <- httr2::resp_status(resp)

  if (status == 401L || status == 403L) {
    cli::cli_abort(c(
      "Comtrade API authentication failed (HTTP {status}).",
      "i" = "Check your API key with {.code ct_set_key()}.",
      "i" = "Get a free key at {.url https://comtradedeveloper.un.org/}"
    ))
  }

  if (status == 429L) {
    cli::cli_abort(c(
      "Comtrade API rate limit exceeded (HTTP 429).",
      "i" = "Free tier allows 500 calls/day and 5 calls/second.",
      "i" = "Wait a moment and try again."
    ))
  }

  if (status >= 400L) {
    cli::cli_abort("Comtrade API error (HTTP {status}).")
  }

  body <- httr2::resp_body_json(resp)

  if (!is.null(body$statusCode) && body$statusCode != 0L) {
    msg <- body$message %||% "Unknown API error"
    cli::cli_abort("Comtrade API returned an error: {msg}")
  }

  body
}

#' Convert a list of records to a data.frame
#' @param records List of named lists
#' @param cols Character vector of column names to extract
#' @return data.frame
#' @noRd
ct_records_to_df <- function(records, cols) {
  if (length(records) == 0L) {
    out <- data.frame(matrix(ncol = length(cols), nrow = 0))
    names(out) <- cols
    return(out)
  }

  rows <- lapply(records, function(r) {
    vals <- lapply(cols, function(col) {
      v <- r[[col]]
      if (is.null(v)) NA else v
    })
    names(vals) <- cols
    as.data.frame(vals, stringsAsFactors = FALSE)
  })

  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  out
}

#' Validate a year or vector of years
#' @noRd
ct_validate_year <- function(year) {
  if (!is.numeric(year) || any(year < 1962) || any(year > as.integer(format(Sys.Date(), "%Y")))) {
    cli::cli_abort("{.arg year} must be a numeric year between 1962 and the current year.")
  }
  as.integer(year)
}

#' Validate flow code
#' @noRd
ct_validate_flow <- function(flow) {
  valid <- c("M", "X", "RM", "RX")
  flow <- toupper(flow)
  if (!all(flow %in% valid)) {
    cli::cli_abort("{.arg flow} must be one of: {.val {valid}}.")
  }
  flow
}

#' Null-coalescing operator
#' @noRd
`%||%` <- function(x, y) if (is.null(x)) y else x
