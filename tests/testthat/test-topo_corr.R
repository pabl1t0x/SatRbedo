test_that("The topographic correction algorithm works", {
  SAA <- 164.8
  SZA <- 48.9
  band_green <- c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1087, 0.1258, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1159, 0.1228, 0.0534,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1004, 0.3249, 0.1024, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1256, 0.3516, 0.3079, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, 0.0750, 0.3575, 0.3052, 0.0442, NA, NA,
    0.8747, 1.0040, 1.0144, 1.0101, NA, 0.9238, NA, 0.0326, 0.2860, 0.3766, 0.1125, NA, NA, NA,
    1.0083, 1.1030, 1.0550, 1.0083, 0.9986, 0.9111, 0.2317, 0.1767, 0.3351, 0.1584, -0.0051, NA, NA, NA,
    1.0606, 1.1203, 1.0502, 0.9976, 0.9428, 0.7966, 0.4724, 0.3370, 0.3380, 0.0804, NA, NA, NA, NA,
    1.1191, 1.1162, 1.0693, 0.9341, 0.9548, 0.7391, 0.4350, 0.4423, 0.1776, 0.0676, NA, NA, NA, NA,
    1.1252, 1.1300, 1.0955, 1.0132, 0.9054, 0.7790, 0.5821, 0.3444, 0.2438, 0.3836, 0.6056, NA, NA, NA,
    1.1062, 1.0276, 0.9434, 0.8976, 0.8387, 0.8228, 0.7671, 0.6961, 0.6586, 0.7166, 0.5364, NA, NA, NA,
    1.0103, 0.9882, 0.9474, 0.8980, 0.8866, 0.8611, 0.8766, 0.8698, 0.8760, 0.7739, 0.6390, NA, NA, NA,
    0.9808, 1.0003, 0.9830, 0.9687, 0.9307, 0.8983, 0.9286, 0.9237, NA, NA, NA, NA, NA, NA
  ) |>
    matrix(ncol = 14, byrow = TRUE) |>
    terra::rast()
  dem <- c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 1999, 1985, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2043, 2029, 2049,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2129, 2091, 2064, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, 2184, 2158, 2128, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, 2214, 2196, 2179, 2163, NA, NA,
    3432, 3416, 3337, 3267, NA, 3096, NA, 2276, 2239, 2219, 2216, NA, NA, NA,
    3373, 3375, 3295, 3229, 3130, 3043, 2501, 2339, 2288, 2255, 2266, NA, NA, NA,
    3256, 3275, 3237, 3178, 3077, 2936, 2588, 2415, 2372, 2427, NA, NA, NA, NA,
    3151, 3170, 3152, 3088, 2953, 2823, 2589, 2476, 2505, 2677, NA, NA, NA, NA,
    3079, 3060, 3025, 2947, 2831, 2733, 2661, 2644, 2776, 2970, 3079, NA, NA, NA,
    2989, 2969, 2935, 2883, 2840, 2767, 2728, 2783, 2902, 3078, 3212, NA, NA, NA,
    2949, 2950, 2933, 2894, 2857, 2801, 2759, 2802, 2890, 3041, 3292, NA, NA, NA,
    2930, 2933, 2929, 2897, 2843, 2789, 2751, 2765, NA, NA, NA, NA, NA, NA
  ) |>
    matrix(ncol = 14, byrow = TRUE) |>
    terra::rast()
  a_band <- 0.4686149
  band_corr_tan <- c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.7698, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.8416, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.8093, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.8285, 0.8543, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, 0.8009, 0.9587, NA, NA, NA, NA,
    NA, 1.0642, 1.0906, 1.0698, NA, 1.0445, NA, 0.591, 0.8779, 0.7926, NA, NA, NA, NA,
    NA, 1.0775, 1.0207, 1.008, 0.9729, 0.8793, 0.7447, 0.747, 0.9886, NA, NA, NA, NA, NA,
    NA, 1.0811, 1.0234, 0.9215, 0.9615, 0.7988, 0.7209, 1.0359, 0.8306, NA, NA, NA, NA, NA,
    NA, 1.082, 1.056, 1.0079, 0.9699, 0.8891, 1.1235, 1.0022, 0.8728, 1.0181, NA, NA, NA, NA,
    NA, 0.984, 0.9344, 0.9532, 1.1258, 1.2239, 1.4201, 1.2991, 1.1739, 1.189, NA, NA, NA, NA,
    NA, 0.9321, 1.1162, 1.1688, 1.1065, 1.1473, 1.5012, 1.2185, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
  ) |>
    matrix(ncol = 14, byrow = TRUE) |>
    terra::rast()
  names(band_corr_tan) <- "band_corr"
  c_k <- 1.465775
  band_corr_c <- c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.3511, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.676, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.6511, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.6788, 0.6811, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, 0.5928, 0.9075, NA, NA, NA, NA,
    NA, 1.0617, 1.0942, 1.0748, NA, 1.0521, NA, 0.3028, 0.7374, 0.4369, NA, NA, NA, NA,
    NA, 1.0741, 1.02, 1.0081, 0.9722, 0.8688, 0.6505, 0.5732, 0.9766, NA, NA, NA, NA, NA,
    NA, 1.0781, 1.0222, 0.9224, 0.9612, 0.7863, 0.6104, 1.0964, 0.5168, NA, NA, NA, NA, NA,
    NA, 1.078, 1.0537, 1.0079, 0.9682, 0.8759, 1.2769, 1.0163, 0.6628, 1.059, NA, NA, NA, NA,
    NA, 0.9844, 0.935, 0.9507, 1.1788, 1.3784, 2.2322, 1.7673, 1.3662, 1.3646, NA, NA, NA, NA,
    NA, 0.9354, 1.141, 1.2338, 1.1382, 1.2089, 2.3549, 1.3392, NA, NA, NA, NA, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
  ) |>
    matrix(ncol = 14, byrow = TRUE) |>
    terra::rast()
  names(band_corr_c) <- "band_corr"
  result_tan <- topo_corr(band_green, dem, SAA, SZA, method = "tanrotation")
  result_c <- topo_corr(band_green, dem, SAA, SZA, method = "ccorrection", IC_min = -0.8)
  expect_equal(terra::values(result_tan$bands[[2]]), terra::values(band_corr_tan), tolerance = 1e-4)
  expect_equal(result_tan$a_band, a_band, tolerance = 1e-6)
  expect_equal(terra::values(result_c$bands[[2]]), terra::values(band_corr_c), tolerance = 1e-4)
  expect_equal(result_c$c_band, c_k, tolerance = 1e-6)
})

