test_that("The anisotropy reflection factors for ice are returned using method='twobands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  slope <- c(
    8.10, 3.02, 5.13,
    4.26, 3.02, 4.04,
    5.39, 5.39, 5.79
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    69.44, 71.57, 21.80,
    63.43, 18.43, 45.00,
    45.00, 45.00, 80.54
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  th <- 0.2148438
  green <- c(
    0.51, 0.46, 0.31,
    0.48, 0.50, 0.42,
    0.50, 0.55, 0.39
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.24, 0.25, 0.15,
    0.26, 0.28, 0.20,
    0.23, 0.29, 0.20
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  f_green <- c(
    -0.0603951, -0.0586187, -0.0659594,
    -0.0600825, -0.0626942, -0.0621471,
    -0.0636093, -0.0636093, -0.0576663
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_green) <- "f_green"
  f_nir <- c(
    -0.0761007, -0.0742820, -0.0817527,
    -0.0758291, -0.0784196, -0.0779370,
    -0.0794412, -0.0794412, -0.0733088
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_nir) <- "f_NIR"
  result <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect, method = "twobands", green, nir, th = th)
  expect_equal(terra::values(result[[1]]), terra::values(f_green), tolerance = 1e-6)
  expect_equal(terra::values(result[[2]]), terra::values(f_nir), tolerance = 1e-6)
  expect_s4_class(result, "SpatRaster")
})

test_that("The anisotropy reflection factors for snow are returned using method='twobands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  slope <- c(
    6.09, 6.09, 7.42,
    8.05, 7.42, 6.09,
    8.94, 9.46, 7.42
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    51.34, 51.34, 39.81,
    45.00, 39.81, 38.66,
    32.01, 36.87, 39.81
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  th <- 0.2148438
  green <- c(
    0.8233, 0.8068, 0.7922,
    0.8145, 0.7983, 0.7824,
    0.8011, 0.7926, 0.7929
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.6860, 0.6702, 0.6587,
    0.6766, 0.6632, 0.6520,
    0.6651, 0.6561, 0.6533
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  f_green <- c(
    -0.0373828, -0.0294974, -0.0276024,
    -0.0374170, -0.0303175, -0.0215925,
    -0.0360152, -0.0316827, -0.0279085
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_green) <- "f_green"
  f_nir <- c(
    -0.0400993, -0.0311438, -0.0292201,
    -0.0385001, -0.0315860, -0.0242448,
    -0.0364113, -0.0312200, -0.0264924
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_nir) <- "f_NIR"
  result <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect, method = "twobands", green, nir, th = th)
  expect_equal(terra::values(result[[1]]), terra::values(f_green), tolerance = 1e-3)
  expect_equal(terra::values(result[[2]]), terra::values(f_nir), tolerance = 1e-3)
  expect_s4_class(result, "SpatRaster")
})

test_that("The anisotropy reflection factors are returned for valid snow and ice pixels and
  NAs are returned when the surface reflectance values or the solar zenith angles are outside
  the ranges of the BRDF parameterizations for method='twobands'", {
  SAA <- rep(164.8, times = 9) |>
    matrix(nrow = 3) |>
    terra::rast()
  SZA <- rep(48.9, times = 9) |>
    matrix(nrow = 3) |>
    terra::rast()
  VAA <- rep(90.9, times = 9) |>
    matrix(nrow = 3) |>
    terra::rast()
  VZA <- rep(5.2, times = 9) |>
    matrix(nrow = 3) |>
    terra::rast()
  slope <- c(
    5.71, 2.86, 16.53,
    17.84, 18.96, 8.98,
    6.02, 18.94, 15.61
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    0.00, 0.00, 51.84,
    21.25, 14.04, 71.57,
    18.43, 330.95, 162.65
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  th <- 0.2148438
  green <- c(
    0.3763, 0.3214, 0.2447,
    0.2748, 0.2436, 0.8330,
    0.6909, 0.5140, 1.1528
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.2153, 0.2163, 0.1911,
    0.1729, 0.1629, 0.6837,
    0.5525, 0.3972, 0.9247
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  f_green <- c(
    -0.0681814, 0.0417773, 0.0321981,
    -0.0838712, NA, -0.0373435,
    0.0068793, NA, NA
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_green) <- "f_green"
  f_nir <- c(
    -0.0838407, 0.0329788, 0.0277226,
    -0.0975343, NA, -0.0343358,
    0.0104754, NA, -0.1793122
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_nir) <- "f_NIR"
  result <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect, method = "twobands", green, nir, th = th)
  expect_equal(terra::values(result[[1]]), terra::values(f_green), tolerance = 1e-4)
  expect_equal(terra::values(result[[2]]), terra::values(f_nir), tolerance = 1e-4)
  expect_s4_class(result, "SpatRaster")
})

