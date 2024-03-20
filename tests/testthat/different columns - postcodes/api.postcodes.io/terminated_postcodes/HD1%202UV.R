structure(list(
  method = "GET", url = "https://api.postcodes.io/terminated_postcodes/HD1%202UV",
  status_code = 404L, headers = structure(list(
    Date = "Sat, 16 Mar 2024 08:02:58 GMT",
    `Content-Type` = "application/json; charset=utf-8", `Transfer-Encoding` = "chunked",
    Connection = "keep-alive", `x-gnu` = "Michael J Blanchard",
    `access-control-allow-origin` = "*", etag = "W/\"36-GttZSTwwwLlS7Lnu5NllR3pXy/E\"",
    `CF-Cache-Status` = "HIT", Age = "398818", `Report-To` = "{\"endpoints\":[{\"url\":\"https:\\/\\/a.nel.cloudflare.com\\/report\\/v4?s=eHOv0N2rtjD5YkO7OPwfuCBO9UPKcbPjTtkx5Nk41LA6xx7cAEItBoocVwxHH17%2BUszmjOyb5iso5CO2UYTQ9Z437DqcTjnXmD9sE07lZKdVW6RA0DvlkGrkewf8ELTxVEI%3D\"}],\"group\":\"cf-nel\",\"max_age\":604800}",
    NEL = "{\"success_fraction\":0,\"report_to\":\"cf-nel\",\"max_age\":604800}",
    Vary = "Accept-Encoding", Server = "cloudflare", `CF-RAY` = "86533958fd67dd3b-LHR",
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
