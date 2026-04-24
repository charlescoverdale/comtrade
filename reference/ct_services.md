# Get Services Trade Data

Download international services trade data from the UN Comtrade database
using the EBOPS (Extended Balance of Payments Services) classification.

## Usage

``` r
ct_services(
  reporter,
  partner = "0",
  service = "TOTAL",
  flow = c("X", "M"),
  year = NULL,
  cache = TRUE
)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code.

- partner:

  Character. Partner country code. Default `"0"` (World).

- service:

  Character. EBOPS service code. Default `"TOTAL"`.

- flow:

  Character. Trade flow: `"X"` (exports), `"M"` (imports). Can be a
  vector. Default `c("X", "M")`.

- year:

  Integer. Year(s) to query (2000-present). Default: most recent
  available year.

- cache:

  Logical. Cache results locally. Default `TRUE`.

## Value

A data.frame with columns: reporter, reporter_desc, partner,
partner_desc, flow, flow_desc, service_code, service_desc, year,
trade_value_usd.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

# UK services exports to the world
ct_services("GBR", year = 2022, flow = "X")
#> ℹ No API key set. Using preview endpoint (500 records max, no descriptions).
#> ℹ For full access (100k records, descriptions), get a free key at
#>   <https://comtradedeveloper.un.org/>
#> ℹ Then run: `ct_set_key("your-key")`
#>  [1] reporterCode reporterDesc partnerCode  partnerDesc  flowCode    
#>  [6] flowDesc     cmdCode      cmdDesc      refYear      primaryValue
#> <0 rows> (or 0-length row.names)

options(op)
# }
```
