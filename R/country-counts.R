#' Get the country count
#'
#' @description
#' relies on function `set_country_params` that needs to be split out to
#' different nations
#'
#'
#' @return vector
#' @export
#'
get_country_count <- function() {
  # Get country count

  get_api_c <- get_api(query_params = set_country_params())

  parse_json_c <- parse_json(json = get_api_c)

  get_count(response_list = parse_json_c)
}
