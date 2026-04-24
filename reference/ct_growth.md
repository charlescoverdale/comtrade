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
ct_growth("GBR", flow = "X", years = 2018:2023)
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#>   year        value growth_yoy growth_cumulative index_100
#> 1 2018 9.816807e+11         NA              0.00    100.00
#> 2 2019 1.873290e+12      90.82             90.82    190.82
#> 3 2020 1.582768e+12     -15.51             61.23    161.23
#> 4 2021 1.882191e+12      18.92             91.73    191.73
#> 5 2022 6.811529e+11     -63.81            -30.61     69.39
options(op)
# }
```
