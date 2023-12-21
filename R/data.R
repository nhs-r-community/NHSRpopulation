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
#' @source \url{https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Online_ONS_Postcode_Directory_Live/FeatureServer/0/query?}


get_imd <- function(
    .data,
    var = "postcode",
    fix_invalid = TRUE) {

  # use {NHSRpostcodetools} to validate postcodes
  x <- NHSRpostcodetools::postcode_data_join(.data = .data)

  # Connect to ONS Postcode Directory
  base_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Online_ONS_Postcode_Directory_Live/FeatureServer/0/query"

  query_params <- list(
    where = paste0("PCDS IN ('", paste(x$new_postcode, collapse = "', '"), "')"),
    outFields = "IMD,LSOA11,LSOA21,ICB,PCDS",
    returnCountOnly = FALSE,
    f = "json"
  )

  # Send a GET request to the API
  response <- httr::GET(base_url, query = query_params)

  # Parse the JSON response
  response_list <- jsonlite::fromJSON(httr::content(response, "text"))

  df <- data.frame(response_list$features$attributes)

  df |>
    dplyr::left_join(x |>
                       dplyr::select(-result_type,
                                     -quality),
                     by = c("PCDS" = "new_postcode"))

}
