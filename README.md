
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LSOApop

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `LSOApop` is to make population estimates for **Lower layer
Super Output Areas (LSOA)** and their **Indecies of Multiple Deprivation
(IMD)** easily available in R. Population estimates are broken down by
age (0 to 90+) and gender (female/male). A transparent description of
the data processing and information about the original sources are
available in this GitHub, see `"data-raw/imd.R` and `"data-raw/lsoa.R`.
The current version of the package only includes LSOA population
estimates and IMD scores from the year 2019.

## Installation

You can install the current version of `LSOApop` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("nhs-r-community/LSOApop")
```

## Example

``` r
# Load the package
library(LSOApop)
```

### Lower layer Super Output Areas (LSOA)

The LSOA population estimates are available in the dataset `lsoa`:

``` r
# Show the first 6 rows of the dataset
# For further information about this dataset see the help file: help(lsoa)
head(lsoa)
#>   lsoa_code year age gender  n
#> 1 E01011949 2019   0      f 12
#> 2 E01011949 2019   1      f 11
#> 3 E01011949 2019   2      f  5
#> 4 E01011949 2019   3      f 13
#> 5 E01011949 2019   4      f 13
#> 6 E01011949 2019   5      f 11
```

### Indecies of Multiple Deprivation (IMD)

The IMD scores (raw scores and ranked deciles) and available in the
dataset `imd`:

``` r
# Show the first 6 rows of the dataset
# For further information about this dataset see the help file: help(imd)
head(imd)
#>   lsoa_code year imd_score imd_decile
#> 1 E01000001 2019     6.208          9
#> 2 E01000002 2019     5.143         10
#> 3 E01000003 2019    19.402          5
#> 4 E01000005 2019    28.652          3
#> 5 E01000006 2019    19.837          5
#> 6 E01000007 2019    31.576          3
```

## Sources of Data

The original source of the data provided in this R package is available
[here](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates)
and licenced under the [Open Government Licence
v3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).

## Code of Conduct

Please note that the `LSOApop` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
