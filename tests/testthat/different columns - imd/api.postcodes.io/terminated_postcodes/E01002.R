structure(list(
  method = "GET", url = "https://api.postcodes.io/terminated_postcodes/E01002",
  status_code = 404L, headers = structure(list(
    Date = "Tue, 19 Mar 2024 15:17:39 GMT",
    `Content-Type` = "application/json; charset=utf-8", `Content-Length` = "41",
    Connection = "keep-alive", `x-gnu` = "Michael J Blanchard",
    `access-control-allow-origin` = "*", etag = "W/\"29-T14TWaKfjMuMFPoRgcsDj2g1ORs\"",
    `CF-Cache-Status` = "HIT", Age = "12146", `Report-To` = "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v4?s=JvElpZVTLBaNzg9lQAYggkNR6tZi1S6YHWz2tBb712wWkJ7wl9OSr0fna2w18hdPUypn7rd50jKColyj3QSo7qEmV96lOKt1yqhStZ%2BXZFANZWd5mGWND8j0fM6ZjI9TMRc%3D\"}],\"group\":\"cf-nel\",\"max_age\":604800}",
    NEL = "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}",
    Vary = "Accept-Encoding", Server = "cloudflare", `CF-RAY` = "866e6e3c8c0cdc29-LHR"
  ), class = "httr2_headers"),
  body = charToRaw("{\"status\":404,\"error\":\"Invalid postcode\"}"),
  request = structure(list(
    url = "https://api.postcodes.io/terminated_postcodes/E01002",
    method = NULL, headers = list(), body = NULL, fields = list(),
    options = list(useragent = "github.com/nhs-r-community/NHSRpopulation // httr2"),
    policies = list()
  ), class = "httr2_request"), cache = new.env(parent = emptyenv())
), class = "httr2_response")
