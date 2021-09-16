
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LSOApop <a href='https://nhsrcommunity.com/'><img src='man/figures/logo.png' align="right" height="60" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `LSOApop` is to make population estimates for **Lower layer
Super Output Areas (LSOA)** and their **Indices of Multiple Deprivation
(IMD)** easily available in R. Population estimates are broken down by
age (0 to 90+) and gender (female/male). Information about the original
sources of the data and a transparent description of all transformation
of the data that is made available in this package can be found in this
repository, see `"data-raw/imd.R` and `"data-raw/lsoa.R`. Main changes
to the original data structures include (1) the transformation from wide
to long data, (2) the addition of further information that was only
available in variable names, and (3) renaming variables in a consistent
way.

The current version of this package only includes LSOA population
estimates and IMD scores for the year 2019 for England. Because we store
quite a lot in this package it currently relatively large (\~9mb)
compared to other packages.

## Installation

You can install the current version of `LSOApop` from
[GitHub](https://github.com/nhs-r-community/LSOApop) with:

``` r
# install.packages("remotes")
remotes::install_github("nhs-r-community/LSOApop")
```

## Example

``` r
# Load the package
library(LSOApop)
#> 
#> -- This is LSOApop 0.0.2 -------------------------------------------------------
#> i Please report any issues or ideas at:
#> i https://github.com/nhs-r-community/LSOApop/issues
```

### Lower layer Super Output Areas (LSOA)

The LSOA population estimates are available in the dataset `lsoa`:

``` r
# Show the first 6 rows of the dataset
# For further information about this dataset see the help file: help(lsoa)
head(lsoa)
#>   lsoa_year lsoa_code           lsoa_name la_year   la_code        la_name age
#> 1      2019 E01000001 City of London 001A    2019 E09000001 City of London   0
#> 2      2019 E01000001 City of London 001A    2019 E09000001 City of London   1
#> 3      2019 E01000001 City of London 001A    2019 E09000001 City of London   2
#> 4      2019 E01000001 City of London 001A    2019 E09000001 City of London   3
#> 5      2019 E01000001 City of London 001A    2019 E09000001 City of London   4
#> 6      2019 E01000001 City of London 001A    2019 E09000001 City of London   5
#>   gender est_year  n
#> 1      f     2019  2
#> 2      f     2019  9
#> 3      f     2019  4
#> 4      f     2019 12
#> 5      f     2019 11
#> 6      f     2019  5
```

### Indices of Multiple Deprivation (IMD)

The IMD scores (raw scores and ranked deciles) and available in the
dataset `imd`:

``` r
# Show the first 6 rows of the dataset
# For further information about this dataset see the help file: help(imd)
head(imd)
#>   lsoa_year lsoa_code                 lsoa_name la_year   la_code
#> 1      2011 E01000001       City of London 001A    2019 E09000001
#> 2      2011 E01000002       City of London 001B    2019 E09000001
#> 3      2011 E01000003       City of London 001C    2019 E09000001
#> 4      2011 E01000005       City of London 001E    2019 E09000001
#> 5      2011 E01000006 Barking and Dagenham 016A    2019 E09000002
#> 6      2011 E01000007 Barking and Dagenham 015A    2019 E09000002
#>                la_name imd_year imd_score imd_decile
#> 1       City of London     2019     6.208          9
#> 2       City of London     2019     5.143         10
#> 3       City of London     2019    19.402          5
#> 4       City of London     2019    28.652          3
#> 5 Barking and Dagenham     2019    19.837          5
#> 6 Barking and Dagenham     2019    31.576          3
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

## Special note of thanks

This package was originally created by [Milan
Wiedemann](https://github.com/milanwiedemann).
