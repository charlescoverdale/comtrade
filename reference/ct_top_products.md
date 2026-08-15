# Top Export or Import Products

Rank a country's traded products by value, showing the top N with
percentage shares.

## Usage

``` r
ct_top_products(
  reporter,
  flow = "X",
  year = NULL,
  n = 20L,
  level = 2L,
  cache = TRUE
)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- flow:

  Character. `"X"` for exports, `"M"` for imports.

- year:

  Integer. Year to query.

- n:

  Integer. Number of top products to return. Default 20.

- level:

  Integer. HS digit level: 2, 4, or 6. Default 2.

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: commodity_code, commodity_desc, value,
share_pct, rank.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

top <- tryCatch(ct_top_products("AUS", flow = "X", year = 2023),
                error = function(e) NULL)
if (!is.null(top)) head(top)

options(op)
# }
```
