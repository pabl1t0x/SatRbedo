test_that("Self-shadowed pixels and cast shadows are detected and removed", {
  topography <- c(
    2456.0, 2460.0, 2467.0, 2473.0, 2481.0,
    2463.0, 2468.0, 2475.0, 2482.0, 2494.0,
    2470.0, 2476.0, 2485.0, 2495.0, 2514.0,
    2479.0, 2487.0, 2500.0, 2518.0, 2543.0,
    2492.0, 2505.0, 2526.0, 2550.0, 2574.0
  ) |>
    matrix(nrow = 5, ncol = 5, byrow = TRUE) |>
    terra::rast(
      crs = "+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +type=crs",
      extent = c(482130, 482280, 5780520, 5780670)
    )
  SZA <- 49
  SAA <- 165
  with_mask <- c(
    1, 1, 1, 1, 1,
    1, 1, 1, NA, 1,
    1, 1, NA, NA, NA,
    1, 1, NA, NA, NA,
    1, 1, NA, NA, NA
  ) |>
    matrix(nrow = 5, ncol = 5, byrow = TRUE) |>
    terra::rast(
      crs = "+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +type=crs",
      extent = c(482130, 482280, 5780520, 5780670)
    )
  without_mask <- c(
    1, 1, 1, 1, 1,
    1, 1, 1, 0, 1,
    1, 1, 0, 0, 0,
    1, 1, 0, 0, 0,
    1, 1, 0, 0, 0
  ) |>
    matrix(nrow = 5, ncol = 5, byrow = TRUE) |>
    terra::rast(
      crs = "+proj=utm +zone=11 +datum=WGS84 +units=m +no_defs +type=crs",
      extent = c(482130, 482280, 5780520, 5780670)
    )
  msk <- shadow_removal(topography, SZA, SAA, mask = TRUE)
  no_msk <- shadow_removal(topography, SZA, SAA, mask = FALSE)
  expect_equal(terra::values(with_mask), terra::values(msk), tolerance = 1e-6)
  expect_equal(terra::values(without_mask), terra::values(no_msk), tolerance = 1e-6)
})
