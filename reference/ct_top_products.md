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
#>   commodity_code
#> 1             27
#> 2             26
#> 3             71
#> 4             10
#> 5             25
#> 6             02
#>                                                                                                                                                commodity_desc
#> 1                                                        Mineral fuels, mineral oils and products of their distillation; bituminous substances; mineral waxes
#> 2                                                                                                                                          Ores, slag and ash
#> 3 Natural, cultured pearls; precious, semi-precious stones; precious metals, metals clad with precious metal, and articles thereof; imitation jewellery; coin
#> 4                                                                                                                                                     Cereals
#> 5                                                                                         Salt; sulphur; earths, stone; plastering materials, lime and cement
#> 6                                                                                                                                  Meat and edible meat offal
#>          value share_pct rank
#> 1 129171296046     34.98    1
#> 2 103636755026     28.07    2
#> 3  20060925273      5.43    3
#> 4  12863411422      3.48    4
#> 5  12815697510      3.47    5
#> 6  11791322047      3.19    6

options(op)
# }
```
