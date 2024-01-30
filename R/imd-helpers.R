#' Getting data from the England IMD api, overrides the minimum of 2k rows
#' returned but takes some time to retrieve all data
#'
#' @return dataset
#' @export
#'
get_imd_api <- function() {
  imd_api_url <- paste0(
    "https://services3.arcgis.com/ivmBBrHfQfDnDf8Q/arcgis/rest/services/",
    "Indices_of_Multiple_Deprivation_(IMD)_2019/FeatureServer/0/query"
  )

  req <- httr2::request(imd_api_url) |>
    httr2::req_url_query(f = "json")

  # just get IDs only from API initially (no maxRecordCount for ID queries)
  ids <- req |>
    httr2::req_url_query(returnIdsonly = TRUE) |>
    httr2::req_url_query(where = "1=1") |> # get all rows (no filter)
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("objectIds")

  ids_batched <- boundr:::batch_it(ids, 100L)

  # use batched IDs to retrieve table data
  retrieve_data <- function(req, ids_vec) {
    ids <- stringr::str_flatten(ids_vec, collapse = ",")
    req |>
      httr2::req_url_query(objectIds = ids) |>
      httr2::req_url_query(outFields = "*") |> # returns all columns
      httr2::req_url_query(returnGeometry = FALSE) |> # superfluous tbf
      httr2::req_retry(max_tries = 3) |> # shouldn't be needed
      httr2::req_perform()
  }
  poss_retrieve_data <- purrr::possibly(retrieve_data) # safely handle any errors

  resps <- ids_batched |>
    purrr::map(\(x) poss_retrieve_data(req, x)) |>
    purrr::compact()

  # pull actual data out from API JSON response
  pull_table_data <- function(resp) {
    resp |>
      httr2::resp_check_status() |>
      httr2::resp_body_json() |>
      purrr::pluck("features") |>
      purrr::map_df("attributes") |>
      janitor::clean_names()
  }
  poss_pull_table_data <- purrr::possibly(pull_table_data)

  data_out <- resps |>
    purrr::map(poss_pull_table_data) |>
    purrr::list_rbind() |>
    dplyr::rename(
      lad_cd = "la_dcd",
      lad_nm = "la_dnm"
    )
}
