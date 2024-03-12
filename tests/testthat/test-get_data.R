postcodes <- c("HD1 2UT", "HD1 2UU", "HD1 2UV")

imd <- c("E01011107", "E01011229")

test_df1 <- dplyr::tibble(
  place = paste0("place_", 1:3),
  lsoa11 = c(
    "E01011107",
    "E01011229", "E01011229"
  ),
  postcode = postcodes
)

missing_df1 <- dplyr::tibble(
  place = paste0("place_", 1:3),
  lsoa11 = c(
    "E01011107",
    "E01011229", "E01011229"
  )
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


# get_data() ----------------------------------------------------------------

httptest2::with_mock_dir("postcodes", {
  test_that("Returns the default and url_type = 'postcode'", {
    n_rows <- 3
    n_col <- 41

    testthat::expect_equal(
      nrow(get_data(test_df1)), n_rows
    )

    testthat::expect_equal(
      nrow(get_data(postcodes)), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(test_df1)), n_col
    )

    testthat::expect_equal(
      ncol(get_data(postcodes)), n_col
    )

    testthat::expect_equal(
      nrow(get_data(test_df1, url_type = "postcode")), n_rows
    )

    testthat::expect_equal(
      nrow(get_data(postcodes, url_type = "postcode")), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(test_df1, url_type = "postcode")), n_col
    )

    testthat::expect_equal(
      ncol(get_data(postcodes, url_type = "postcode")), n_col
    )
  })
})


httptest2::with_mock_dir("postcode_message", {
  test_that("Returns message there is no postcode data", {
    testthat::expect_error(
      get_data(missing_df1, "postcode"),
      "There isn't any postcode data in this data frame to connect to the Postcode API.")
  })
})

httptest2::with_mock_dir("imd", {
  test_that("Returns url_type = 'imd'", {
    n_rows <- 3
    n_col <- 66

    # [TODO] only showing what connects to
    testthat::expect_equal(
      nrow(get_data(test_df1, url_type = "imd")), n_rows
    )

    # testthat::expect_equal(
    #   nrow(get_data(imd, url_type = "imd")), n_rows
    # )

    testthat::expect_equal(
      ncol(get_data(test_df1, url_type = "imd")), n_col
    )

    # testthat::expect_equal(
    #   ncol(get_data(imd, url_type = "imd")), n_col
    # )
  })
})


testthat::test_that("Returned IMD decile", {
  testthat::expect_equal(
    get_data(test_df1, url_type = "imd") |>
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