test_that("Error are issued if an incorrect method is specified to topo_corr or IC_min is missing for method='ccorrection'", {
  SAA <- 164.8
  SZA <- 48.9
  band_green <- c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1087, 0.1258, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1159, 0.1228, 0.0534,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1004, 0.3249, 0.1024, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, 0.1256, 0.3516, 0.3079, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, 0.0750, 0.3575, 0.3052, 0.0442, NA, NA,
    0.8747, 1.0040, 1.0144, 1.0101, NA, 0.9238, NA, 0.0326, 0.2860, 0.3766, 0.1125, NA, NA, NA,
    1.0083, 1.1030, 1.0550, 1.0083, 0.9986, 0.9111, 0.2317, 0.1767, 0.3351, 0.1584, -0.0051, NA, NA, NA,
    1.0606, 1.1203, 1.0502, 0.9976, 0.9428, 0.7966, 0.4724, 0.3370, 0.3380, 0.0804, NA, NA, NA, NA,
    1.1191, 1.1162, 1.0693, 0.9341, 0.9548, 0.7391, 0.4350, 0.4423, 0.1776, 0.0676, NA, NA, NA, NA,
    1.1252, 1.1300, 1.0955, 1.0132, 0.9054, 0.7790, 0.5821, 0.3444, 0.2438, 0.3836, 0.6056, NA, NA, NA,
    1.1062, 1.0276, 0.9434, 0.8976, 0.8387, 0.8228, 0.7671, 0.6961, 0.6586, 0.7166, 0.5364, NA, NA, NA,
    1.0103, 0.9882, 0.9474, 0.8980, 0.8866, 0.8611, 0.8766, 0.8698, 0.8760, 0.7739, 0.6390, NA, NA, NA,
    0.9808, 1.0003, 0.9830, 0.9687, 0.9307, 0.8983, 0.9286, 0.9237, NA, NA, NA, NA, NA, NA
  ) |>
    matrix(ncol = 14, byrow = TRUE) |>
    terra::rast()
  dem <- c(
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 1999, 1985, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2043, 2029, 2049,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, 2129, 2091, 2064, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, NA, 2184, 2158, 2128, NA, NA,
    NA, NA, NA, NA, NA, NA, NA, NA, 2214, 2196, 2179, 2163, NA, NA,
    3432, 3416, 3337, 3267, NA, 3096, NA, 2276, 2239, 2219, 2216, NA, NA, NA,
    3373, 3375, 3295, 3229, 3130, 3043, 2501, 2339, 2288, 2255, 2266, NA, NA, NA,
    3256, 3275, 3237, 3178, 3077, 2936, 2588, 2415, 2372, 2427, NA, NA, NA, NA,
    3151, 3170, 3152, 3088, 2953, 2823, 2589, 2476, 2505, 2677, NA, NA, NA, NA,
    3079, 3060, 3025, 2947, 2831, 2733, 2661, 2644, 2776, 2970, 3079, NA, NA, NA,
    2989, 2969, 2935, 2883, 2840, 2767, 2728, 2783, 2902, 3078, 3212, NA, NA, NA,
    2949, 2950, 2933, 2894, 2857, 2801, 2759, 2802, 2890, 3041, 3292, NA, NA, NA,
    2930, 2933, 2929, 2897, 2843, 2789, 2751, 2765, NA, NA, NA, NA, NA, NA
  ) |>
    matrix(ncol = 14, byrow = TRUE) |>
    terra::rast()
  expect_error(topo_corr(band_green, dem, SAA, SZA, method = "othermethod"))
  expect_error(topo_corr(band_green, dem, SAA, SZA, method = "ccorrection"))
})
