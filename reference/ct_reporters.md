# List Reporter Countries

Get the list of countries that report trade data to UN Comtrade, with
their ISO3 codes and M49 numeric codes.

## Usage

``` r
ct_reporters(cache = TRUE)
```

## Arguments

- cache:

  Logical. Cache the reference table locally. Default `TRUE`.

## Value

A data.frame with columns:

- code:

  M49 numeric country code (used in API queries)

- iso3:

  ISO 3166-1 alpha-3 code (e.g., GBR, USA, AUS)

- name:

  Country name

- is_group:

  Logical. TRUE for country groups (e.g., EU, OECD)

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())
reporters <- ct_reporters()
head(reporters)
#>   code iso3      name is_group
#> 1   36  AUS Australia    FALSE
#> 2   40  AUT   Austria    FALSE
#> 3   56  BEL   Belgium    FALSE
#> 4   76  BRA    Brazil    FALSE
#> 5  124  CAN    Canada    FALSE
#> 6  156  CHN     China    FALSE
options(op)
# }
```
