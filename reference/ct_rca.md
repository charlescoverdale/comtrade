# Revealed Comparative Advantage (Balassa Index)

Compute the Revealed Comparative Advantage for a country's exports. RCA
\> 1 indicates the country has a comparative advantage in that product.

## Usage

``` r
ct_rca(reporter, year = NULL, level = 2L, cache = TRUE)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- year:

  Integer. Year to query.

- level:

  Integer. HS digit level: 2, 4, or 6. Default 2.

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: commodity_code, commodity_desc,
reporter_value, world_value, reporter_share, world_share, rca,
has_advantage.

## Details

The Balassa index is defined as: RCA = (country exports of product i /
country total exports) / (world exports of product i / world total
exports)

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())
rca <- ct_rca("AUS", year = 2023)
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
# Products where Australia has comparative advantage
rca[rca$has_advantage, ]
#> [1] commodity_code commodity_desc reporter_value world_value    reporter_share
#> [6] world_share    rca            has_advantage 
#> <0 rows> (or 0-length row.names)
options(op)
# }
```
