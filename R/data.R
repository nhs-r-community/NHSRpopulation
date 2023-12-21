#' Lower layer Super Output Area (LSOA) population estimates for England
#'
#' A dataset containing Lower layer Super Output Area (LSOA) population
#' estimates for England
#'
#' @format A data frame with 6325046 rows and 10 variables:
#' \describe{
#'   \item{lsoa_year}{Numeric, the year of the UK Census that the LSOA are
#'   linked to}
#'   \item{lsoa_code}{Character, Lower layer Super Output Area (LSOA) code}
#'   \item{lsoa_name}{Character, Lower layer Super Output Area (LSOA) name}
#'   \item{la_year}{Numeric, year indicating when the Local Authority (LA)
#'   boundaries were last defined/updated}
#'   \item{la_code}{Character, Local Authority (LA) code}
#'   \item{la_name}{Character, Local Authority (LA) name}
#'   \item{age}{Numeric, age groups from 0 to 90+, not that the age category 90
#'   includes estimates for the ages of 90+}
#'   \item{gender}{Character, gender (f = female; m = male)}
#'   \item{est_year}{Numeric, year of ONS estimate}
#'   \item{n}{Number of the estimated population}
#' }
#' @keywords dataset
#' @source \url{https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Online_ONS_Postcode_Directory_Live/FeatureServer/0/query?}


get_imd <- function(
    .data,
    var = "postcode",
    fix_invalid = TRUE) {

  x <- NHSRpostcodetools::postcode_data_join(.data = .data)

  where_clause <- paste0("PCDS IN ('", paste(x$new_postcode, collapse = "', '"), "')")

  # Construct the full URL with outFields including 'PCDS'
  base_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Online_ONS_Postcode_Directory_Live/FeatureServer/0/query?"
  full_url <- paste0(base_url, "where=", utils::URLencode(where_clause), "&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&relationParam=&returnGeodetic=false&outFields=IMD%2C+LSOA11%2C+LSOA21%2C+ICB%2C+PCDS&returnGeometry=true&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&defaultSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&f=pgeojson&token=")

  # Send a GET request to the API
  response <- httr::GET(full_url)

  # Parse the JSON response
  response_list <- jsonlite::fromJSON(httr::content(response, "text"))

  df <- data.frame(response_list$features$properties)

  df |>
    dplyr::left_join(x |>
                       dplyr::select(-result_type,
                                     -quality),
                     by = c("PCDS" = "new_postcode"))

}
