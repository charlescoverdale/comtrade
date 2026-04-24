# Get Bilateral Trade Data

Download merchandise trade data from the UN Comtrade database. Returns
bilateral trade flows between reporter and partner countries, optionally
filtered by commodity code and trade flow direction.

## Usage

``` r
ct_trade(
  reporter,
  partner = "0",
  commodity = "TOTAL",
  flow = c("X", "M"),
  year = NULL,
  frequency = "A",
  classification = "HS",
  cache = TRUE
)
```

## Arguments

- reporter:

  Character. Reporter country ISO3 code (e.g., `"GBR"`, `"USA"`,
  `"AUS"`) or numeric M49 code. Use `"all"` for all reporters (limited
  to 1 per query on the free tier).

- partner:

  Character. Partner country ISO3 code, or `"0"` / `"W00"` for World
  (all partners aggregated). Default `"0"` (World).

- commodity:

  Character. HS commodity code(s). `"TOTAL"` for aggregate trade,
  `"AG2"` for all 2-digit chapters, or specific codes like `"2709"`
  (crude petroleum). Default `"TOTAL"`.

- flow:

  Character. Trade flow: `"X"` (exports), `"M"` (imports), `"RX"`
  (re-exports), `"RM"` (re-imports). Can be a vector for multiple flows.
  Default `c("X", "M")`.

- year:

  Integer. Year(s) to query (1962-present). Can be a vector. Maximum
  12-year span per query on the free tier. Default: most recent
  available year.

- frequency:

  Character. `"A"` for annual (default), `"M"` for monthly.

- classification:

  Character. Commodity classification system. Default `"HS"` (latest
  Harmonized System revision). See
  [`ct_commodities()`](https://charlescoverdale.github.io/comtrade/reference/ct_commodities.md)
  for available classifications.

- cache:

  Logical. Cache results locally for 24 hours. Default `TRUE`.

## Value

A data.frame with columns:

- reporter:

  Reporter country code

- reporter_desc:

  Reporter country name

- partner:

  Partner country code

- partner_desc:

  Partner country name

- flow:

  Trade flow code (X, M, RX, RM)

- flow_desc:

  Trade flow description

- commodity_code:

  Commodity code

- commodity_desc:

  Commodity description

- year:

  Reference year

- period:

  Reference period (year or year-month)

- trade_value_usd:

  Trade value in US dollars

- net_weight_kg:

  Net weight in kilograms

- quantity:

  Quantity in supplementary units

- quantity_unit:

  Supplementary quantity unit

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())

# UK total exports to the world, 2023
ct_trade("GBR", year = 2023, flow = "X")
#> Error in ct_request(endpoint, params): Comtrade API authentication failed (HTTP 401).
#> ℹ Check your API key with `ct_set_key()`.
#> ℹ Get a free key at <https://comtradedeveloper.un.org/>

# US imports of crude petroleum from Saudi Arabia
ct_trade("USA", partner = "SAU", commodity = "2709", flow = "M",
         year = 2020:2023)
#> Error in ct_request(endpoint, params): Comtrade API authentication failed (HTTP 401).
#> ℹ Check your API key with `ct_set_key()`.
#> ℹ Get a free key at <https://comtradedeveloper.un.org/>

# Australia's top-level trade with China
ct_trade("AUS", partner = "CHN", year = 2023)
#> Error in ct_request(endpoint, params): Comtrade API authentication failed (HTTP 401).
#> ℹ Check your API key with `ct_set_key()`.
#> ℹ Get a free key at <https://comtradedeveloper.un.org/>

options(op)
# }
```
