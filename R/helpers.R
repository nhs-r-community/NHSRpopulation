#' Use {NHSRpostcodetools} to validate postcodes
#'
#' @param data dataframe or vector
#'
#' @return data frame with data from the original along with postcode
#' information
#' @export
check_postcodes <- function(data) {
  NHSRpostcodetools::postcode_data_join(x = data)
}

#' Connect to services1.arcgis API for data
#'
#' @param data data frame output from {NHSRpostcodetools}
#' @param type select which parameters to change
#'
#' @return list of parameters required, currently PCDS
#' @export
#'
set_params <- function(data,
                       type = c(
                         "postcode",
                         "lsoa"
                       )) {
  return <- match.arg(type)

  if (type == "postcode") {
    text <- paste0(
      "PCDS IN ('",
      paste(data$new_postcode,
        collapse = "', '"
      ), "')"
    )
  }

  if (type == "lsoa") {
    text <- paste0(
      "LSOA11 IN ('",
      paste(data,
        collapse = "', '"
      ), "')"
    )
  }

  list(
    where = text,
    outFields = "IMD,LSOA11,LSOA21,ICB,PCDS",
    returnCountOnly = FALSE,
    returnDistinctValues = TRUE,
    f = "json"
  )
}

#' Country parameters to return the total number of LSOAs
#'
#' @description
#' Deciles and Quintiles are not available from source and need to be #
#' calculated from the total number of LSOAs for the nation.
#'
#' TODO expand to nations depending on starting letter of LSOA
#' England = E
#' Wales = W
#' Scotland = S
#' Northern Ireland = (9
#'
#' https://statistics.ukdataservice.ac.uk/dataset/2011-census-geography-boundaries-lower-layer-super-output-areas-and-data-zones
#'
#'
#' @return list of parameters required, currently England only
#' @export
#'
set_country_params <- function() {
  list(
    where = "LSOA11 LIKE 'E%'",
    outFields = "LSOA11",
    returnCountOnly = TRUE,
    returnDistinctValues = TRUE,
    f = "json"
  )
}

#' Return the vector of country count of LSOAs
#'
#' @param response_list
#'
#' @return vector
#' @export
#'
get_count <- function(response_list) {
  data.frame(response_list) |> dplyr::pull()
}


#' Send a GET request to the API
#'
#' @param query_params uses the output from the function `set_country_params()`
#'
#' @return list
#' @export
#'
get_api <- function(query_params) {
  base_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Online_ONS_Postcode_Directory_Live/FeatureServer/0/query"

  httr::GET(base_url, query = query_params)
}

#' Parse the JSON response
#'
#' @param json uses output from function `get_api()`
#'
#' @export
#'
parse_json <- function(json) {
  # Parse the JSON response
  jsonlite::fromJSON(httr::content(json, "text"))
}

#' Create a data frame
#'
#' @param response_list uses output from the function `parse_json()`
#'
#' @return data frame
#' @export
#'
get_data <- function(response_list) {
  data.frame(response_list$features$attributes)
}
