# Compare Countries

Compare multiple countries' trade in a given commodity, showing exports,
imports, balance, and revealed comparative advantage.

## Usage

``` r
ct_compare(reporters, commodity = "TOTAL", year = NULL, cache = TRUE)
```

## Arguments

- reporters:

  Character vector. ISO3 codes for countries to compare.

- commodity:

  Character. Commodity code. Default `"TOTAL"`.

- year:

  Integer. Year to query.

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: reporter, reporter_desc, exports, imports,
balance, rca.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())
ct_compare(c("GBR", "DEU", "FRA"), commodity = "87", year = 2023)
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#>   reporter reporter_desc      exports      imports      balance rca
#> 1      GBR         World  87919734611  71448562351  16471172260  NA
#> 2      DEU         World 744966868389 504096215394 240870652994  NA
#> 3      FRA          <NA>            0            0            0  NA
options(op)
# }
```
