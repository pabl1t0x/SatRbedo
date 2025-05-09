#' Automatic discrimination of snow and ice cover types
#'
#' Calculates the Normalized Difference Snow Ice Index (NDSII)
#' \insertCite{keshri_2009}{SatRbedo} to discriminate between
#' snow and ice surfaces. The discrimination is performed using
#' an automatic threshold selection method based on the Otsu
#' algorithm \insertCite{otsu_1979}{SatRbedo}.
#'
#' @importFrom Rdpack reprompt
#'
#' @param green SpatRaster. Green band surface reflectance (0.53-0.59 um).
#' @param NIR SpatRaster. Near-infrared band surface reflectance (0.85-0.88 um).
#'
#' @returns Returns a list with two objects. The first component is an NDSII SpatRaster and the
#'  second component provides the optimal threshold to discriminate between snow and ice surfaces.
#'
#' @references
#' \insertAllCited{}
#'
#' @seealso [preproc()], [EBImage::otsu()], [terra::plot()]
#'
#' @examples
#' green <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' nir <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo")
#' outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' green <- preproc(grd = green, outline = outline)
#' nir <- preproc(grd = nir, outline = outline)
#' res <- snow_or_ice(green, nir)
#'
#' # Plot NDSII
#' library(terra)
#' plot(res$NDSII, range = c(-0.5, 0.5))
#'
#' # Plot a cover type binary map (snow/ice)
#' library(terra)
#' plot(res$NDSII > res$th, type = "classes", col = c("#FFFFC8", "#00407F"), levels = c("snow", "ice"))
#'
#' @export
snow_or_ice <- function(green, NIR) {
  green <- terra::ifel(green < 0, NA, green)
  NIR <- terra::ifel(NIR < 0, NA, NIR)
  NDSII <- (green - NIR) / (green + NIR)
  img <- terra::as.array(NDSII)
  th <- EBImage::otsu(img, range = c(-1, 1))
  list(NDSII = NDSII, th = th)
}

#' NDSII histogram
#'
#' This function creates an NDSII histogram with a vertical line showing the selected threshold
#' discriminating snow and ice.
#'
#' @param NDSII SpatRaster. Normalized Difference Snow Ice Index (NDSII).
#' @param th numeric. NDSII threshold to discriminate between snow and ice.
#' @inheritParams graphics::hist
#' @param stdev numeric. Standard deviation cutoff value for histogram stretching.
#'
#' @seealso [preproc()], [snow_or_ice()], [graphics::hist()]
#'
#' @examples
#' green <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' nir <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo")
#' outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' green <- preproc(grd = green, outline = outline)
#' nir <- preproc(grd = nir, outline = outline)
#' res <- snow_or_ice(green, nir)
#' NDSII_hist(res$NDSII, res$th, breaks = 16, stdev = 3)
#'
#' @export
NDSII_hist <- function(NDSII, th, breaks = 64, stdev = 2) {
  img <- terra::as.array(NDSII)
  value_min <- max(mean(img, na.rm = TRUE) - stdev * stats::sd(img, na.rm = TRUE), min(img, na.rm = TRUE))
  value_max <- min(mean(img, na.rm = TRUE) + stdev * stats::sd(img, na.rm = TRUE), max(img, na.rm = TRUE))
  values <- img[img > value_min & img < value_max & !is.na(img)]
  x <- graphics::hist(values, breaks = breaks, plot = FALSE)
  graphics::plot(x$breaks, c(x$counts, 0), type = "s", col = "blue", xlab = "NDSII", ylab = "counts", lwd = 2)
  graphics::abline(v = th, col = "red", lty = "dashed")
}
