#' Getting data from the IMD api
#'
#' @description
#' Only required for IMD as postcodes is routed through the {NHSRpostcodetools}
#' package
#'
#' @return dataset
#' @export
api_url <- function() {
  httr2::request(paste0(
    "https://services3.arcgis.com/ivmBBrHfQfDnDf8Q/arcgis/rest/services/",
    "Indices_of_Multiple_Deprivation_(IMD)_2019/FeatureServer/0/query"
  )) |>
    httr2::req_url_query(f = "json")
}

#' use batched IDs to retrieve table data
#'
#' @param req used in function \code{\link{imd_api}}
#' @param ids_vec used in function \code{\link{imd_api}}
#'
#' @return function
#' @noRd
retrieve_data <- function(req, ids_vec) {
  ids <- stringr::str_flatten(ids_vec, collapse = ",")
  req |>
    httr2::req_url_query(objectIds = ids) |>
    httr2::req_url_query(outFields = "*") |> # returns all columns
    httr2::req_url_query(returnGeometry = FALSE) |> # superfluous tbf
    httr2::req_retry(max_tries = 3) |> # shouldn't be needed
    httr2::req_perform()
}


#' pull actual data out from API JSON response
#'
#' @param respused in function \code{\link{imd_api}}
#'
#' @return function
#' @noRd
pull_table_data <- function(resp) {
  resp |>
    httr2::resp_check_status() |>
    httr2::resp_body_json() |>
    purrr::pluck("features") |>
    purrr::map_df("attributes") |>
    janitor::clean_names()
}

#' Get IMD data through API
#'
#' @description
#' Relies on functions \code{\link{retrieve_data}},
#' \code{\link{pull_table_data}} and \code{\link{api_url}}
#'
#' @param text String. Used in the query function and feeds in either postcodes
#' or lsoas from data in the expected API url format
#' @param req
#'
#' @return data frame
#' @noRd
imd_api <- function(text, req) {
  ids <- req |>
    httr2::req_url_query(returnIdsonly = TRUE) |>
    httr2::req_url_query(where = text) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("objectIds")

  ids_batched <- NHSRpostcodetools::batch_it(ids, 100L)

  # Uses function retrieve data
  # safely handle any errors
  poss_retrieve_data <- purrr::possibly(retrieve_data)

  resps <- ids_batched |>
    purrr::map(\(x) poss_retrieve_data(req, x)) |>
    purrr::compact()

  # Uses function pull_table_data
  poss_pull_table_data <- purrr::possibly(pull_table_data)

  data_out <- resps |>
    purrr::map(poss_pull_table_data) |>
    purrr::list_rbind()

  data_out
}
