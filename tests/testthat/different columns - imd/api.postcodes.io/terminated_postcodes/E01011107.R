structure(list(
  method = "GET", url = "https://api.postcodes.io/terminated_postcodes/E01011107",
  status_code = 404L, headers = structure(list(
    Date = "Tue, 19 Mar 2024 15:17:36 GMT",
    `Content-Type` = "application/json; charset=utf-8", `Content-Length` = "41",
    Connection = "keep-alive", `x-gnu` = "Michael J Blanchard",
    `access-control-allow-origin` = "*", etag = "W/\"29-T14TWaKfjMuMFPoRgcsDj2g1ORs\"",
    `CF-Cache-Status` = "HIT", Age = "12143", `Report-To` = "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v4?s=%2FI%2BTV5AD2bhZqlw8AXaPSbHNCMZR89iUg03uUSFFZEhRALDJFqXfgtf1ehiOjJspCon2zT3WEkuKPPCyNa2YE6faRM7PvDDwwW3sJHKommEY0izDhNRoA6nV2zy46ucyY78%3D\"}],\"group\":\"cf-nel\",\"max_age\":604800}",
    NEL = "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}",
    Vary = "Accept-Encoding", Server = "cloudflare", `CF-RAY` = "866e6e29bdb4dc29-LHR"
  ), class = "httr2_headers"),
  body = charToRaw("{\"status\":404,\"error\":\"Invalid postcode\"}"),
  request = structure(list(
    url = "https://api.postcodes.io/terminated_postcodes/E01011107",
    method = NULL, headers = list(), body = NULL, fields = list(),
    options = list(useragent = "github.com/nhs-r-community/NHSRpopulation // httr2"),
    policies = list()
  ), class = "httr2_request"), cache = new.env(parent = emptyenv())
), class = "httr2_response")
