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
#' @return data frame
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
  column <- rlang::as_string(column)
  value <- NULL
  lsoa11cd <- NULL
  lsoa_code <- NULL

  # Check there is corresponding type data somewhere in data frame
  # Use this to allow for other column names to be used in later code
  is_postcode_check <- sum(is_postcode(as.vector(t(data))), na.rm = TRUE)
  is_lsoa_check <- sum(is_lsoa(as.vector(t(data))), na.rm = TRUE)

  if ("postcode" %in% colnames(data)) {
    column <- "postcode"
  } else if ("lsoa11" %in% colnames(data)) {
    column <- "lsoa11"
  } else {
    column <- rlang::eval_tidy(rlang::quo(column))
  }

  # Check the data frame or vector for any postcode to then run through
  # the postcode_data_join API
  if (is.data.frame(data) && is_postcode_check > 0) {
    data_transformed <- NHSRpostcodetools::postcode_data_join(
      x = data[[column]],
      fix_invalid = fix_invalid,
      var = column
    )
  } else if (is.atomic(data) && is_postcode_check > 0) {
    data_transformed <- NHSRpostcodetools::postcode_data_join(
      x = data,
      fix_invalid = fix_invalid,
      var = column # Not required but doesn't cause error
    )
  }

  ## Generate specific text for the url

  if (is.atomic(data) && is_postcode_check == 0 &&
        is_lsoa_check > 0) {
    text <- paste0(
      "LSOA11CD IN ('",
      paste(data,
        collapse = "', '"
      ), "')"
    )
  } else if (is.data.frame(data) && is_postcode_check == 0 &&
               is_lsoa_check > 0) {
    text <- paste0(
      "LSOA11CD IN ('",
      paste(data[[column]],
        collapse = "', '"
      ), "')"
    )
  } else if (exists("data_transformed") && url_type == "imd") {
    text <- paste0(
      "LSOA11CD IN ('",
      paste(data_transformed$lsoa_code,
        collapse = "', '"
      ), "')"
    )
  }

  # Because APIs only return data where a match has been made which results in
  # non matched data being dropped this joins back to the original.
  # Postcode information is passed through {NHSRpostcodetools} which handles
  # this but IMD is handled here.

  if (exists("data_transformed") && is.data.frame(data)) {
    pc_data <- data |>
      dplyr::left_join(
        data_transformed
      )
  } else if (exists("data_transformed") && is.atomic(data)) {
    pc_data <- data_transformed
  }


  ## IMD data

  if (is_postcode_check == 0 && is_lsoa_check > 0 &&
        is.data.frame(data)) {
    data_out <- imd_api(
      text = text,
      req = req
    )

    imd_data <- data |>
      dplyr::left_join(
        data_out,
        dplyr::join_by({{ column }} == lsoa11cd)
      )
  } else if (is_postcode_check == 0 && is_lsoa_check > 0 && is.atomic(data)) {
    data_out <- imd_api(
      text = text,
      req = req
    )

    imd_data <- tibble::as_tibble(data) |>
      dplyr::left_join(
        data_out,
        dplyr::join_by(value == lsoa11cd)
      ) |>
      dplyr::rename(lsoa11 = value)
  }

  ## Final data

  if (exists("pc_data") && url_type == "imd") {
    data_out <- imd_api(
      text = text,
      req = req
    )

    pc_data |>
      dplyr::left_join(
        data_out,
        dplyr::join_by(lsoa_code == lsoa11cd)
      )
  } else if (exists("pc_data") && url_type == "postcode") {
    pc_data
  } else {
    imd_data
  }
}