test_that("The anisotropy reflection factors for ice are returned using method='fivebands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    4.26, 3.44, 6.72,
    3.93, 2.70, 4.04,
    6.38, 0.95, 8.10
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    63.43, 56.31, 45.00,
    104.04, 315.00, 45.00,
    63.43, 90.00, 20.56
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4490, 0.3008, 0.4552,
    0.4725, 0.4791, 0.3073,
    0.4617, 0.4126, 0.1253
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.2238, 0.1373, 0.2534,
    0.2156, 0.2689, 0.1821,
    0.2342, 0.2328, 0.0664
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  f_blue <- c(
    -0.0292242, -0.0295485, -0.0341889,
    -0.0245277, -0.0312010, -0.0312647,
    -0.0302677, -0.0269208, -0.0409253
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_blue) <- "f_blue"
  f_red <- c(
    -0.0257446, -0.0262193, -0.0330911,
    -0.0195373, -0.0289054, -0.0286851,
    -0.0272240, -0.0227049, -0.0443713
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_red) <- "f_red"
  f_nir <- c(
    -0.0473571, -0.0478041, -0.0542290,
    -0.0406677, -0.0499864, -0.0501974,
    -0.0488167, -0.0440594, -0.0632614
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_nir) <- "f_NIR"
  f_swir1 <- c(
    0.0000000, 0.0000000, 0.0000000,
    0.0000000, 0.0000000, 0.0000000,
    0.0000000, 0.0000000, 0.0000000
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_swir1) <- "f_SWIR1"
  f_swir2 <- c(
    0.0000000, 0.0000000, 0.0000000,
    0.0000000, 0.0000000, 0.0000000,
    0.0000000, 0.0000000, 0.0000000
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_swir2) <- "f_SWIR2"
  result <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect, method = "fivebands", green, nir, th = th)
  expect_equal(terra::values(result[[1]]), terra::values(f_blue), tolerance = 1e-6)
  expect_equal(terra::values(result[[2]]), terra::values(f_red), tolerance = 1e-6)
  expect_equal(terra::values(result[[3]]), terra::values(f_nir), tolerance = 1e-6)
  expect_equal(terra::values(result[[4]]), terra::values(f_swir1), tolerance = 1e-6)
  expect_equal(terra::values(result[[5]]), terra::values(f_swir2), tolerance = 1e-6)
  expect_s4_class(result, "SpatRaster")
})

