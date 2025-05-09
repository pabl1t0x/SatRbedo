test_that("The sun vector is calculated for angle data in numeric format", {
  SAA <- 31.73
  SZA <- 46.27
  sv <- cbind(svx = 0.380030, svy = -0.614602, svz = 0.691261)
  expect_equal(sun_vector(SZA, SAA), sv, tolerance = 1e-6)
})

test_that("The sun vector is calculated for angle data in SpatRaster format", {
  SAA <- seq(from = 31.1, to = 31.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast()
  SZA <- seq(from = 46.1, to = 46.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast()
  sv <- cbind(svx = 0.379007, svy = -0.618483, svz = 0.688355)
  expect_equal(sun_vector(SZA, SAA), sv, tolerance = 1e-6)
})

test_that("Topographic hillshading is returned", {
  elev <- c(
    70, 69, 67,
    62, 59, 57,
    52, 48, 45
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast(
      crs = "+proj=utm +zone=19 +ellps=WGS84 +units=m +no_defs +type=crs",
      extent = c(591495, 591585, -1799445, -1799355)
    )
  SAA <- seq(from = 31.1, to = 31.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast(crs = terra::crs(elev), extent = terra::ext(elev))
  SZA <- seq(from = 46.1, to = 46.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast(crs = terra::crs(elev), extent = terra::ext(elev))
  hs <- c(
    0.504778, 0.480459, 0.480459,
    0.484201, 0.449504, 0.449504,
    0.484201, 0.449504, 0.449504
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast(
      crs = "+proj=utm +zone=19 +ellps=WGS84 +units=m +no_defs +type=crs",
      extent = c(591495, 591585, -1799445, -1799355)
    )
  result <- hill_shade(elev, SZA, SAA)
  expect_equal(terra::values(result), terra::values(hs), tolerance = 1e-6)
  expect_s4_class(result, "SpatRaster")
})
