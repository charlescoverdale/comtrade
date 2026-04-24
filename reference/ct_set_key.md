# Set the Comtrade API Key

Store your UN Comtrade API key for the current session. The key is saved
as an R option and optionally as an environment variable for
persistence.

## Usage

``` r
ct_set_key(key, install = FALSE)
```

## Arguments

- key:

  Character. Your Comtrade API subscription key.

- install:

  Logical. If `TRUE`, also sets the `COMTRADE_API_KEY` environment
  variable via [`Sys.setenv()`](https://rdrr.io/r/base/Sys.setenv.html),
  which persists for the current R session. For permanent storage, add
  `COMTRADE_API_KEY=your-key` to your `.Renviron` file. Default `FALSE`.

## Value

Invisibly returns the key.

## Details

Get a free API key at <https://comtradedeveloper.un.org/>. The free tier
allows 500 calls per day and up to 100,000 records per call.

## Examples

``` r
# \donttest{
ct_set_key("your-subscription-key-here")
#> Comtrade API key set for this session.
# }
```
