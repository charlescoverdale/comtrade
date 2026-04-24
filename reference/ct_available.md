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
ct_available("GBR")
#>    year classification type frequency
#> 1  2025             H6    C         A
#> 2  2024             H6    C         A
#> 3  2023             H6    C         A
#> 4  2022             H6    C         A
#> 5  2021             H5    C         A
#> 6  2020             H5    C         A
#> 7  2019             H5    C         A
#> 8  2018             H5    C         A
#> 9  2017             H5    C         A
#> 10 2016             H4    C         A
#> 11 2015             H4    C         A
#> 12 2014             H4    C         A
#> 13 2013             H4    C         A
#> 14 2012             H4    C         A
#> 15 2011             H3    C         A
#> 16 2010             H3    C         A
#> 17 2009             H3    C         A
#> 18 2008             H3    C         A
#> 19 2007             H3    C         A
#> 20 2006             H2    C         A
#> 21 2005             H2    C         A
#> 22 2004             H2    C         A
#> 23 2003             H2    C         A
#> 24 2002             H2    C         A
#> 25 2001             H1    C         A
#> 26 2000             H1    C         A
#> 27 1999             H1    C         A
#> 28 1998             H1    C         A
#> 29 1997             H1    C         A
#> 30 1996             H1    C         A
#> 31 1995             H0    C         A
#> 32 1994             H0    C         A
#> 33 1993             H0    C         A
options(op)
# }
```
