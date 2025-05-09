#' Satellite data pre-processing
#'
#' `preproc()` crops an input grid to a specified extent with a polygon, reprojects
#' the grid to a specified coordinate system, and converts the data from
#' integer to floating point using an offset and a scale factor.
#'
#' @inheritParams terra::rast
#' @param grd filename (character) of the raster to be processed, in one of GDAL's raster
#'  [drivers](https://gdal.org/en/stable/drivers/raster/index.html).
#' @param outline filename (character) of the shapefile containing the outline of the area
#'  of interest, in `.shp` format.
#' @param coords filename (character) of the raster with the coordinate system definition.
#'  Alternatively, a coordinate reference system (CRS) description can
#'  be provided. In this case, the CRS can be described using the PROJ-string
#'  (e.g., "+proj=longlat +datum=WGS84") or the WKT format (e.g., "EPSG:4326").
#' @param add_offset band-specific offset added to each grid value. Defaults to zero.
#' @param scale_factor band-specific scale factor applied to each grid value. Defaults to one.
#'
#' @returns Returns a pre-processed SpatRaster grid.
#'
#' @seealso [terra::rast()], [terra::ext()], and [terra::project()] which this function wraps.
#'
#' @examples
#' # uncorrected grid
#' f <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' preproc(grd = f)
#'
#' # crop grid
#' g <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' v <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' preproc(grd = g, outline = v)
#'
#' # crop and reproject grid
#' g <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' v <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' preproc(grd = g, outline = v, coords = "+proj=longlat +datum=WGS84")
#'
#' preproc(grd = g, outline = v, coords = "EPSG:4326")
#'
#' # Transform grid values
#' library(terra)
#' g <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' orig <- preproc(grd = g)
#' minmax(orig)
#' new <- preproc(grd = g, add_offset = 5, scale_factor = 10)
#' minmax(new)
#'
#' @export
preproc <- function(grd, drivers = NULL, outline = NULL, coords = NULL, add_offset = 0, scale_factor = 1) {
  g <- terra::rast(grd, drivers)
  if (!is.null(outline)) {
    out <- terra::vect(outline)
    g <- terra::crop(g, out, mask = TRUE)
  }
  if (!is.null(coords)) {
    if (grepl("+proj=", coords) | grepl("EPSG:", coords)) {
      g <- terra::project(g, coords)
    } else if (inherits(terra::rast(coords, drivers), "SpatRaster")) {
      ref <- terra::rast(coords, drivers)
      g <- terra::project(g, ref)
    } else {
      cli::cli_abort("Reproject: please ensure that the coords argument is either
	                  the file location of the reference grid file or a valid CRS
					  description.")
    }
  }
  g <- add_offset + g * scale_factor
  g
}
