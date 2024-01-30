#' Function that validates postcodes and links to postcode dataset which
#' includes IMD, returning only the score and generated deciles and quintiles.
#'
#' @param x A data frame with a column of postcodes, or a vector
#'  of postcodes.
#' @param var String or symbol. The name of the variable in the data frame that
#'  comprises the postcodes to be submitted.
#'  Should be acceptable as a symbol or as a standard string.
#' @param fix_invalid Boolean, default `TRUE`. Whether to try to fix any
#'  postcodes that are not found (potentially because they are terminated codes,
#'  or contain typos).
#' @export
get_imd <- function(
    x,
    var = "postcode",
    fix_invalid = TRUE) {
  check_postcodes <- check_postcodes(x)

  set_params <- set_params(
    data = check_postcodes,
    type = "postcode"
  )

  get_api <- get_api(query_params = set_params)

  parse_json <- parse_json(json = get_api)

  get_data <- get_data(response_list = parse_json)

  # Join original data with postcode information to IMD

  check_postcodes |>
    dplyr::left_join(
      get_data |>
        dplyr::mutate(
          imd_decile = dplyr::case_when(
            IMD <= get_country_count() / 10 ~ 1,
            IMD <= 2 * get_country_count() / 10 ~ 2,
            IMD <= 3 * get_country_count() / 10 ~ 3,
            IMD <= 4 * get_country_count() / 10 ~ 4,
            IMD <= 5 * get_country_count() / 10 ~ 5,
            IMD <= 6 * get_country_count() / 10 ~ 6,
            IMD <= 7 * get_country_count() / 10 ~ 7,
            IMD <= 8 * get_country_count() / 10 ~ 8,
            IMD <= 9 * get_country_count() / 10 ~ 9,
            TRUE ~ 10
          ),
          imd_quintile = floor((imd_decile - 1) / 2) + 1
        ),
      dplyr::join_by(postcode == PCDS)
    ) |>
    dplyr::select(
      IMD,
      imd_decile,
      imd_quintile,
      dplyr::everything()
    )
}

#' Function that gets IMD deciles and quintiles for LSOA codes.
#'
#' @param x A data frame with a column of lsoas, or a vector
#'  of lsoas.
#' @param return data frame of all postcodes in the LSOA area as default,
#' one random from a decile or the first from a decile for example postcodes.
#'
#' @export
get_lsoa <- function(x,
                     return = c(
                       "all",
                       "random",
                       "first"
                     )) {
  return <- match.arg(return)

  set_params <- set_params(
    data = x,
    type = "lsoa"
  )

  get_api <- get_api(query_params = set_params)

  parse_json <- parse_json(json = get_api)

  get_data <- get_data(response_list = parse_json)

  data <- get_data |>
    dplyr::mutate(
      imd_decile = dplyr::case_when(
        IMD <= get_country_count() / 10 ~ 1,
        IMD <= 2 * get_country_count() / 10 ~ 2,
        IMD <= 3 * get_country_count() / 10 ~ 3,
        IMD <= 4 * get_country_count() / 10 ~ 4,
        IMD <= 5 * get_country_count() / 10 ~ 5,
        IMD <= 6 * get_country_count() / 10 ~ 6,
        IMD <= 7 * get_country_count() / 10 ~ 7,
        IMD <= 8 * get_country_count() / 10 ~ 8,
        IMD <= 9 * get_country_count() / 10 ~ 9,
        TRUE ~ 10
      ),
      imd_quintile = floor((imd_decile - 1) / 2) + 1
    )

  if (return == "all") {
    data <- data
  }

  if (return == "random") {
    data <- data |>
      dplyr::slice_sample(by = LSOA11)
  }

  if (return == "first") {
    data <- data |>
      dplyr::slice_max(by = LSOA11, order_by = PCDS)
  }

  data
}
