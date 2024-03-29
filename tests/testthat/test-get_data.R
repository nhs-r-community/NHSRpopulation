## Vectors

postcodes <- c("HD1 2UT", "HD1 2UU", "HD1 2UV")

imd <- c("E01011107", "E01011229", "E01002")

## Data frames

test_df1 <- dplyr::tibble(
  place = paste0("place_", 1:3),
  lsoa11 = c(
    "E01011107",
    "E01011229", "E01000002"
  ),
  postcode = postcodes,
)

lsoa_df1 <- dplyr::tibble(
  place = paste0("place_", 1:3),
  lsoa11 = c(
    "E01011107",
    "E01011229", "E01002"
  )
)

pcs_tb <- dplyr::tibble(
  pcs = postcodes
)

lsoa_tb <- dplyr::tibble(
  lower_soa = imd
)

# get_data() ----------------------------------------------------------------

httptest2::with_mock_dir("postcodes", {
  test_that("Returns the default and url_type = 'postcode'", {
    n_rows <- 3
    n_col_df <- 42
    n_col_vector <- 40

    testthat::expect_equal(
      nrow(get_data(test_df1)), n_rows
    )

    testthat::expect_equal(
      nrow(get_data(postcodes)), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(test_df1)), n_col_df
    )

    testthat::expect_equal(
      ncol(get_data(postcodes)), n_col_vector
    )

    testthat::expect_equal(
      nrow(get_data(test_df1, url_type = "postcode")), n_rows
    )

    testthat::expect_equal(
      nrow(get_data(postcodes, url_type = "postcode")), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(test_df1, url_type = "postcode")), n_col_df
    )

    testthat::expect_equal(
      ncol(get_data(postcodes, url_type = "postcode")), n_col_vector
    )
  })
})


httptest2::with_mock_dir("different columns - postcodes", {
  test_that("Returns data with different column names - postcodes", {
    n_rows <- 3
    n_col_df <- 40

    testthat::expect_equal(
      nrow(get_data(pcs_tb, column = "pcs")), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(pcs_tb, column = "pcs")), n_col_df
    )

    testthat::expect_equal(
      nrow(get_data(pcs_tb, url_type = "postcode", column = "pcs")),
      n_rows
    )

    testthat::expect_equal(
      ncol(get_data(pcs_tb, url_type = "postcode", column = "pcs")),
      n_col_df
    )
  })
})

# Tests for imd fail with use of {httptest2}
# Possibly because the url is expanded in the function so doesn't match
# httptest2::with_mock_dir("different columns - imd", {
test_that("Returns data with different column names - imd", {
  n_col_imd <- 66
  n_rows <- 3

  testthat::expect_equal(
    nrow(get_data(lsoa_tb,
      url_type = "imd",
      column = "lower_soa"
    )),
    n_rows
  )

  testthat::expect_equal(
    ncol(get_data(lsoa_tb,
      url_type = "imd",
      column = "lower_soa"
    )),
    n_col_imd
  )
})
# })

httptest2::with_mock_dir("imd", {
  test_that("Returns url_type = 'imd'", {
    n_rows <- 3
    n_col_vector <- 66
    n_col_df <- 67

    testthat::expect_equal(
      nrow(get_data(lsoa_df1, url_type = "imd")), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(lsoa_df1, url_type = "imd")), n_col_df
    )

    testthat::expect_equal(
      nrow(get_data(lsoa_df1)), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(lsoa_df1)), n_col_df
    )

    # vectors

    testthat::expect_equal(
      nrow(get_data(imd)), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(imd)), n_col_vector
    )

    testthat::expect_equal(
      nrow(get_data(imd, url_type = "imd")), n_rows
    )

    testthat::expect_equal(
      ncol(get_data(imd, url_type = "imd")), n_col_vector
    )
  })
})

# httptest2::with_mock_dir("imd from postcode data", {
test_that("From postcode data returns url_type = 'imd'", {
  n_rows <- 3
  n_col_vector <- 105
  n_col_df <- 107

  testthat::expect_equal(
    colnames(get_data(test_df1, url_type = "imd") |>
      dplyr::select(imd_rank)), "imd_rank"
  )

  testthat::expect_equal(
    nrow(get_data(test_df1, url_type = "imd")), n_rows
  )

  testthat::expect_equal(
    ncol(get_data(test_df1, url_type = "imd")), n_col_df
  )

  testthat::expect_equal(
    colnames(get_data(postcodes, url_type = "imd") |>
      dplyr::select(imd_rank)), "imd_rank"
  )

  testthat::expect_equal(
    nrow(get_data(postcodes, url_type = "imd")), n_rows
  )

  testthat::expect_equal(
    ncol(get_data(postcodes, url_type = "imd")), n_col_vector
  )
})
# })
