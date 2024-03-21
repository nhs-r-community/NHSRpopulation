structure(list(
  method = "GET", url = "https://api.postcodes.io/terminated_postcodes/HD1%202UV",
  status_code = 404L, headers = structure(list(
    Date = "Thu, 21 Mar 2024 15:07:27 GMT",
    `Content-Type` = "application/json; charset=utf-8", `Transfer-Encoding` = "chunked",
    Connection = "keep-alive", `x-gnu` = "Michael J Blanchard",
    `access-control-allow-origin` = "*", etag = "W/\"36-GttZSTwwwLlS7Lnu5NllR3pXy/E\"",
    `CF-Cache-Status` = "HIT", Age = "1896", `Report-To` = "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v4?s=qs6JZFWhvz%2BNFgTy3pxPlruFzeMh%2B1CvhW1Wjiv9En6ZFcBYmhOti6WKVGFc4RyjMkU9eDsWi6QG%2BuXceiUsr79V6ab2nEbQzlhl97E%2BwWB2gWGs6bmnutcp8%2FZOwq9F13o%3D\"}],\"group\":\"cf-nel\",\"max_age\":604800}",
    NEL = "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}",
    Vary = "Accept-Encoding", Server = "cloudflare", `CF-RAY` = "867eda0a9c9c4140-LHR",
    `Content-Encoding` = "gzip"
  ), class = "httr2_headers"),
  body = charToRaw("{\"status\":404,\"error\":\"Terminated postcode not found\"}"),
  request = structure(list(
    url = "https://api.postcodes.io/terminated_postcodes/HD1%202UV",
    method = NULL, headers = list(), body = NULL, fields = list(),
    options = list(useragent = "github.com/nhs-r-community/NHSRpopulation // httr2"),
    policies = list()
  ), class = "httr2_request"), cache = new.env(parent = emptyenv())
), class = "httr2_response")
