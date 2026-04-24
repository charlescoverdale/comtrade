# Convert Between Trade Classifications

Convert commodity codes between HS (Harmonized System), SITC, and BEC
classifications. Uses a built-in concordance table covering the most
common 2-digit HS chapters mapped to SITC sections and BEC categories.

## Usage

``` r
ct_concordance(code, from = "HS", to = "SITC")
```

## Arguments

- code:

  Character. The commodity code(s) to convert.

- from:

  Character. Source classification: `"HS"`, `"SITC"`, or `"BEC"`.

- to:

  Character. Target classification: `"HS"`, `"SITC"`, or `"BEC"`.

## Value

A data.frame with columns: from_code, from_desc, to_code, to_desc.

## Details

For detailed 4/6-digit concordances, see the `concordance` R package on
CRAN.

## Examples

``` r
# Convert HS chapter 27 (mineral fuels) to SITC
ct_concordance("27", from = "HS", to = "SITC")
#>   from_code           from_desc to_code       to_desc
#> 1        27 Mineral fuels, oils       3 Mineral fuels

# Convert SITC section 0 (food) to HS
ct_concordance("0", from = "SITC", to = "HS")
#>    from_code             from_desc to_code                 to_desc
#> 1          0 Food and live animals      01            Live animals
#> 2          0 Food and live animals      02                    Meat
#> 3          0 Food and live animals      03                    Fish
#> 4          0 Food and live animals      04      Dairy, eggs, honey
#> 5          0 Food and live animals      05   Other animal products
#> 6          0 Food and live animals      07              Vegetables
#> 7          0 Food and live animals      08             Fruit, nuts
#> 8          0 Food and live animals      09     Coffee, tea, spices
#> 9          0 Food and live animals      10                 Cereals
#> 10         0 Food and live animals      11        Milling products
#> 11         0 Food and live animals      16       Meat preparations
#> 12         0 Food and live animals      17                  Sugars
#> 13         0 Food and live animals      18                   Cocoa
#> 14         0 Food and live animals      19     Cereal preparations
#> 15         0 Food and live animals      20  Vegetable preparations
#> 16         0 Food and live animals      21 Misc. food preparations
#> 17         0 Food and live animals      23   Residues, animal feed
```
