postcodes <- c("HD1 2UT", "HD1 2UU", "HD1 2UV")

test_df1 <- dplyr::tibble(
  place = paste0("place_", 1:3),
  postcode = postcodes
)

# Taken from
# www.gov.uk/government/statistics/english-indices-of-deprivation-2019

postcodes_from_each_decile <- c(
  "E01000002",
  "E01000001",
  "E01000117",
  "E01000119",
  "E01000069",
  "E01000070",
  "E01000066",
  "E01000005",
  "E01000008",
  "E01000048"
)



# Postcode ----------------------------------------------------------------

testthat::test_that("Only one line per postcode is returned", {
  n_rows <- 3

  testthat::expect_equal(
    nrow(get_imd(test_df1)), n_rows
  )

  testthat::expect_equal(
    nrow(get_imd(postcodes)), n_rows
  )
})


testthat::test_that("Returned IMD decile is 3", {
  testthat::expect_equal(
    get_imd(test_df1) |>
      dplyr::filter(!is.na(imd_decile)) |>
      dplyr::select(imd_decile) |>
      dplyr::pull(), 3
  )

  testthat::expect_equal(
    get_imd(postcodes) |>
      dplyr::filter(!is.na(imd_decile)) |>
      dplyr::select(imd_decile) |>
      dplyr::pull(), 3
  )
})


testthat::test_that("Only one IMD score is returned because only 1 postcode
                    is valid", {
  valid_imd <- 1

  test_vector <- get_imd(postcodes)
  test_df <- get_imd(test_df1)

  testthat::expect_equal(
    sum(!is.na(test_vector$imd_decile)), valid_imd
  )

  testthat::expect_equal(
    sum(!is.na(test_df$imd_decile)), valid_imd
  )
})

testthat::test_that("No message when postcodes are valid", {
  test_vector <- "HD1 2RD"

  testthat::expect_no_message(
    get_imd(test_vector)
  )


})

# LSOA --------------------------------------------------------------------


testthat::test_that("All rows are returned as default", {
  n_rows <- 419

  testthat::expect_equal(
    nrow(get_lsoa(postcodes_from_each_decile)), n_rows
  )
})



testthat::test_that("10 rows are returned with other options", {
  n_rows <- 10

  testthat::expect_equal(
    nrow(get_lsoa(postcodes_from_each_decile,
      return = "random"
    )), n_rows
  )

  testthat::expect_equal(
    nrow(get_lsoa(postcodes_from_each_decile,
      return = "first"
    )), n_rows
  )
})

testthat::test_that("The count of IMDs is 1-10", {
  testthat::expect_equal(
    get_lsoa(postcodes_from_each_decile,
      return = "random"
    ) |>
      dplyr::select(imd_decile) |>
      dplyr::arrange(imd_decile) |>
      dplyr::pull(), c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  )

  testthat::expect_equal(
    get_lsoa(postcodes_from_each_decile,
      return = "first"
    ) |>
      dplyr::select(imd_decile) |>
      dplyr::arrange(imd_decile) |>
      dplyr::pull(), c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  )

  testthat::expect_equal(
    get_lsoa(postcodes_from_each_decile,
      return = "all"
    ) |>
      dplyr::select(imd_decile) |>
      dplyr::distinct(imd_decile) |>
      dplyr::arrange(imd_decile) |>
      dplyr::pull(), c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  )
})
