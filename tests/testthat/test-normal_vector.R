test_that("A normal vector is computed for a given surface provided as a matrix", {
  elev <- c(
    70, 69, 67,
    62, 59, 57,
    52, 48, 45
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE)
  res <- 30
  normal <- c(
    0.063725, 0.109455, 0.109455,
    0.063119, 0.077578, 0.077578,
    0.063119, 0.077578, 0.077578,
    0.286764, 0.328366, 0.328366,
    0.315597, 0.356857, 0.356857,
    0.315597, 0.356857, 0.356857,
    0.955879, 0.938187, 0.938187,
    0.946792, 0.930932, 0.930932,
    0.946792, 0.930932, 0.930932
  ) |>
    array(dim = c(3, 3, 3))
  expect_equal(normal_vector(dem = elev, dlx = res), normal, tolerance = 1e-6)
})

test_that("A normal vector is computed for a SpatRaster DEM", {
  elev <- c(
    70, 69, 67,
    62, 59, 57,
    52, 48, 45
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE) |>
    terra::rast(extent = c(0, 90, 0, 90))
  normal <- c(
    0.063725, 0.109455, 0.109455,
    0.063119, 0.077578, 0.077578,
    0.063119, 0.077578, 0.077578,
    0.286764, 0.328366, 0.328366,
    0.315597, 0.356857, 0.356857,
    0.315597, 0.356857, 0.356857,
    0.955879, 0.938187, 0.938187,
    0.946792, 0.930932, 0.930932,
    0.946792, 0.930932, 0.930932
  ) |>
    array(dim = c(3, 3, 3))
  expect_equal(normal_vector(dem = elev), normal, tolerance = 1e-6)
})

test_that("An error is issued when the DEM is provided as a matrix without indicating its spatial resolution", {
  elev <- c(
    70, 69, 67,
    62, 59, 57,
    52, 48, 45
  ) |>
    matrix(nrow = 3, ncol = 3, byrow = TRUE)
  expect_error(normal_vector(dem = elev))
})
