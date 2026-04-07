## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* Local macOS (Apple Silicon), R 4.4.x
* GitHub Actions: ubuntu-latest (R release, R devel), macOS-latest (R release), windows-latest (R release)

## Package description

comtrade provides access to the UN Comtrade international trade database via the Comtrade Plus API. It wraps the official API at <https://comtradeapi.un.org/> with a lightweight R interface (3 dependencies: cli, httr2, tools) and adds trade analytics (RCA, HHI, trade balance, growth) that would otherwise require multiple separate packages.

A free API key is required (available at <https://comtradedeveloper.un.org/>). All examples use \donttest{} and redirect cache to tempdir().

## First submission

This is a new package.
