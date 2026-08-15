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
#> Error in ct_request(endpoint, params): Comtrade API returned a non-JSON response (HTTP 200).
#> ℹ Content type: none.
#> ℹ This is usually a transient API problem. Try again shortly.
options(op)
# }
```
