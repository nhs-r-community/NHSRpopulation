#' Lower layer Super Output Area (LSOA) population estimates for England
#'
#' A dataset containing Lower layer Super Output Area (LSOA) population estimates for England
#'
#' @format A data frame with 6325046 rows and 5 variables:
#' \describe{
#'   \item{lsoa_code}{Character, Lower layer Super Output Area (LSOA) code}
#'   \item{year}{Numeric, year of estimate}
#'   \item{age}{Numeric, age groups from 0 to 90+, not that the age category 90 includes estimates for the ages of 90+}
#'   \item{gender}{Character, gender (f = female; m = male)}
#'   \item{n}{Number of the estimated population}
#' }
#' @source \url{https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates}
"lsoa"


#' English Indices of Multiple Deprivation (IMD) for the year 2019
#'
#' A dataset containing English Indices of Multiple Deprivation (IMD) for the year 2019
#'
#' @format A data frame with 32,844 rows and 4 variables:
#' \describe{
#'   \item{lsoa_code}{Character, Lower layer Super Output Area (LSOA) code}
#'   \item{year}{Numeric, year of IMD score}
#'   \item{imd_score}{Numeric, Indices of Multiple Deprivation (IMD), for more information see \url{https://www.gov.uk/government/collections/english-indices-of-deprivation}}
#'   \item{imd_decile}{Ranked version of the `imd_score` with 1 representing tbe 'least deprived' and 10 representing the 'least deprived' areas.}
#' }
#' @source \url{https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019}
"imd"
