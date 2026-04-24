# Clear the Comtrade Cache

Remove all cached Comtrade API responses from the local cache directory.

## Usage

``` r
ct_cache_clear()
```

## Value

Invisibly returns `TRUE` if the cache was cleared, `FALSE` if no cache
directory existed.

## Examples

``` r
# \donttest{
op <- options(comtrade.cache_dir = tempdir())
ct_cache_clear()
#> Cleared 2 cached files.
options(op)
# }
```
