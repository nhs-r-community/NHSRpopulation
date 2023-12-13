#' Lower layer Super Output Area (LSOA) population estimates for England
#'
#' A dataset containing Lower layer Super Output Area (LSOA) population
#' estimates for England
#'
#' @format A data frame with 6325046 rows and 10 variables:
#' \describe{
#'   \item{lsoa_year}{Numeric, the year of the UK Census that the LSOA are
#'   linked to}
#'   \item{lsoa_code}{Character, Lower layer Super Output Area (LSOA) code}
#'   \item{lsoa_name}{Character, Lower layer Super Output Area (LSOA) name}
#'   \item{la_year}{Numeric, year indicating when the Local Authority (LA)
#'   boundaries were last defined/updated}
#'   \item{la_code}{Character, Local Authority (LA) code}
#'   \item{la_name}{Character, Local Authority (LA) name}
#'   \item{age}{Numeric, age groups from 0 to 90+, not that the age category 90
#'   includes estimates for the ages of 90+}
#'   \item{gender}{Character, gender (f = female; m = male)}
#'   \item{est_year}{Numeric, year of ONS estimate}
#'   \item{n}{Number of the estimated population}
#' }
#' @keywords dataset
#' @source \url{https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates}
"lsoa"


#' English Indices of Multiple Deprivation (IMD) for the year 2019
#'
#' A dataset containing English Indices of Multiple Deprivation (IMD) for the
#' year 2019
#'
#' @format A data frame with 32,844 rows and 9 variables:
#' \describe{
#'   \item{lsoa_year}{Numeric, the year of the UK Census that the LSOA are
#'   linked to}
#'   \item{lsoa_code}{Character, Lower layer Super Output Area (LSOA) code}
#'   \item{lsoa_name}{Character, Lower layer Super Output Area (LSOA) name}
#'   \item{la_year}{Numeric, year indicating when the Local Authority (LA)
#'   boundaries were last defined/updated}
#'   \item{la_code}{Character, Local Authority (LA) code}
#'   \item{la_name}{Character, Local Authority (LA) name}
#'   \item{imd_year}{Numeric, year of IMD score}
#'   \item{imd_score}{Numeric, Indices of Multiple Deprivation (IMD), for more
#'   information see \url{https://www.gov.uk/government/collections/english-indices-of-deprivation}}
#'   \item{imd_decile}{Ranked version of the `imd_score` with 1 representing
#'   the 'most deprived' and 10 representing the 'least deprived' areas.}
#' }
#' @keywords dataset
#' @source \url{https://www.gov.uk/government/statistics/english-indices-of-deprivation-2019}
"imd"
