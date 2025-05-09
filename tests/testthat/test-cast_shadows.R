test_that("Topographic shadows are calculated using a SpatRaster DEM", {
  dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
  shadows_base <- system.file("extdata/athabasca_shadows.tif", package = "SatRbedo")
  dem <- terra::rast(dem)
  shadows_base <- terra::rast(shadows_base)
  SZA <- 49
  SAA <- 165
  shadows_calc <- cast_shadows(dem, SZA, SAA)
  result <- shadows_calc == shadows_base
  expect_equal(all(terra::values(result), na.rm = TRUE), TRUE)
  expect_s4_class(shadows_calc, "SpatRaster")
})

test_that("Topographic shadows are calculated using a DEM matrix", {
  dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
  shadows_base <- system.file("extdata/athabasca_shadows.tif", package = "SatRbedo")
  dem <- terra::as.matrix(terra::rast(dem), wide = TRUE)
  shadows_base <- terra::as.matrix(terra::rast(shadows_base), wide = TRUE)
  SZA <- 49
  SAA <- 165
  dl <- 30
  shadows_calc <- cast_shadows(dem = dem, SZA = SZA, SAA = SAA, dl = dl)
  result <- shadows_calc == shadows_base
  expect_equal(all(result[], na.rm = TRUE), TRUE)
  expect_type(shadows_calc, "double")
})

test_that("An error is issued if the grid spacing is not provided", {
  dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
  shadows_base <- system.file("extdata/athabasca_shadows.tif", package = "SatRbedo")
  dem <- terra::as.matrix(terra::rast(dem), wide = TRUE)
  shadows_base <- terra::as.matrix(terra::rast(shadows_base), wide = TRUE)
  SZA <- 49
  SAA <- 165
  expect_error(cast_shadows(dem = dem, SZA = SZA, SAA = SAA))
})
