req_base <- function(x = "") {
  ua <- "github.com/nhs-r-community/NHSRpopulation // httr2"

  # Construct the full URL with outFields including 'PCDS'
  base_url <- "https://services1.arcgis.com/ESMARspQHYMw9BZ9/ArcGIS/rest/services/Online_ONS_Postcode_Directory_Live/FeatureServer/0/query?"
  paste0(base_url,
                     "where=",
                     URLencode(paste0("PCDS IN ('", paste(x, collapse = "', '"), "')")),
                     "&objectIds=&time=&geometry=&geometryType=esriGeometryEnvelope&inSR=&spatialRel=esriSpatialRelIntersects&resultType=none&distance=0.0&units=esriSRUnit_Meter&relationParam=&returnGeodetic=false&outFields=IMD%2C+LSOA11%2C+LSOA21%2C+ICB%2C+PCDS&returnGeometry=true&featureEncoding=esriDefault&multipatchOption=xyFootprint&maxAllowableOffset=&geometryPrecision=&outSR=&defaultSR=&datumTransformation=&applyVCSProjection=false&returnIdsOnly=false&returnUniqueIdsOnly=false&returnCountOnly=false&returnExtentOnly=false&returnQueryGeometry=false&returnDistinctValues=false&cacheHint=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&having=&resultOffset=&resultRecordCount=&returnZ=false&returnM=false&returnExceededLimitFeatures=true&quantizationParameters=&sqlFormat=none&f=pgeojson&token=") |>
    httr2::request() |>
    httr2::req_user_agent(ua)
}



