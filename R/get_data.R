#' Getting data from the IMD api
#'
#' @description
#' Only required for IMD as postcodes is routed through the {NHSRpostcodetools}
#' package
#'
#' @return dataset
#' @export
api_url <- function() {
  req <- httr2::request(paste0(
    "https://services3.arcgis.com/ivmBBrHfQfDnDf8Q/arcgis/rest/services/",
    "Indices_of_Multiple_Deprivation_(IMD)_2019/FeatureServer/0/query"
  )) |>
    httr2::req_url_query(f = "json")
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
#' @param url_type String defaults to `postcode` which returns information from
#' Online_ONS_Postcode_Directory_Live to return Postcode information via the
#' {NHSRpostcodetools} package. `imd` connects to
#' Indices_of_Multiple_Deprivation_(IMD)_2019 to return IMD information.
#' @param data dataframe or vector.The data that will connect to either the
#' postcode API or imd API.
#' @param fix_invalid Boolean, default `TRUE`. Whether to try to fix any
#'  postcodes that are not found (potentially because they are terminated codes,
#'  or contain typos).
#' @param column String. Default would mean the automatic connection of a
#' column called `postcode` if postcode data is being expected or `lsoa11` if
#' imd data as requested via the parameter `url_type = "imd"`.
#'
#' @return
#' @export
#'
get_data <- function(data,
                     url_type = c(
                       "postcode",
                       "imd"
                     ),
                     fix_invalid = TRUE,
                     column = "default") {
  url_type <- match.arg(url_type)
  req <- api_url()

  is_postcode_check <- sum(is_postcode(as.vector(t(data))), na.rm = TRUE)
  is_lsoa_check <- sum(is_lsoa(as.vector(t(data))), na.rm = TRUE)
  column <- rlang::as_string(column)

  if (column == "default" & url_type == "imd") {
    # Extract lsoa codes before the data is connected to the postcodes API
    # via {NHSRpostcodetools}
    column <- "lsoa11"
  }

  if (column != "default") {
    column
  }

  if (is.data.frame(data) & url_type == "postcode") {
    assertthat::assert_that(
      is_postcode_check > 0,
      msg = paste(
        "There isn't any postcode data in this data frame to",
        "connect to the Postcode API."
      )
    )
    assertthat::assert_that(
      "postcode" %in% names(data),
      msg = "There isn't a column called `postcode` in this data frame."
    )
  }

  if (is.vector(data) & url_type == "postcode") {
    assertthat::assert_that(
      is_postcode_check > 0,
      msg = paste(
        "There isn't any postcode data in this data frame to",
        "connect to the Postcode API."
      )
    )
  }

  if (is.data.frame(data) & url_type == "imd") {
    assertthat::assert_that(
      is_lsoa_check > 0,
      msg = paste(
        "There doesn't appear to be any data in this data frame",
        "to connect to the IMD API."
      )
    )
    assertthat::assert_that(
      "lsoa11" %in% names(data),
      msg = "There isn't a column called `lsoa11` in this data frame."
    )
  }

  if (is.vector(data) & url_type == "imd") {
    assertthat::assert_that(
      is_lsoa_check > 0,
      msg = paste(
        "There doesn't appear to be any data in this data frame",
        "to connect to the IMD API."
      )
    )
  }


  # Check the data frame or vector for any postcode to then run through
  # the postcode_data_join API
  if (is_postcode_check > 0) {
    data_transformed <- NHSRpostcodetools::postcode_data_join(
      x = data,
      fix_invalid = fix_invalid
    )
  }

  if (is.data.frame(data) & url_type == "postcode") {
    text <- paste0(
      "PCDS IN ('",
      paste(data_transformed$new_postcode,
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


  if (rlang::is_vector(data) & url_type == "imd") {
    text <- paste0(
      "LSOA11CD IN ('",
      paste(data,
        collapse = "', '"
      ), "')"
    )
  }

  if (is.data.frame(data) & url_type == "imd") {
    # text <- "1=1" # get all rows (no filter) Takes a while to run

    text <- paste0(
      "LSOA11CD IN ('",
      paste(data[[column]],
        collapse = "', '"
      ), "')"
    )
  }

  if (url_type == "imd") {
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
  }

  # Because APIs only return data where a match has been made which results in
  # non matched data being dropped this joins back to the original.
  # Postcode information is passed through {NHSRpostcodetools} which handles
  # this but IMD is handled here.

  if (is.data.frame(data) & url_type == "imd") {
    data |>
      dplyr::left_join(
        data_out,
        dplyr::join_by({{ column }} == lsoa11cd)
      )
  } else if (rlang::is_vector(data) & url_type == "imd") {
    tibble::as_tibble(data) |>
      dplyr::left_join(
        data_out,
        dplyr::join_by(value == lsoa11cd)
      ) |>
      dplyr::rename(lsoa11 = value)
  } else {
    data_transformed
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
