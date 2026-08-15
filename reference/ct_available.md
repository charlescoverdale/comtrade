# Check Data Availability

Check which years and classifications have data available for a given
reporter country.

## Usage

``` r
ct_available(reporter, cache = TRUE)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- cache:

  Logical. Cache results. Default `TRUE`.

## Value

A data.frame with columns: year, classification, type (C/S), frequency
(A/M).

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())
avail <- tryCatch(ct_available("GBR"), error = function(e) NULL)
if (!is.null(avail)) head(avail)
#>   year classification type frequency
#> 1 2025             H6    C         A
#> 2 2024             H6    C         A
#> 3 2023             H6    C         A
#> 4 2022             H6    C         A
#> 5 2021             H5    C         A
#> 6 2020             H5    C         A
options(op)
# }
```
