# comtrade 0.1.1

* Fixed the `donttest` check ERROR reported for 0.1.0 on CRAN's additional
  issues page. `ct_request()` called `httr2::resp_body_json()` on any response
  that was not an HTTP error, but the Comtrade API can return 2xx with an empty
  body and no content type. Parsing then failed inside httr2 with
  `Unexpected content type "NA"`, which is neither actionable for the caller
  nor survivable in an example. The response content type is now checked before
  parsing, and both the check and the parse raise an informative error naming
  the likely cause.

* Network-dependent examples now wrap their calls in `tryCatch()` and guard on
  the result, so a rate-limited or unavailable API degrades the example
  gracefully instead of failing `R CMD check --run-donttest`.

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
