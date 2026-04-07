#' Set the Comtrade API Key
#'
#' Store your UN Comtrade API key for the current session. The key is saved
#' as an R option and optionally as an environment variable for persistence.
#'
#' Get a free API key at \url{https://comtradedeveloper.un.org/}. The free
#' tier allows 500 calls per day and up to 100,000 records per call.
#'
#' @param key Character. Your Comtrade API subscription key.
#' @param install Logical. If `TRUE`, also sets the `COMTRADE_API_KEY`
#'   environment variable via [Sys.setenv()], which persists for the
#'   current R session. For permanent storage, add
#'   `COMTRADE_API_KEY=your-key` to your `.Renviron` file. Default `FALSE`.
#'
#' @return Invisibly returns the key.
#'
#' @export
#'
#' @examples
#' \donttest{
#' ct_set_key("your-subscription-key-here")
#' }
ct_set_key <- function(key, install = FALSE) {
  if (!is.character(key) || nchar(key) == 0L) {
    cli::cli_abort("{.arg key} must be a non-empty string.")
  }
  options(comtrade.key = key)
  if (install) {
    Sys.setenv(COMTRADE_API_KEY = key)
    cli::cli_inform(c(
      "Comtrade API key set for this session.",
      "i" = "To make permanent, add {.code COMTRADE_API_KEY={key}} to {.file ~/.Renviron}."
    ))
  } else {
    cli::cli_inform("Comtrade API key set for this session.")
  }
  invisible(key)
}

#' Clear the Comtrade Cache
#'
#' Remove all cached Comtrade API responses from the local cache directory.
#'
#' @return Invisibly returns `TRUE` if the cache was cleared, `FALSE` if
#'   no cache directory existed.
#'
#' @export
#'
#' @examples
#' \donttest{
#' op <- options(comtrade.cache_dir = tempdir())
#' ct_cache_clear()
#' options(op)
#' }
ct_cache_clear <- function() {
  dir <- ct_cache_dir()
  if (!dir.exists(dir)) {
    cli::cli_inform("No cache directory found.")
    return(invisible(FALSE))
  }
  files <- list.files(dir, pattern = "\\.rds$", full.names = TRUE)
  if (length(files) == 0L) {
    cli::cli_inform("Cache directory is already empty.")
    return(invisible(FALSE))
  }
  file.remove(files)
  cli::cli_inform("Cleared {length(files)} cached file{?s}.")
  invisible(TRUE)
}
