# Top Trading Partners

Rank a country's trading partners by total trade value.

## Usage

``` r
ct_top_partners(reporter, flow = "X", year = NULL, n = 20L, cache = TRUE)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- flow:

  Character. `"X"` for exports, `"M"` for imports. Default `"X"`.

- year:

  Integer. Year to query.

- n:

  Integer. Number of top partners to return. Default 20.

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: partner, partner_desc, value, share_pct,
rank.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

top <- tryCatch(ct_top_partners("GBR", flow = "X", year = 2023),
                error = function(e) NULL)
#> Warning: Country code "ALL" not found in reference table. Passing to API as-is.
if (!is.null(top)) head(top)

options(op)
# }
```
