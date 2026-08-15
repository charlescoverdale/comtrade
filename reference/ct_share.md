# World Trade Share

Compute a country's share of world trade in a given commodity.

## Usage

``` r
ct_share(reporter, commodity = "TOTAL", flow = "X", year = NULL, cache = TRUE)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- commodity:

  Character. Commodity code. Default `"TOTAL"`.

- flow:

  Character. `"X"` or `"M"`. Default `"X"`.

- year:

  Integer. Year to query.

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: commodity_code, reporter_value, world_value,
share_pct.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

sh <- tryCatch(ct_share("AUS", commodity = "2601", flow = "X", year = 2023),
               error = function(e) NULL)
if (!is.null(sh)) head(sh)

options(op)
# }
```