test_that("The anisotropy reflection factors for snow are returned using method='fivebands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    22.29, 11.31,  2.13,
    12.26, 15.85, 17.01,
    15.85,  5.55,  8.48
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    153.43, 180.00, 63.43,
    85.60, 319.76, 150.64,
    310.24, 210.96, 153.43
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    1.1378, 1.0905, 0.9017,
    0.8638, 0.6511, 0.6295,
    0.6622, 0.9205, 1.0474
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.9157, 0.8846, 0.7139,
    0.7223, 0.5182, 0.4912,
    0.5362, 0.7683, 0.8255
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  f_blue <- c(
    -0.0003816, -0.0017695, -0.0089026,
    -0.0070831, -0.0696432, -0.0008092,
    -0.0595761, -0.0049090, -0.0025375
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_blue) <- "f_blue"
  f_red <- c(
    -0.0089635, -0.0154990, -0.0274703,
    -0.0253176, -0.0558951, -0.0117454,
    -0.0528782, -0.0222308, -0.0176472
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_red) <- "f_red"
  f_nir <- c(
    -0.0108815, -0.0188440, -0.0333426,
    -0.0307237, -0.0668178, -0.0142899,
    -0.0632128, -0.0269854, -0.0214797
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_nir) <- "f_NIR"
  f_swir1 <- c(
    -0.0243840, -0.0338471, -0.0469809,
    -0.0447494, -0.0665778, -0.0288551,
    -0.0644523, -0.0415187, -0.0367023
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_swir1) <- "f_SWIR1"
  f_swir2 <- c(
    -0.0212418, -0.0307190, -0.0445429,
    -0.0421683, -0.0668600, -0.0256408,
    -0.0644544, -0.0387385, -0.0336294
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_swir2) <- "f_SWIR2"
  result <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect, method = "fivebands", green, nir, th = th)
  expect_equal(terra::values(result[[1]]), terra::values(f_blue), tolerance = 1e-5)
  expect_equal(terra::values(result[[2]]), terra::values(f_red), tolerance = 1e-5)
  expect_equal(terra::values(result[[3]]), terra::values(f_nir), tolerance = 1e-5)
  expect_equal(terra::values(result[[4]]), terra::values(f_swir1), tolerance = 1e-5)
  expect_equal(terra::values(result[[5]]), terra::values(f_swir2), tolerance = 1e-5)
  expect_s4_class(result, "SpatRaster")
})

test_that("The anisotropy reflection factors are returned for valid snow and ice pixels and
  NAs are returned when the solar zenith angles are outside the ranges of the BRDF
  parameterizations for method='fivebands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    4.86, 17.66, 17.55,
    18.13, 18.88, 27.79,
    14.51, 27.43, 21.61
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    348.69, 83.99, 161.57,
    14.74, 46.97, 18.43,
    14.93, 312.40, 337.75
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4342, 0.4001, 0.6918,
    0.2503, 0.2346, 0.2696,
    0.3030, 0.4877, 0.5236
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.2111, 0.3778, 0.5829,
    0.1448, 0.1297, 0.1675,
    0.1505, 0.3658, 0.3983
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  f_blue <- c(
    -0.0364093, -0.0079081, -0.0006806,
    NA, NA, NA,
    NA, NA, -0.1888044
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_blue) <- "f_blue"
  f_red <- c(
    -0.0369012, -0.0262246, -0.0110353,
    NA, NA, NA,
    NA, NA, -0.0788450
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_red) <- "f_red"
  f_nir <- c(
    -0.0571506, -0.0317340, -0.0134181,
    NA, NA, NA,
    NA, NA, -0.0935219
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_nir) <- "f_NIR"
  f_swir1 <- c(
    0.0000000, -0.0451114, -0.0277463,
    NA, NA, NA,
    NA, NA, -0.0786489
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_swir1) <- "f_SWIR1"
  f_swir2 <- c(
    0.0000000, -0.0426528, -0.0245433,
    NA, NA, NA,
    NA, NA, -0.0812249
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(f_swir2) <- "f_SWIR2"
  result <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect, method = "fivebands", green, nir, th = th)
  expect_equal(terra::values(result[[1]]), terra::values(f_blue), tolerance = 1e-5)
  expect_equal(terra::values(result[[2]]), terra::values(f_red), tolerance = 1e-5)
  expect_equal(terra::values(result[[3]]), terra::values(f_nir), tolerance = 1e-5)
  expect_equal(terra::values(result[[4]]), terra::values(f_swir1), tolerance = 1e-5)
  expect_equal(terra::values(result[[5]]), terra::values(f_swir2), tolerance = 1e-5)
  expect_s4_class(result, "SpatRaster")
})

