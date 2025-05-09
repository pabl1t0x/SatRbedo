#' Topographic shadows
#'
#' Detects and removes self-shadowed pixels (i.e., pixels having
#' aspect angles oriented away from the sun) and cast shadows (i.e,
#' pixels facing towards the direction of the sun but where sunlight
#' is blocked by neighbor topographic features such as mountains).
#' Self-shadowed pixels are detected when the angle between the sun
#' and the vector normal to the grid cell's surface is higher than
#' \eqn{\frac{\pi}{2}}. Cast shadows are calculated using the
#' [cast_shadows()] function.
#'
#' @param dem SpatRaster. Digital elevation model representing terrain elevation
#'  on a regular grid.
#' @param SZA SpatRaster or numeric. Solar zenith angle in degrees.
#' @param SAA SpatRaster or numeric. Solar azimuth angle in degrees.
#' @param mask logical. If `TRUE`, shadow pixels are masked.
#'
#' @returns Returns a SpatRaster with topographic shadows removed.
#'
#' @seealso [cast_shadows()], [hill_shade()]
#'
#' @examples
#' library(terra)
#' dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
#' dem <- terra::rast(dem)
#' SZA <- 49
#' SAA <- 165
#' msk <- shadow_removal(dem, SZA, SAA, mask = TRUE)
#' plot(msk, col = "blue")
#'
#' # Overlay an RGB composite with the shadow masks
#' blue <- terra::rast(system.file("extdata/athabasca_B02_20200911.tif", package = "SatRbedo"))
#' green <- terra::rast(system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo"))
#' red <- terra::rast(system.file("extdata/athabasca_B04_20200911.tif", package = "SatRbedo"))
#' r <- c(stretch(blue), stretch(green), stretch(red))
#' RGB(r) <- c(3, 2, 1)
#' plot(r)
#' msk <- shadow_removal(dem, SZA, SAA, mask = FALSE)
#' plot(msk, col = grey(0:1), alpha = 0.2, add = TRUE)
#'
#' @export
shadow_removal <- function(dem, SZA, SAA, mask = TRUE) {
  cs <- cast_shadows(dem = dem, SZA = SZA, SAA = SAA)
  hs <- hill_shade(dem, SZA, SAA)
  masked_pixels <- cs * hs
  if (mask) {
    msk <- terra::ifel(masked_pixels == 0, NA, 1)
  } else {
    msk <- terra::ifel(masked_pixels == 0, 0, 1)
  }
  msk
}
