# Trade Concentration Index (HHI)

Compute the Herfindahl-Hirschman Index measuring the concentration of a
country's trade across partners or products.

## Usage

``` r
ct_hhi(
  reporter,
  flow = "X",
  year = NULL,
  by = "partner",
  level = 2L,
  cache = TRUE
)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- flow:

  Character. `"X"` or `"M"`. Default `"X"`.

- year:

  Integer. Year to query.

- by:

  Character. Concentrate by `"partner"` or `"product"`. Default
  `"partner"`.

- level:

  Integer. HS digit level (only used when `by = "product"`). Default 2.

- cache:

  Logical. Default `TRUE`.

## Value

A data.frame with columns: year, hhi, concentration, n_items, top_item,
top_share_pct.

## Details

HHI ranges from 0 (perfectly diversified) to 10,000 (single
partner/product). Interpretation: \< 1,500 = low concentration,
1,500-2,500 = moderate, \> 2,500 = high.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

# Export partner concentration
ct_hhi("AUS", flow = "X", year = 2023, by = "partner")
#> Warning: Country code "ALL" not found in reference table. Passing to API as-is.
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#> Error in ct_request(endpoint, params): Comtrade API error (HTTP 400).

# Export product concentration
ct_hhi("AUS", flow = "X", year = 2023, by = "product")
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#>   year  hhi concentration n_items
#> 1 2023 2094      moderate      97
#>                                                                                               top_item
#> 1 Mineral fuels, mineral oils and products of their distillation; bituminous substances; mineral waxes
#>   top_share_pct
#> 1         34.98

options(op)
# }
```
