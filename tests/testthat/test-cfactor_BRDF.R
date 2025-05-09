test_that("The kvol (volumetric scattering) kernel works with input data in numeric format", {
  SAA <- 31.73
  SZA <- 46.27
  VAA <- 291.59
  VZA <- 10.29
  SZA <- SZA * pi / 180
  VZA <- VZA * pi / 180
  phi_r <- abs(SAA - VAA - 180.0)
  phi_r <- phi_r * pi / 180
  vol <- -0.03374601
  expect_equal(kvol(SZA, VZA, phi_r), vol, tolerance = 1e-6)
  expect_type(kvol(SZA, VZA, phi_r), "double")
})

test_that("The kvol (volumetric scattering) kernel works with input data in SpatRaster format", {
  SAA <- matrix(seq(from = 31.1, to = 31.9, length.out = 9), nrow = 3, ncol = 3)
  SZA <- matrix(seq(from = 46.1, to = 46.9, length.out = 9), nrow = 3, ncol = 3)
  VAA <- matrix(seq(from = 291.1, to = 291.9, length.out = 9), nrow = 3, ncol = 3)
  VZA <- matrix(seq(from = 10.1, to = 10.9, length.out = 9), nrow = 3, ncol = 3)
  SZA <- (SZA * pi / 180) |> terra::rast()
  VZA <- (VZA * pi / 180) |> terra::rast()
  phi_r <- abs(SAA - VAA - 180.0)
  phi_r <- (phi_r * pi / 180) |> terra::rast()
  vol <- c(
    -0.03416274, -0.03372673, -0.03326812,
    -0.03401988, -0.03357640, -0.03311013,
    -0.03387456, -0.03342353, -0.03294956
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  result <- kvol(SZA, VZA, phi_r)
  expect_equal(terra::values(result), terra::values(vol), tolerance = 1e-6)
  expect_s4_class(result, "SpatRaster")
})

test_that("The kgeo (geometric scattering) kernel works with input data in numeric format", {
  SAA <- 31.73
  SZA <- 46.27
  VAA <- 291.59
  VZA <- 10.29
  SZA <- SZA * pi / 180
  VZA <- VZA * pi / 180
  phi_r <- abs(SAA - VAA - 180.0)
  phi_r <- phi_r * pi / 180
  br <- 1.5
  hb <- 2.0
  geo <- -1.394841
  expect_equal(kgeo(SZA, VZA, phi_r, br, hb), geo, tolerance = 1e-6)
  expect_type(kvol(SZA, VZA, phi_r), "double")
})

test_that("The kgeo (geometric scattering) kernel works with input data in SpatRaster format", {
  SAA <- matrix(seq(from = 31.1, to = 31.9, length.out = 9), nrow = 3, ncol = 3)
  SZA <- matrix(seq(from = 46.1, to = 46.9, length.out = 9), nrow = 3, ncol = 3)
  VAA <- matrix(seq(from = 291.1, to = 291.9, length.out = 9), nrow = 3, ncol = 3)
  VZA <- matrix(seq(from = 10.1, to = 10.9, length.out = 9), nrow = 3, ncol = 3)
  SZA <- (SZA * pi / 180) |> terra::rast()
  VZA <- (VZA * pi / 180) |> terra::rast()
  phi_r <- abs(SAA - VAA - 180.0)
  phi_r <- (phi_r * pi / 180) |> terra::rast()
  br <- 1.0
  hb <- 2.0
  geo <- c(
    -1.122188, -1.130878, -1.139577,
    -1.125083, -1.133777, -1.142478,
    -1.127980, -1.136677, -1.145379
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  result <- kgeo(SZA, VZA, phi_r, br, hb)
  expect_equal(terra::values(result), terra::values(geo), tolerance = 1e-6)
  expect_s4_class(result, "SpatRaster")
})

test_that("The cfactor computation succeeds with input data in numeric format", {
  SAA <- 31.73
  SZA <- 46.27
  VAA <- 291.59
  VZA <- 10.29
  NSZA <- 40.0
  br <- 1.0
  hb <- 2.0
  brdf <- 0.1414894
  NBAR <- 0.144642
  cfactor <- 1.022282
  expect_equal(BRDF(SAA, SZA, VAA, VZA, br, hb, band = "red"), brdf, tolerance = 1e-6)
  expect_equal(BRDF(SAA, NSZA, VAA, VZA * 0, br, hb, band = "red"), NBAR, tolerance = 1e-6)
  expect_equal(cfactor_BRDF(SAA, SZA, VAA, VZA, NSZA, br, hb, band = "red"), cfactor, tolerance = 1e-6)
  expect_type(cfactor_BRDF(SAA, SZA, VAA, VZA, NSZA, br, hb, band = "red"), "double")
})

test_that("The cfactor computation succeeds with input data in SpatRaster format", {
  SAA <- seq(from = 31.1, to = 31.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast()
  SZA <- seq(from = 46.1, to = 46.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast()
  VAA <- seq(from = 291.1, to = 291.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast()
  VZA <- seq(from = 10.1, to = 10.9, length.out = 9) |>
    matrix(nrow = 3, ncol = 3) |>
    terra::rast()
  NSZA <- 40.0
  br <- 1.0
  hb <- 2.0
  cfactor <- c(
    1.021733, 1.022977, 1.024217,
    1.022148, 1.023391, 1.024629,
    1.022563, 1.023804, 1.025040
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  result <- cfactor_BRDF(SAA, SZA, VAA, VZA, NSZA, br, hb, band = "red")
  expect_equal(terra::values(result), terra::values(cfactor), tolerance = 1e-6)
  expect_s4_class(result, "SpatRaster")
})

test_that("The cfactor computation stops when an incorrect band name is used", {
  SAA <- 31.73
  SZA <- 46.27
  VAA <- 291.59
  VZA <- 10.29
  NSZA <- 40.0
  br <- 1.0
  hb <- 2.0
  expect_error(cfactor_BRDF(SAA, SZA, VAA, VZA, NSZA, br, hb, band = "band_blue"))
})
