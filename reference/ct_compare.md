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

cmp <- tryCatch(ct_compare(c("GBR", "DEU", "FRA"), commodity = "87",
                           year = 2023),
                error = function(e) NULL)
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#> Waiting 3s for retry backoff ■■■■■■■■■■                      
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#> Waiting 3s for retry backoff ■■■■■■■■■■                      
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■          
#> Waiting 3s for retry backoff ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  
if (!is.null(cmp)) head(cmp)
#>   reporter reporter_desc      exports      imports      balance rca
#> 1      GBR         World  50323592758  90369060726 -40045467969  NA
#> 2      DEU         World 297611572901 160693032316 136918540585  NA
#> 3      FRA          <NA>            0            0            0  NA

options(op)
# }
```
