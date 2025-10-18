# SatRbedo: Tools for retrieving snow and ice albedo from optical satellite imagery.
# Copyright (C) 2025  Pablo Fuchs

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Satellite data pre-processing
#'
#' `preproc()` crops an input grid to a specified extent with a polygon or SpatExtent,
#' reprojects the grid to a specified coordinate system, and converts the data from integer
#' to floating point using an offset and a scale factor.
#'
#' @inheritParams terra::rast
#' @param grd filename (character) or SpatRaster of the raster to be processed, in one of
#'  GDAL's raster [drivers](https://gdal.org/en/stable/drivers/raster/index.html).
#' @param outline filename (character) of the shapefile containing the outline of the area
#'  of interest, in `.shp` format, or SpatExtent giving a vector of length four (xmin, xmax,
#'  ymin, ymax).
#' @param coords filename (character) or SpatRaster of the raster with the coordinate system
#'  definition. Alternatively, a coordinate reference system (CRS) description can
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
  if (inherits(grd, "character")) {
    g <- terra::rast(grd, drivers)
  } else {
    g <- grd
  }
  if (!is.null(outline)) {
    out <- terra::vect(outline, crs = terra::crs(g))
    g <- terra::crop(g, out, mask = TRUE)
  }
  if (!is.null(coords)) {
    if (grepl("+proj=", coords) | grepl("EPSG:", coords) |
      inherits(coords, "SpatRaster")) {
      g <- terra::project(g, coords)
    } else {
      cli::cli_abort("Reproject: please ensure that the coords argument is either
                    the file location of the reference grid file or a valid CRS description.")
    }
  }
  g <- add_offset + g * scale_factor
  g
}
