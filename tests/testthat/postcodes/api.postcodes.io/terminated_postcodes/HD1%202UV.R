structure(list(
  method = "GET", url = "https://api.postcodes.io/terminated_postcodes/HD1%202UV",
  status_code = 404L, headers = structure(list(
    Date = "Mon, 11 Mar 2024 17:26:40 GMT",
    `Content-Type` = "application/json; charset=utf-8", `Transfer-Encoding` = "chunked",
    Connection = "keep-alive", `x-gnu` = "Michael J Blanchard",
    `access-control-allow-origin` = "*", etag = "W/\"36-GttZSTwwwLlS7Lnu5NllR3pXy/E\"",
    `CF-Cache-Status` = "HIT", Age = "21", `Report-To` = "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v3?s=0eokjtIfXzmPAg2JbHXvCkNk%2FM4F14fpmiG6Q66qAiP3CzXzTANBNiH%2FwH721VsW99r%2B%2BPChzwLMJjZr%2BPnmhMQp77VGKYX6qzs1SJUkg48H%2Bts7jEDngLTx1cEkZfJlY9s%3D\"}],\"group\":\"cf-nel\",\"max_age\":604800}",
    NEL = "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}",
    Vary = "Accept-Encoding", Server = "cloudflare", `CF-RAY` = "862d4037283d60fd-LHR",
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
