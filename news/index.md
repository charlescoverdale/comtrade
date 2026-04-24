# Changelog

## comtrade 0.1.1

- Expanded all acronyms in DESCRIPTION (HS, SITC, BEC, EBOPS, API) per
  CRAN reviewer feedback.

## comtrade 0.1.0

CRAN release: 2026-04-13

- Initial CRAN release.
- Core data retrieval:
  [`ct_trade()`](https://charlescoverdale.github.io/comtrade/reference/ct_trade.md)
  for goods,
  [`ct_services()`](https://charlescoverdale.github.io/comtrade/reference/ct_services.md)
  for services.
- Reference tables:
  [`ct_reporters()`](https://charlescoverdale.github.io/comtrade/reference/ct_reporters.md),
  [`ct_commodities()`](https://charlescoverdale.github.io/comtrade/reference/ct_commodities.md),
  [`ct_available()`](https://charlescoverdale.github.io/comtrade/reference/ct_available.md).
- Trade analytics:
  [`ct_balance()`](https://charlescoverdale.github.io/comtrade/reference/ct_balance.md),
  [`ct_top_products()`](https://charlescoverdale.github.io/comtrade/reference/ct_top_products.md),
  [`ct_top_partners()`](https://charlescoverdale.github.io/comtrade/reference/ct_top_partners.md),
  [`ct_rca()`](https://charlescoverdale.github.io/comtrade/reference/ct_rca.md),
  [`ct_hhi()`](https://charlescoverdale.github.io/comtrade/reference/ct_hhi.md),
  [`ct_growth()`](https://charlescoverdale.github.io/comtrade/reference/ct_growth.md),
  [`ct_share()`](https://charlescoverdale.github.io/comtrade/reference/ct_share.md),
  [`ct_compare()`](https://charlescoverdale.github.io/comtrade/reference/ct_compare.md).
- Classification concordance:
  [`ct_concordance()`](https://charlescoverdale.github.io/comtrade/reference/ct_concordance.md)
  with built-in HS/SITC/BEC mapping.
- Key management:
  [`ct_set_key()`](https://charlescoverdale.github.io/comtrade/reference/ct_set_key.md),
  [`ct_cache_clear()`](https://charlescoverdale.github.io/comtrade/reference/ct_cache_clear.md).
- Works without an API key (preview endpoint). Free key available for
  full access.
- 16 exported functions, 5 dependencies (cli, httr2, stats, tools,
  utils).
