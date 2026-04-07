# comtrade
[![CRAN status](https://www.r-pkg.org/badges/version/comtrade)](https://CRAN.R-project.org/package=comtrade) [![CRAN downloads](https://cranlogs.r-pkg.org/badges/comtrade)](https://CRAN.R-project.org/package=comtrade) [![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**comtrade** provides clean, tidy access to international trade data from the [United Nations Comtrade](https://comtradeplus.un.org/) database directly from R, plus built-in trade analytics (RCA, HHI, trade balance, growth rates, concordance).

## What is UN Comtrade?

The [United Nations Comtrade](https://comtradeplus.un.org/) database is the largest repository of international merchandise trade statistics in the world. Over 200 countries and territories report their annual and monthly trade data to the UN Statistics Division, which standardises, validates, and publishes it in a consistent format. The database covers goods trade from 1962 to the present and services trade from 2000, with commodity detail down to the 6-digit Harmonized System (HS) level.

Comtrade is the standard data source for bilateral trade flow analysis, gravity models, revealed comparative advantage, trade policy evaluation, and supply chain research. It underpins publications from the World Bank, WTO, UNCTAD, and most academic trade economics research.

The data is accessible via the [Comtrade Plus API](https://comtradedeveloper.un.org/), which replaced the legacy API in 2023. The free tier allows 500 API calls per day with up to 100,000 records per call. Registration is free.

## How is this different from comtradr?

There is an existing R package called [comtradr](https://cran.r-project.org/package=comtradr), maintained by Paul Bochtler through rOpenSci. It's a well-maintained package (v1.0.5, December 2025) that wraps the same Comtrade Plus API.

**What comtrade adds:**

- **Built-in trade analytics**: comtradr is a data pipe only. To compute RCA, HHI, trade balance, or growth rates, you need additional packages (economiccomplexity, concordance) or manual code. comtrade includes `ct_rca()`, `ct_hhi()`, `ct_balance()`, `ct_growth()`, `ct_share()`, and `ct_compare()` out of the box.
- **Classification concordance**: `ct_concordance()` converts between HS, SITC, and BEC classifications with a built-in lookup table. No separate package needed.
- **Fewer dependencies**: comtrade depends on 3 packages (cli, httr2, tools). comtradr depends on 14 (including lubridate, purrr, poorman, stringr, readr, fs, rappdirs, memoise, cachem, lifecycle, askpass).
- **CRAN-safe caching**: uses `tools::R_user_dir()` instead of `rappdirs`.
- **Returns data.frames**: not tibbles. Consistent with base R workflows.


## Installation

```r
# From CRAN (when available)
install.packages("comtrade")

# From GitHub
# install.packages("pak")
pak::pak("charlescoverdale/comtrade")
```

## Setup

Get a free API key at [comtradedeveloper.un.org](https://comtradedeveloper.un.org/), then:

```r
library(comtrade)
ct_set_key("your-subscription-key")
```

The key is stored for the current session. To make it permanent, add `COMTRADE_API_KEY=your-key` to your `.Renviron` file.

## Quick start

```r
# UK exports to the world, 2023
ct_trade("GBR", flow = "X", year = 2023)

# Australia's top 10 export products
ct_top_products("AUS", flow = "X", year = 2023, n = 10)

# Trade balance: US with China
ct_balance("USA", partner = "CHN", year = 2020:2023)

# Revealed comparative advantage for Germany
rca <- ct_rca("DEU", year = 2023)
rca[rca$has_advantage, ]

# Export partner concentration (HHI)
ct_hhi("AUS", flow = "X", year = 2023, by = "partner")

# Trade growth over time
ct_growth("GBR", flow = "X", years = 2018:2023)

# Compare countries in a product (HS 87: vehicles)
ct_compare(c("DEU", "JPN", "KOR"), commodity = "87", year = 2023)

# Convert HS to SITC classification
ct_concordance("27", from = "HS", to = "SITC")
```

## Functions

### Data retrieval

| Function | Purpose |
|---|---|
| `ct_trade()` | Bilateral goods trade flows (200+ countries, 1962-present) |
| `ct_services()` | Services trade via EBOPS classification (2000-present) |
| `ct_reporters()` | List available reporter countries |
| `ct_commodities()` | Search HS commodity codes |
| `ct_available()` | Check data availability for a country |

### Trade analytics

| Function | Purpose |
|---|---|
| `ct_balance()` | Trade balance (exports minus imports) by partner |
| `ct_top_products()` | Top N products by trade value with shares |
| `ct_top_partners()` | Top N trading partners by value with shares |
| `ct_rca()` | Revealed Comparative Advantage (Balassa index) |
| `ct_hhi()` | Herfindahl-Hirschman concentration index |
| `ct_growth()` | Year-on-year and cumulative trade growth |
| `ct_share()` | Country's share of world trade |
| `ct_compare()` | Compare multiple countries' trade |

### Utilities

| Function | Purpose |
|---|---|
| `ct_concordance()` | Convert between HS, SITC, and BEC classifications |
| `ct_set_key()` | Store API key |
| `ct_cache_clear()` | Clear cached responses |

## Caching

Results are cached locally after the first download so repeated calls are instant and don't touch the API. The cache directory defaults to `tools::R_user_dir("comtrade", "cache")` and can be overridden with `options(comtrade.cache_dir = "/your/path")`. Cache entries expire after 24 hours for trade data and 7 days for reference tables.

To clear the cache:

```r
ct_cache_clear()
```

## Data source

All data comes from the [United Nations Comtrade](https://comtradeplus.un.org/) database via the [Comtrade Plus API](https://comtradeapi.un.org/). This package is not affiliated with or endorsed by the United Nations.

## Related packages

Part of a suite of R packages for economic data and analysis:

| Package | Source |
|---|---|
| [ons](https://github.com/charlescoverdale/ons) | UK Office for National Statistics |
| [boe](https://github.com/charlescoverdale/boe) | Bank of England |
| [hmrc](https://github.com/charlescoverdale/hmrc) | HM Revenue and Customs |
| [obr](https://github.com/charlescoverdale/obr) | Office for Budget Responsibility |
| [fred](https://github.com/charlescoverdale/fred) | US Federal Reserve (FRED) |
| [readecb](https://github.com/charlescoverdale/readecb) | European Central Bank |
| [readoecd](https://github.com/charlescoverdale/readoecd) | OECD |
| [readnoaa](https://github.com/charlescoverdale/readnoaa) | NOAA Climate Data |
| [readaec](https://github.com/charlescoverdale/readaec) | Australian Electoral Commission |

## Issues

Found a bug or have a feature request? Open an issue at [github.com/charlescoverdale/comtrade/issues](https://github.com/charlescoverdale/comtrade/issues).

## Keywords

trade, international trade, comtrade, UN, bilateral, exports, imports, HS, SITC, BEC, RCA, HHI, trade balance, gravity model, comparative advantage

## License

MIT