test_that("An error is issued if an incorrect method is specified to f_BRDF", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    8.74, 9.46, 8.16,
    7.42, 8.94, 9.46,
    7.65, 7.65, 8.16
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    49.40, 53.13, 54.46,
    50.19, 57.99, 53.13,
    60.26, 60.26, 54.46
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.48, 0.52, 0.41,
    0.51, 0.45, 0.39,
    0.44, 0.38, 0.36
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.28, 0.26, 0.24,
    0.26, 0.25, 0.23,
    0.25, 0.22, 0.21
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  expect_error(f_BRDF(SAA, SZA, VAA, VZA, slope, aspect, method = "somemethod", green, nir, th = th))
})

test_that("Narrow and broadband albedo are returned for method=='twobands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    4.86, 21.26, 13.82,
    23.19, 11.35, 7.65,
    17.08, 3.44, 3.81
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    11.31, 9.87, 61.70,
    346.50, 175.24, 150.26,
    12.53, 56.31, 180.00
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4037, 0.2312, 0.8004,
    0.2757, 1.1371, 1.0254,
    0.1850, 0.8680, 1.0468
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.1986, 0.1830, 0.6610,
    0.1903, 0.8966, 0.8045,
    0.1247, 0.7200, 0.8607
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  albedo_green <- c(
    0.4699, NA, 0.8298,
    NA, NA, NA,
    0.1616, 0.9251, NA
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_green) <- "albedo_green"
  albedo_NIR <- c(
    0.2806, NA, 0.6893,
    NA, 1.0722, 0.8984,
    0.1064, 0.7780, 1.0462
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_NIR) <- "albedo_NIR"
  albedo_broad <- c(
    0.3015, NA, 0.6216,
    NA, 1.0086, 0.8220,
    0.1101, 0.7080, 0.9801
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_broad) <- "albedo_broad"
  flags <- c(
    1, NA, 1,
    NA, 2, 2,
    1, 1, 2
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(flags) <- "flag"
  result <- albedo_sat(
    SAA, SZA, VAA, VZA, slope, aspect,
    method = "twobands", green = green, NIR = nir, th = th
  )
  expect_equal(terra::values(result[[1]]), terra::values(albedo_green), tolerance = 1e-4)
  expect_equal(terra::values(result[[2]]), terra::values(albedo_NIR), tolerance = 1e-4)
  expect_equal(terra::values(result[[3]]), terra::values(albedo_broad), tolerance = 1e-4)
  expect_equal(terra::values(result[[4]]), terra::values(flags))
  expect_s4_class(result, "SpatRaster")
})

