#' Send a GET request to the imd API
#'
#' @return list
#' @export
#'
get_api_imd <- function() {

  base_url <- "https://services3.arcgis.com/ivmBBrHfQfDnDf8Q/arcgis/rest/services/Indices_of_Multiple_Deprivation_(IMD)_2019/FeatureServer/0/query"

  params <- list(
    where = "1=1",
    outFields = "*",
    outSR = 4326,
    f = "json",
    resultRecordCount = 4513
  )

  httr::GET(base_url, query = params)
}

#' Parse the imd JSON response
#'
#' @param json uses output from function `get_api_imd()`
#'
#' @export
#'
parse_json_imd <- function(json) {
  # Parse the JSON response
  jsonlite::fromJSON(httr::content(json, "text"))
}

