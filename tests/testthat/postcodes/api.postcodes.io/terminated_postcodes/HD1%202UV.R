structure(list(
  method = "GET", url = "https://api.postcodes.io/terminated_postcodes/HD1%202UV",
  status_code = 404L, headers = structure(list(
    Date = "Fri, 15 Mar 2024 18:33:06 GMT",
    `Content-Type` = "application/json; charset=utf-8", `Transfer-Encoding` = "chunked",
    Connection = "keep-alive", `x-gnu` = "Michael J Blanchard",
    `access-control-allow-origin` = "*", etag = "W/\"36-GttZSTwwwLlS7Lnu5NllR3pXy/E\"",
    `CF-Cache-Status` = "HIT", Age = "174428", `Report-To` = "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v4?s=f0zCBaPHKLICjE8DTMw8VKWl8A%2FMkqJavhniBEfjxPBdSiHjUlGglQUWex2gpke33QY6JbwZB9OKplr5iPB1Nf62ouxourS1udPkBJtfwLV8CGB2CLR%2FA3gqfm0MrIJ6Brk%3D\"}],\"group\":\"cf-nel\",\"max_age\":604800}",
    NEL = "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}",
    Vary = "Accept-Encoding", Server = "cloudflare", `CF-RAY` = "864e97061a5b23d8-LHR",
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
