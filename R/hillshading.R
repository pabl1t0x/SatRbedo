#' Topographic hillshading
#'
#' Computes the hypothetical illumination of a surface by setting the position of
#' the sun and calculating the illumination values for each grid cell of a DEM. The
#'  `hill_shade` function is based upon the vectorial algebra algorithms developed
#' by \insertCite{corripio_2003;textual}{SatRbedo}. This function has been
#' optimized and updated to take advantage of the infrastructure provided by the `terra` package.
#'
#' @importFrom Rdpack reprompt
#'
#' @param dem SpatRaster. Digital elevation model representing terrain elevation
#'  on a regular grid.
#' @param SZA SpatRaster or numeric. Solar zenith angle in degrees.
#' @param SAA SpatRaster or numeric. Solar azimuth angle in degrees.
#'
#' @returns Returns a hillshade map in SpatRaster format.
#'
#' @references
#' \insertAllCited{}
#'
#' @seealso [normal_vector()], [sun_vector()]
#'
#' @examples
#' library(terra)
#' dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
#' dem <- terra::rast(dem)
#' SZA <- 49
#' SAA <- 165
#' hs <- hill_shade(dem, SZA, SAA)
#' plot(hs, col = grey(1:100 / 100))
#'
#' @export
hill_shade <- function(dem, SZA, SAA) {
  n <- normal_vector(dem)
  sv <- sun_vector(SZA, SAA)
  hs <- n[, , 1] * sv[1] + n[, , 2] * sv[2] + n[, , 3] * sv[3]
  # remove negative incidence angles (self-shading)
  hs <- (hs + abs(hs)) / 2
  out <- terra::rast(hs, crs = terra::crs(dem), extent = terra::ext(dem))
  out
}

#' Solar vector
#'
#' Computes a unit vector in the direction of the sun based on the solar azimuth and zenith angles.
#'
#' @importFrom Rdpack reprompt
#'
#' @param zenith SpatRaster or numeric. Solar zenith angle in degrees.
#' @param azimuth SpatRaster or numeric. Solar azimuth angle in degrees.
#'
#' @details Given the spherical coordinates (radius = 1, zenith, and azimuth angles),
#' the `sun_vector()` function gives the (x, y, z) coordinates of a unit normal vector
#' pointing towards the sun, where the X-axis is positive eastwards, the Y-axis is positive
#' southwards, and Z along the Earth radius and positive upwards \insertCite{corripio_2003}{SatRbedo}.
#'
#' @references
#' \insertAllCited{}
#'
#' @keywords internal
sun_vector <- function(zenith, azimuth) {
  if (inherits(zenith, "SpatRaster")) {
    zenith <- mean(terra::values(zenith), na.rm = TRUE)
  }
  if (inherits(azimuth, "SpatRaster")) {
    azimuth <- mean(terra::values(azimuth), na.rm = TRUE)
  }
  theta <- zenith * pi / 180
  phi <- azimuth * pi / 180
  svx <- sin(phi) * sin(theta)
  svy <- -cos(phi) * sin(theta)
  svz <- cos(theta)
  cbind(svx, svy, svz)
}
