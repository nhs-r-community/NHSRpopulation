#' Getting data from the api_urls
#'
#' @param url_type String defaults to `postcode` which connects to
#' Online_ONS_Postcode_Directory_Live to return Postcode information and
#' `imd` connects to Indices_of_Multiple_Deprivation_(IMD)_2019 to return
#' IMD information
#'
#' @return dataset
#' @export
api_url <- function(url_type = c(
                      "postcode",
                      "imd"
                    )) {
  url_type <- match.arg(url_type)

  if (url_type == "postcode") {
    api_url <- paste0(
      "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/",
      "rest/services/Online_ONS_Postcode_Directory_Live/",
      "FeatureServer/0/query"
    )
  }

  if (url_type == "imd") {
    api_url <- paste0(
      "https://services3.arcgis.com/ivmBBrHfQfDnDf8Q/arcgis/rest/services/",
      "Indices_of_Multiple_Deprivation_(IMD)_2019/FeatureServer/0/query"
    )
  }

  req <- httr2::request(api_url) |>
    httr2::req_url_query(f = "json")

  req
}

#' Query information to restrict data returned
#'
#' @description
#' This function queries the API based on the information required and returns
#' ids as these have no restriction applied to them.
#' The IMD API restricts to 2k records for example.
#'
#' Postcode and LSOA parameters require data because bringing all the data
#' from the Online_ONS_Postcode_Directory_Live will take too long and is often
#' unnecessary.
#'
#' @param url_type String defaults to `postcode` which connects to
#' Online_ONS_Postcode_Directory_Live to return Postcode information and
#' `imd` connects to Indices_of_Multiple_Deprivation_(IMD)_2019 to return
#' IMD information
#' @param data String in "postcode" this is checked using the
#' {NHSRpostcodetools} so selects the postcode column from a data frame or can
#' handle a vector.
#' This functionality needs to be extended to "lsoa" codes which currently only
#' allow a vector.
#' "imd" brings all data back and only relates to the English IMD.
#' @param fix_invalid Boolean, default `TRUE`. Whether to try to fix any
#'  postcodes that are not found (potentially because they are terminated codes,
#'  or contain typos).
#' @param var String or symbol. The name of the variable in the data frame that
#'  comprises the postcodes to be submitted. Should be acceptable as a symbol
#'  or as a standard string.
#'
#' @return list Ids only as these are faster to batch
#' @export
#'
get_data <- function(data,
                     url_type = c(
                       "postcode",
                       "imd"
                     ),
                     fix_invalid = TRUE,
                     var = c("postcode", "lsoa11")) {
  url_type <- match.arg(url_type)
  req <- api_url(url_type)
  is_postcode_check <- sum(is_postcode(as.vector(t(data))), na.rm = TRUE)
  is_lsoa_check <- sum(is_lsoa(as.vector(t(data))), na.rm = TRUE)


  if (is.data.frame(data) & url_type == "postcode") {
    assertthat::assert_that(
      is_postcode_check > 0,
      msg = paste0("There isn't any postcode data in this data frame to",
                   "connect to the Postcode API.")
    )

    assertthat::assert_that(
      "postcode" %in% names(data),
      msg = "There isn't a column called `postcode` in this data frame."
    )
  }

  if (is.vector(data) & url_type == "postcode") {
    assertthat::assert_that(
      is_postcode_check > 0,
      msg = paste0("There isn't any postcode data in this data frame to",
                   "connect to the Postcode API.")
    )
  }

  if (is.data.frame(data) & url_type == "imd") {
    assertthat::assert_that(
      is_lsoa_check > 0,
      msg = paste0("There doesn't appear to be any data in this data frame",
                   "to connect to the IMD API.")
    )
  }

  if (is.vector(data) & url_type == "imd") {
    assertthat::assert_that(
      is_lsoa_check > 0,
      msg = paste0("There doesn't appear to be any data in this data frame",
                    "to connect to the IMD API.")
    )
  }


  # Check the data frame or vector for any postcode to then run through
  # the postcode_data_join API
  if (is_postcode_check > 0) {
    data <- NHSRpostcodetools::postcode_data_join(
      x = data,
      fix_invalid = fix_invalid
    )
  }

  if (is_postcode_check == 0) {
    data
  }

  if (is.data.frame(data) & url_type == "postcode") {
    text <- paste0(
      "PCDS IN ('",
      paste(data$new_postcode,
        collapse = "', '"
      ), "')"
    )
  }

  # if (url_type == "lsoa") {
  #   text <- paste0(
  #     "LSOA11 IN ('",
  #     paste(data$lsoa11,
  #       collapse = "', '"
  #     ), "')"
  #   )
  # }

  if (is.data.frame(data) & url_type == "imd") {
    # text <- "1=1" # get all rows (no filter) Takes a while to run
    text <- paste0(
      "LSOA11CD IN ('",
      paste(data$lsoa11,
            collapse = "', '"
      ), "')"
    )
  }

  if (rlang::is_vector(data) & url_type == "imd") {
    text <- paste0(
      "LSOA11CD IN ('",
      paste(data,
            collapse = "', '"
      ), "')"
    )
  }

  ids <- req |>
    httr2::req_url_query(returnIdsonly = TRUE) |>
    httr2::req_url_query(where = text) |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    purrr::pluck("objectIds")

  ids_batched <- NHSRpostcodetools::batch_it(ids, 100L)

  # Uses function retrieve data
  poss_retrieve_data <- purrr::possibly(retrieve_data) # safely handle any errors

  resps <- ids_batched |>
    purrr::map(\(x) poss_retrieve_data(req, x)) |>
    purrr::compact()

  # Uses function pull_table_data
  poss_pull_table_data <- purrr::possibly(pull_table_data)

  data_out <- resps |>
    purrr::map(poss_pull_table_data) |>
    purrr::list_rbind()

  # Because APIs only return data where a match has been made which results in
  # non matched data being dropped this joins back to the original.
  # Postcode information is passed through {NHSRpostcodetools} which handles
  # this but IMD is handled here.

  if (is.data.frame(data) & url_type == "imd") {
    data |>
      dplyr::left_join(data_out,
                       dplyr::join_by(lsoa11 == lsoa11cd)
      )
  } else if (rlang::is_vector(data) & url_type == "imd") {
    tibble::as_tibble(data) |>
      dplyr::left_join(data_out,
                       dplyr::join_by(value == lsoa11cd)
      )
  } else {
    data
  }
}

#' use batched IDs to retrieve table data
#'
#' @param req used in function \code{\link{get_data}}
#' @param ids_vec used in function \code{\link{get_data}}
#'
#' @return function
#' @export
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
#' @param respused in function \code{\link{get_data}}
#'
#' @return function
#' @export
pull_table_data <- function(resp) {
  resp |>
    httr2::resp_check_status() |>
    httr2::resp_body_json() |>
    purrr::pluck("features") |>
    purrr::map_df("attributes") |>
    janitor::clean_names()
}
