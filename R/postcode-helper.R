#' Function to check if a string is a valid postcode regardless of its
#' formatting.
#'
#' @description
#' With or without one space is permitted.
#' Does not work with data where two spaces are included with 6 character
#' postcodes.
#' From the MIT licenced package {Rbduk}
#' https://github.com/sama-ds/Rbduk/blob/main/R/is_postcode.R
#'
#' @param Postcode string
#' @return Logical
#' @export
#' @examples
#' is_postcode("SW1a2nP")
#' is_postcode("SW1a 2nP")
is_postcode <- function(Postcode) {
  return(grepl(
    paste0(
      "^[Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|",
      "(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9]",
      "[A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z]",
      ")))) {0,1}[0-9][A-Za-z]{2})$"
    ),
    Postcode
  ))
}


#' Function to check if a string is an LSOA code
#'
#' @param LSOA string
#' @return Logical
#' @export
is_lsoa <- function(LSOA) {
  return(grepl(
    paste0(
      "^[E]*[0-9]{8}$"
    ),
    LSOA
  ))
}
