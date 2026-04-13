# comtrade 0.1.1

* Expanded all acronyms in DESCRIPTION (HS, SITC, BEC, EBOPS, API) per CRAN reviewer feedback.

# comtrade 0.1.0

* Initial CRAN release.
* Core data retrieval: `ct_trade()` for goods, `ct_services()` for services.
* Reference tables: `ct_reporters()`, `ct_commodities()`, `ct_available()`.
* Trade analytics: `ct_balance()`, `ct_top_products()`, `ct_top_partners()`, `ct_rca()`, `ct_hhi()`, `ct_growth()`, `ct_share()`, `ct_compare()`.
* Classification concordance: `ct_concordance()` with built-in HS/SITC/BEC mapping.
* Key management: `ct_set_key()`, `ct_cache_clear()`.
* Works without an API key (preview endpoint). Free key available for full access.
* 16 exported functions, 5 dependencies (cli, httr2, stats, tools, utils).
