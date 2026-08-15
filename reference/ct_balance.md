# Trade Balance by Partner

Compute the trade balance (exports minus imports) for a reporter country
against each trading partner.

## Usage

``` r
ct_balance(
  reporter,
  partner = "0",
  year = NULL,
  commodity = "TOTAL",
  cache = TRUE
)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- partner:

  Character. Partner country code, or `"0"` for World. Default `"0"`.

- year:

  Integer. Year(s) to query.

- commodity:

  Character. Commodity code. Default `"TOTAL"`.

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: partner, partner_desc, year, exports,
imports, balance.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

# The Comtrade API is rate-limited and can return a non-JSON response
# under load. tryCatch so the example degrades gracefully if that
# happens during the CRAN check.
bal <- tryCatch(ct_balance("GBR", year = 2023), error = function(e) NULL)
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
if (!is.null(bal)) head(bal)

options(op)
# }
```
