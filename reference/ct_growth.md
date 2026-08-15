# Trade Growth Over Time

Compute year-on-year and cumulative trade growth for a bilateral flow.

## Usage

``` r
ct_growth(
  reporter,
  partner = "0",
  commodity = "TOTAL",
  flow = "X",
  years = NULL,
  cache = TRUE
)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- partner:

  Character. Partner country code. Default `"0"` (World).

- commodity:

  Character. Commodity code. Default `"TOTAL"`.

- flow:

  Character. `"X"` or `"M"`. Default `"X"`.

- years:

  Integer vector. Years to query (at least 2).

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: year, value, growth_yoy, growth_cumulative,
index_100.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

g <- tryCatch(ct_growth("GBR", flow = "X", years = 2018:2023),
              error = function(e) NULL)
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
if (!is.null(g)) head(g)

options(op)
# }
```
