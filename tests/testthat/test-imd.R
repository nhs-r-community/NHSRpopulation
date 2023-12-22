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
