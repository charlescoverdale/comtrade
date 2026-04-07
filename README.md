# comtrade

Access and analyse UN Comtrade international trade data from R.

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

## Data source

All data comes from the [United Nations Comtrade](https://comtradeplus.un.org/) database via the Comtrade Plus API. The free tier allows 500 API calls per day with up to 100,000 records per call.

## Related packages

Part of a suite of R packages for economic data and analysis:

- [ons](https://github.com/charlescoverdale/ons): UK Office for National Statistics
- [boe](https://github.com/charlescoverdale/boe): Bank of England
- [fred](https://github.com/charlescoverdale/fred): US Federal Reserve (FRED)
- [readecb](https://github.com/charlescoverdale/readecb): European Central Bank
- [readoecd](https://github.com/charlescoverdale/readoecd): OECD

## License

MIT
