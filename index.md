# comtrade

[![CRAN
status](https://www.r-pkg.org/badges/version/comtrade)](https://CRAN.R-project.org/package=comtrade)
[![CRAN
downloads](https://cranlogs.r-pkg.org/badges/comtrade)](https://CRAN.R-project.org/package=comtrade)
[![Total
Downloads](https://cranlogs.r-pkg.org/badges/grand-total/comtrade)](https://CRAN.R-project.org/package=comtrade)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**comtrade** provides clean, tidy access to international trade data
from the [United Nations Comtrade](https://comtradeplus.un.org/)
database directly from R, plus built-in trade analytics (RCA, HHI, trade
balance, growth rates, concordance).

## What is UN Comtrade?

The [United Nations Comtrade](https://comtradeplus.un.org/) database is
the largest repository of international merchandise trade statistics in
the world. Over 200 countries and territories report their annual and
monthly trade data to the UN Statistics Division, which standardises,
validates, and publishes it in a consistent format. The database covers
goods trade from 1962 to the present and services trade from 2000, with
commodity detail down to the 6-digit Harmonized System (HS) level.

Comtrade is the standard data source for bilateral trade flow analysis,
gravity models, revealed comparative advantage, trade policy evaluation,
and supply chain research. It underpins publications from the World
Bank, WTO, UNCTAD, and most academic trade economics research.

## How is this different from comtradr?

There is an existing R package called
[comtradr](https://cran.r-project.org/package=comtradr), maintained by
Paul Bochtler through rOpenSci. It wraps the same Comtrade Plus API.

**What comtrade adds:**

- **Built-in trade analytics**: comtradr is a data pipe only. To compute
  RCA, HHI, trade balance, or growth rates, you need additional packages
  (economiccomplexity, concordance) or manual code. comtrade includes
  [`ct_rca()`](https://charlescoverdale.github.io/comtrade/reference/ct_rca.md),
  [`ct_hhi()`](https://charlescoverdale.github.io/comtrade/reference/ct_hhi.md),
  [`ct_balance()`](https://charlescoverdale.github.io/comtrade/reference/ct_balance.md),
  [`ct_growth()`](https://charlescoverdale.github.io/comtrade/reference/ct_growth.md),
  [`ct_share()`](https://charlescoverdale.github.io/comtrade/reference/ct_share.md),
  and
  [`ct_compare()`](https://charlescoverdale.github.io/comtrade/reference/ct_compare.md)
  out of the box.
- **Classification concordance**:
  [`ct_concordance()`](https://charlescoverdale.github.io/comtrade/reference/ct_concordance.md)
  converts between HS, SITC, and BEC classifications with a built-in
  lookup table. No separate package needed.
- **Works without an API key**: basic queries use the Comtrade preview
  endpoint automatically. No registration required for simple trade
  lookups.
- **Fewer dependencies**: comtrade depends on 3 packages (cli, httr2,
  tools). comtradr depends on 14 (including lubridate, purrr, poorman,
  stringr, readr, fs, rappdirs, memoise, cachem, lifecycle, askpass).
- **CRAN-safe caching**: uses
  [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) instead
  of `rappdirs`.
- **Returns data.frames**: not tibbles. Consistent with base R
  workflows.

## Installation

``` r

# From CRAN
install.packages("comtrade")

# Development version from GitHub
# install.packages("devtools")
devtools::install_github("charlescoverdale/comtrade")
```

## API key (optional but recommended)

**Basic queries work without a key.** The package automatically falls
back to the Comtrade preview endpoint, which returns up to 500 records
per call without registration.

For full access (100,000 records per call, commodity descriptions,
detailed partner breakdowns), register for a free key at
[comtradedeveloper.un.org](https://comtradedeveloper.un.org/) (500
calls/day, no cost):

``` r

library(comtrade)
ct_set_key("your-subscription-key")
#> Comtrade API key set for this session.
```

To make it permanent so you don’t have to set it every session, add it
to your `.Renviron` file. Run `file.edit("~/.Renviron")` in R, add the
line `COMTRADE_API_KEY=your-key`, save, and restart R. The package will
pick it up automatically from then on.

## Examples

### Bilateral trade flows

``` r

library(comtrade)

# UK total exports to the world, 2023
uk <- ct_trade("GBR", flow = "X", year = 2023)
head(uk)
#>   reporter reporter_desc partner partner_desc flow flow_desc commodity_code
#>        826           GBR       0        World    X   Export          TOTAL
#>   commodity_desc year period trade_value_usd net_weight_kg quantity quantity_unit
#>            Total 2023   2023   4.685e+11             0        0          <NA>
```

### Top export products

``` r

# Australia's top 5 exports by HS chapter
ct_top_products("AUS", flow = "X", year = 2023, n = 5)
#>   commodity_code      commodity_desc        value share_pct rank
#>               26  Ores, slag, ash    1.256e+11     33.21    1
#>               27  Mineral fuels      1.081e+11     28.60    2
#>               71  Precious stones     2.014e+10      5.33    3
#>               02  Meat             1.043e+10      2.76    4
#>               10  Cereals          5.874e+09      1.55    5
```

### Trade balance

``` r

# US trade balance with China, 2020-2023
ct_balance("USA", partner = "CHN", year = 2020:2023)
#>   partner partner_desc year      exports      imports      balance
#>       156        China 2020  1.246e+11   4.352e+11  -3.106e+11
#>       156        China 2021  1.511e+11   5.063e+11  -3.552e+11
#>       156        China 2022  1.538e+11   5.368e+11  -3.830e+11
#>       156        China 2023  1.478e+11   4.272e+11  -2.794e+11
```

### Revealed comparative advantage

``` r

# Which products does Australia have a comparative advantage in?
rca <- ct_rca("AUS", year = 2023, level = 2)
head(rca[rca$has_advantage, ], 5)
#>   commodity_code commodity_desc  reporter_value  world_value  rca has_advantage
#>               26 Ores, slag      1.256e+11     3.95e+11   18.42          TRUE
#>               02 Meat            1.043e+10     1.29e+11    4.69          TRUE
#>               10 Cereals         5.874e+09     8.05e+10    4.23          TRUE
#>               51 Wool            2.817e+09     1.18e+10   13.84          TRUE
#>               04 Dairy, eggs     3.122e+09     4.67e+10    3.88          TRUE
```

### Trade concentration (HHI)

``` r

# How concentrated are Australia's export destinations?
ct_hhi("AUS", flow = "X", year = 2023, by = "partner")
#>   year  hhi concentration n_items     top_item top_share_pct
#>   2023 1847      moderate     196        China         32.71
```

### Trade growth

``` r

# UK export growth, 2018-2023
ct_growth("GBR", flow = "X", years = 2018:2023)
#>   year        value growth_yoy growth_cumulative index_100
#>   2018  4.871e+11         NA              0.00    100.00
#>   2019  4.693e+11      -3.65             -3.65     96.35
#>   2020  3.705e+11     -21.04            -23.93     76.07
#>   2021  4.037e+11       8.96            -17.12     82.88
#>   2022  5.058e+11      25.29              3.84    103.84
#>   2023  4.685e+11      -7.37             -3.82     96.18
```

### Classification concordance

``` r

# What SITC section does HS chapter 27 (mineral fuels) map to?
ct_concordance("27", from = "HS", to = "SITC")
#>   from_code          from_desc to_code       to_desc
#>          27 Mineral fuels, oils       3 Mineral fuels
```

## Functions

### Data retrieval

| Function | Purpose |
|----|----|
| [`ct_trade()`](https://charlescoverdale.github.io/comtrade/reference/ct_trade.md) | Bilateral goods trade flows (200+ countries, 1962-present) |
| [`ct_services()`](https://charlescoverdale.github.io/comtrade/reference/ct_services.md) | Services trade via EBOPS classification (2000-present) |
| [`ct_reporters()`](https://charlescoverdale.github.io/comtrade/reference/ct_reporters.md) | List available reporter countries |
| [`ct_commodities()`](https://charlescoverdale.github.io/comtrade/reference/ct_commodities.md) | Search HS commodity codes |
| [`ct_available()`](https://charlescoverdale.github.io/comtrade/reference/ct_available.md) | Check data availability for a country |

### Trade analytics

| Function | Purpose |
|----|----|
| [`ct_balance()`](https://charlescoverdale.github.io/comtrade/reference/ct_balance.md) | Trade balance (exports minus imports) by partner |
| [`ct_top_products()`](https://charlescoverdale.github.io/comtrade/reference/ct_top_products.md) | Top N products by trade value with shares |
| [`ct_top_partners()`](https://charlescoverdale.github.io/comtrade/reference/ct_top_partners.md) | Top N trading partners by value with shares |
| [`ct_rca()`](https://charlescoverdale.github.io/comtrade/reference/ct_rca.md) | Revealed Comparative Advantage (Balassa index) |
| [`ct_hhi()`](https://charlescoverdale.github.io/comtrade/reference/ct_hhi.md) | Herfindahl-Hirschman concentration index |
| [`ct_growth()`](https://charlescoverdale.github.io/comtrade/reference/ct_growth.md) | Year-on-year and cumulative trade growth |
| [`ct_share()`](https://charlescoverdale.github.io/comtrade/reference/ct_share.md) | Country’s share of world trade |
| [`ct_compare()`](https://charlescoverdale.github.io/comtrade/reference/ct_compare.md) | Compare multiple countries’ trade |

### Utilities

| Function | Purpose |
|----|----|
| [`ct_concordance()`](https://charlescoverdale.github.io/comtrade/reference/ct_concordance.md) | Convert between HS, SITC, and BEC classifications |
| [`ct_set_key()`](https://charlescoverdale.github.io/comtrade/reference/ct_set_key.md) | Store API key |
| [`ct_cache_clear()`](https://charlescoverdale.github.io/comtrade/reference/ct_cache_clear.md) | Clear cached responses |

## Caching

Results are cached locally after the first download so repeated calls
are instant and don’t touch the API. The cache directory defaults to
`tools::R_user_dir("comtrade", "cache")` and can be overridden with
`options(comtrade.cache_dir = "/your/path")`. Cache entries expire after
24 hours for trade data and 7 days for reference tables.

## Related packages

| Package | Description |
|----|----|
| [`ons`](https://github.com/charlescoverdale/ons) | UK trade flows (goods exports and imports, current account) |
| [`readoecd`](https://github.com/charlescoverdale/readoecd) | OECD bilateral trade and trade in value added (TiVA) |
| [`hmrc`](https://github.com/charlescoverdale/hmrc) | UK customs duties and trade tax data |
| [`ato`](https://github.com/charlescoverdale/ato) | Australian Taxation Office customs and trade data |

## Data source

All data comes from the [United Nations
Comtrade](https://comtradeplus.un.org/) database via the [Comtrade Plus
API](https://comtradeapi.un.org/). This package is not affiliated with
or endorsed by the United Nations.

## Issues

Found a bug or have a feature request? Open an issue at
[github.com/charlescoverdale/comtrade/issues](https://github.com/charlescoverdale/comtrade/issues).

## Keywords

trade, international trade, comtrade, UN, bilateral, exports, imports,
HS, SITC, BEC, RCA, HHI, trade balance, gravity model, comparative
advantage

## License

MIT
