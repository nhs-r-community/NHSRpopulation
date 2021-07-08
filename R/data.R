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
