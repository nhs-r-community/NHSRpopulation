#' Function that validates postcodes and links to IMD datasets, returning the
#' score and generated deciles and quintiles.
#'
#' @param .data A data frame with a column of postcodes, or a vector
#'  of postcodes.
#' @param var String or symbol. The name of the variable in the data frame that
#'  comprises the postcodes to be submitted.
#'  Should be acceptable as a symbol or as a standard string.
#' @param fix_invalid Boolean, default `TRUE`. Whether to try to fix any
#'  postcodes that are not found (potentially because they are terminated codes,
#'  or contain typos).
#' @param country select which country in the nations the IMD scores relate to.
#' Note that datasets cannot be mixed. Deciles are generated from
#' the data provided from the API and so are based on the totals.
#'
#' @examples
#' postcodes <- c("HD1 2UT", "HD1 2UU", "HD1 2UV")
#' test_df1 <- dplyr::tibble(
#'   place = paste0("place_", 1:3),
#'   postcode = postcodes
#' )
#' postcode_data_join(test_df1, fix_invalid = TRUE)
#' @export
get_imd <- function(
    .data,
    var = "postcode",
    fix_invalid = TRUE) {
  # use {NHSRpostcodetools} to validate postcodes
  pc_checked <- NHSRpostcodetools::postcode_data_join(.data = .data)

  # Connect to ONS Postcode Directory
  base_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Online_ONS_Postcode_Directory_Live/FeatureServer/0/query"

  query_params <- list(
    where = paste0("PCDS IN ('", paste(pc_checked$new_postcode, collapse = "', '"), "')"),
    outFields = "IMD,LSOA11,LSOA21,ICB,PCDS",
    returnCountOnly = FALSE,
    returnDistinctValues = TRUE,
    f = "json"
  )

  # Send a GET request to the API
  response <- httr::GET(base_url, query = query_params)

  # Parse the JSON response
  response_list <- jsonlite::fromJSON(httr::content(response, "text"))

  df <- data.frame(response_list$features$attributes)

  # Country totals
  # if(country == "england") {

  country_params <- list(
    where = "LSOA11 LIKE 'E%'",
    outFields = "LSOA11",
    returnCountOnly = TRUE,
    returnDistinctValues = TRUE,
    f = "json"
  )
  # }

  # Send a GET request to the API
  country_response <- httr::GET(base_url, query = country_params)

  # Parse the JSON response
  country_list <- jsonlite::fromJSON(httr::content(country_response, "text"))

  total <- data.frame(country_list)



  # Join original data with postcode information to IMD

  # [TODO] link postcode correction to imd output

  pc_checked |>
    dplyr::left_join(
      df |>
        dplyr::mutate(imd_decile = dplyr::case_when(
          IMD <= country_list$count / 10 ~ 1,
          IMD <= 2 * country_list$count / 10 ~ 2,
          IMD <= 3 * country_list$count / 10 ~ 3,
          IMD <= 4 * country_list$count / 10 ~ 4,
          IMD <= 5 * country_list$count / 10 ~ 5,
          IMD <= 6 * country_list$count / 10 ~ 6,
          IMD <= 7 * country_list$count / 10 ~ 7,
          IMD <= 8 * country_list$count / 10 ~ 8,
          IMD <= 9 * country_list$count / 10 ~ 9,
          TRUE ~ 10
        )),
      dplyr::join_by(postcode == PCDS)
    ) |>
    dplyr::select(
      IMD,
      imd_decile,
      dplyr::everything()
    )
}
