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
ct_top_products("AUS", flow = "X", year = 2023)
#>    commodity_code
#> 1              27
#> 2              26
#> 3              71
#> 4              10
#> 5              25
#> 6              02
#> 7              99
#> 8              28
#> 9              84
#> 10             12
#> 11             76
#> 12             74
#> 13             85
#> 14             90
#> 15             52
#> 16             30
#> 17             07
#> 18             04
#> 19             51
#> 20             22
#>                                                                                                                                                                         commodity_desc
#> 1                                                                                 Mineral fuels, mineral oils and products of their distillation; bituminous substances; mineral waxes
#> 2                                                                                                                                                                   Ores, slag and ash
#> 3                          Natural, cultured pearls; precious, semi-precious stones; precious metals, metals clad with precious metal, and articles thereof; imitation jewellery; coin
#> 4                                                                                                                                                                              Cereals
#> 5                                                                                                                  Salt; sulphur; earths, stone; plastering materials, lime and cement
#> 6                                                                                                                                                           Meat and edible meat offal
#> 7                                                                                                                                          Commodities not specified according to kind
#> 8                                              Inorganic chemicals; organic and inorganic compounds of precious metals; of rare earth metals, of radio-active elements and of isotopes
#> 9                                                                                                        Machinery and mechanical appliances, boilers, nuclear reactors; parts thereof
#> 10                                                            Oil seeds and oleaginous fruits; miscellaneous grains, seeds and fruit, industrial or medicinal plants; straw and fodder
#> 11                                                                                                                                                      Aluminium and articles thereof
#> 12                                                                                                                                                         Copper and articles thereof
#> 13 Electrical machinery and equipment and parts thereof; sound recorders and reproducers; television image and sound recorders and reproducers, parts and accessories of such articles
#> 14                                                   Optical, photographic, cinematographic, measuring, checking, medical or surgical instruments and apparatus; parts and accessories
#> 15                                                                                                                                                                              Cotton
#> 16                                                                                                                                                             Pharmaceutical products
#> 17                                                                                                                                     Vegetables and certain roots and tubers; edible
#> 18                                                                    Dairy produce; birds' eggs; natural honey; edible products of animal origin, not elsewhere specified or included
#> 19                                                                                                                   Wool, fine or coarse animal hair; horsehair yarn and woven fabric
#> 20                                                                                                                                                      Beverages, spirits and vinegar
#>           value share_pct rank
#> 1  258342592093     34.98    1
#> 2  207273510052     28.07    2
#> 3   40121850546      5.43    3
#> 4   25726822843      3.48    4
#> 5   25631395021      3.47    5
#> 6   23582644095      3.19    6
#> 7   14508283113      1.96    7
#> 8   12510725662      1.69    8
#> 9   10550952787      1.43    9
#> 10   8927492668      1.21   10
#> 11   8610267058      1.17   11
#> 12   8267819894      1.12   12
#> 13   7780138200      1.05   13
#> 14   7765995378      1.05   14
#> 15   5781232265      0.78   15
#> 16   5325135464      0.72   16
#> 17   4280411131      0.58   17
#> 18   4017137776      0.54   18
#> 19   4001238041      0.54   19
#> 20   3552892956      0.48   20
options(op)
# }
```