test_that("Narrow and broadband albedo are returned for method=='fourbands'", {
  blue <- c(
    0.4271, 0.2922, 0.7802,
    0.2865, 0.7489, 1.0469,
    0.9642, -0.008, 0.5402
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4421, 0.3107, 0.8320,
    0.2901, 0.7996, 1.1038,
    1.0241, 0.0035, 0.5723
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  red <- c(
    0.3946, 0.2897, 0.8146,
    0.2852, 0.7905, 1.0624,
    1.0057, 0.0082, 0.5663
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.2365, 0.1777, 0.6833,
    0.2375, 0.6673, 0.8674,
    0.8283, 0.0097, 0.4655
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  albedo_broad <- c(
    0.4248, 0.3357, 0.6263,
    0.3874, 0.5969, 0.7724,
    0.6863, NA, 0.4824
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_broad) <- "albedo_broad"
  result <- albedo_sat(
    method = "fourbands", blue = blue, green = green,
    red = red, NIR = nir
  )
  expect_equal(terra::values(result[[5]]), terra::values(albedo_broad), tolerance = 1e-4)
  expect_s4_class(result, "SpatRaster")
})

test_that("Narrow and broadband albedo are returned for method=='fivebands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    8.16, 6.02, 8.74,
    10.22, 3.81, 15.90,
    43.97, 8.53, 2.13
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    54.46, 18.43, 40.60,
    56.31, 90.00, 20.56,
    341.88, 180.00, 206.57
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  blue <- c(
    0.3998, 0.3587, 0.3976,
    0.7379, 0.8821, 0.2984,
    0.0776, 1.0381, 0.9216
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4099, 0.3766, 0.4237,
    0.7807, 0.9321, 0.2997,
    0.0625, 1.0958, 0.9732
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  red <- c(
    0.3630, 0.3327, 0.4005,
    0.7609, 0.9133, 0.2741,
    0.0447, 1.0592, 0.9522
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.2044, 0.1813, 0.3028,
    0.6333, 0.7556, 0.1697,
    0.0115, 0.8659, 0.7764
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  swir1 <- c(
    -0.0103, -0.0199, -0.0076,
    -0.0003,  0.0094, -0.0138,
    -0.0143,  0.0047,  0.0110
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  swir2 <- c(
    0.0003, -0.0047, -0.0003,
    0.0048, 0.0110, -0.0036,
    -0.0057, 0.0089, 0.0123
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  albedo_blue <- c(
    0.4333, 0.3960, 0.4154,
    0.7526, 0.8894, NA,
    NA, 1.0407, 0.9283
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_blue) <- "albedo_blue"
  albedo_red <- c(
    0.3950, 0.3708, 0.4355,
    0.7936, 0.9390, NA,
    NA, 1.0769, 0.9770
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_red) <- "albedo_red"
  albedo_NIR <- c(
    0.2576, 0.2397, 0.3452,
    0.6729, 0.7868, NA,
    NA, 0.8875, 0.8065
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_NIR) <- "albedo_NIR"
  albedo_swir1 <- c(
    0.0000, 0.0000, 0.0000,
    0.0000, 0.0547, NA,
    NA, 0.0413, 0.0553
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_swir1) <- "albedo_SWIR1"
  albedo_swir2 <- c(
    0.0003, 0.0000, 0.0000,
    0.0543, 0.0537, NA,
    NA, 0.0425, 0.0540
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_swir2) <- "albedo_SWIR2"
  albedo_broad <- c(
    0.2999, 0.2768, 0.3315,
    0.6242, 0.7389, NA,
    NA, 0.8463, 0.7651
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast()
  names(albedo_broad) <- "albedo_broad"
  result <- albedo_sat(
    SAA, SZA, VAA, VZA,
    slope, aspect,
    method = "fivebands",
    blue = blue, green = green,
    red = red, NIR = nir,
    SWIR1 = swir1, SWIR2 = swir2,
    th = th
  )
  expect_equal(terra::values(result[[1]]), terra::values(albedo_blue), tolerance = 1e-3)
  expect_equal(terra::values(result[[2]]), terra::values(albedo_red), tolerance = 1e-3)
  expect_equal(terra::values(result[[3]]), terra::values(albedo_NIR), tolerance = 1e-3)
  expect_equal(terra::values(result[[4]]), terra::values(albedo_swir1), tolerance = 1e-3)
  expect_equal(terra::values(result[[5]]), terra::values(albedo_swir2), tolerance = 1e-3)
  expect_equal(terra::values(result[[6]]), terra::values(albedo_broad), tolerance = 1e-3)
  expect_s4_class(result, "SpatRaster")
})

test_that("An error is issued if an incorrect method is specified to albedo_sat", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    4.86, 21.26, 13.82,
    23.19, 11.35, 7.65,
    17.08, 3.44, 3.81
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    11.31, 9.87, 61.70,
    346.50, 175.24, 150.26,
    12.53, 56.31, 180.00
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4037, 0.2312, 0.8004,
    0.2757, 1.1371, 1.0254,
    0.1850, 0.8680, 1.0468
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.1986, 0.1830, 0.6610,
    0.1903, 0.8966, 0.8045,
    0.1247, 0.7200, 0.8607
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  expect_error(albedo_sat(
    SAA, SZA, VAA, VZA, slope, aspect,
    method = "somemethod", green = green, NIR = nir, th = th
  ))
})

test_that("An error is issued if either the green or NIR bands are not provided for method='twobands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    4.86, 21.26, 13.82,
    23.19, 11.35, 7.65,
    17.08, 3.44, 3.81
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    11.31, 9.87, 61.70,
    346.50, 175.24, 150.26,
    12.53, 56.31, 180.00
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4037, 0.2312, 0.8004,
    0.2757, 1.1371, 1.0254,
    0.1850, 0.8680, 1.0468
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.1986, 0.1830, 0.6610,
    0.1903, 0.8966, 0.8045,
    0.1247, 0.7200, 0.8607
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  expect_error(albedo_sat(
    SAA, SZA, VAA, VZA,
    method = "twobands", green = green, th = th
  ))
  expect_error(albedo_sat(
    SAA, SZA, VAA, VZA,
    method = "twobands", NIR = nir, th = th
  ))
})

test_that("An error is issued if either the blue, green, red, or NIR bands are not provided for method='fourbands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  blue <- c(
    0.4271, 0.2922, 0.7802,
    0.2865, 0.7489, 1.0469,
    0.9642, -0.008, 0.5402
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4421, 0.3107, 0.8320,
    0.2901, 0.7996, 1.1038,
    1.0241, 0.0035, 0.5723
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  red <- c(
    0.3946, 0.2897, 0.8146,
    0.2852, 0.7905, 1.0624,
    1.0057, 0.0082, 0.5663
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.2365, 0.1777, 0.6833,
    0.2375, 0.6673, 0.8674,
    0.8283, 0.0097, 0.4655
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  expect_error(albedo_sat(
    SAA, SZA, VAA, VZA,
    method = "fourbands", green = green, red = red
  ))
  expect_error(albedo_sat(
    SAA, SZA, VAA, VZA,
    method = "fourbands", green = green, red = red, NIR = nir
  ))
})

test_that("An error is issued if either band is missing for method='fivebands'", {
  SAA <- 164.8
  SZA <- 48.9
  VAA <- 90.9
  VZA <- 5.2
  th <- 0.2148438
  slope <- c(
    8.16, 6.02, 8.74,
    10.22, 3.81, 15.90,
    43.97, 8.53, 2.13
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  aspect <- c(
    54.46, 18.43, 40.60,
    56.31, 90.00, 20.56,
    341.88, 180.00, 206.57
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  blue <- c(
    0.3998, 0.3587, 0.3976,
    0.7379, 0.8821, 0.2984,
    0.0776, 1.0381, 0.9216
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  green <- c(
    0.4099, 0.3766, 0.4237,
    0.7807, 0.9321, 0.2997,
    0.0625, 1.0958, 0.9732
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  red <- c(
    0.3630, 0.3327, 0.4005,
    0.7609, 0.9133, 0.2741,
    0.0447, 1.0592, 0.9522
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  nir <- c(
    0.2044, 0.1813, 0.3028,
    0.6333, 0.7556, 0.1697,
    0.0115, 0.8659, 0.7764
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  swir1 <- c(
    -0.0103, -0.0199, -0.0076,
    -0.0003,  0.0094, -0.0138,
    -0.0143,  0.0047,  0.0110
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  swir2 <- c(
    0.0003, -0.0047, -0.0003,
    0.0048, 0.0110, -0.0036,
    -0.0057, 0.0089, 0.0123
  ) |>
    matrix(nrow = 3, byrow = TRUE) |>
    terra::rast()
  expect_error(albedo_sat(
    SAA, SZA, VAA, VZA,
    method = "fivebands",
    blue = blue, green = green,
    red = red, NIR = nir,
    SWIR1 = swir1, th = th
  ))
  expect_error(albedo_sat(
    SAA, SZA, VAA, VZA,
    method = "fivebands",
    blue = blue, green = green,
    SWIR1 = swir1, th = th
  ))
})
