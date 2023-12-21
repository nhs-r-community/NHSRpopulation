postcodes <- c("HD1 2UT", "HD1 2UU", "HD1 2UV")

test_df1 <- dplyr::tibble(
  place = paste0("place_", 1:3),
  postcode = postcodes
)

testthat::test_that("Only one line per postcode is returned", {
  n_rows <- 3

  testthat::expect_equal(
    nrow(test_df1), n_rows
  )

  testthat::expect_equal(
    length(postcodes), n_rows
  )
})
