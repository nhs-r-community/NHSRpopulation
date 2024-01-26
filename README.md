
<!-- README.md is generated from README.Rmd. Please edit that file -->

# NHSRpopulation <a href='https://nhsrcommunity.com/'><img src='man/figures/logo.png' align="right" height="60" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `NHSRpopulation` is to make population estimates for **Lower
layer Super Output Areas (LSOA)** and their **Indices of Multiple
Deprivation (IMD)** easily available in R. In its first iteration this
package was data saved from
<https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019>
and has subsequently been moved to the API
<https://services1.arcgis.com/> to keep the data up to date (although it
only updated every few years) and give access to all the nations across
the UK including Wales, Scotland, Northern Ireland as well as England.

## Installation

You can install the current version of `NHSRpopulation` from
[GitHub](https://github.com/nhs-r-community/NHSRpopulation) with:

``` r
# install.packages("remotes")
remotes::install_github("nhs-r-community/NHSRpopulation")
```

To find out more about the functions there is a vignette for [Getting
Started](https://nhs-r-community.github.io/NHSRpopulation/articles/intro.html)
and for information on how to recalculate the IMD deciles for local
areas only and not with England see this
[vignette](https://nhs-r-community.github.io/NHSRpopulation/articles/calc-imd-ranks-within-la.html).

## Sources of Data

The original source of the data provided in this R package is available
from the
[ONS](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates)
and licenced under the [Open Government Licence
v3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).

## Contributing

Please see our 
[guidance on how to contribute](https://tools.nhsrcommunity.com/contribution.html).

This project is released with a Contributor [Code of Conduct](./CODE_OF_CONDUCT.md). 
By contributing to this project, you agree to abide by its terms.

The simplest way to contribute is to raise an issue detailing the feature or 
functionality you would like to see added, or any unexpected behaviour or bugs 
you have experienced.

## Special note of thanks

This package was originally created by [Milan
Wiedemann](https://github.com/milanwiedemann).
