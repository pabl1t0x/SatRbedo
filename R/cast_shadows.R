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

#' Cast shadows
#'
#' Calculates cast shadows over a matrix or SpatRaster digital elevation model (DEM)
#' for a given illumination direction.
#'
#' @importFrom Rdpack reprompt
#'
#' @param dem matrix or SpatRaster. Digital elevation model representing terrain elevation
#'  on a regular grid.
#' @param SZA SpatRaster or numeric. Solar zenith angle in degrees.
#' @param SAA SpatRaster or numeric. Solar azimuth angle in degrees.
#' @param dl numeric. Grid spacing. Not needed if `dem` is SpatRaster.
#' @param sombra Returned matrix or SpatRaster.
#'
#' @details `cast_shadows()` calls a fortran routine called `doshade` that scans the DEM in
#'  lines parallel to the sun direction. It compares the projection of the grid cells on a
#'  plane perpendicular to the sun to determine whether they are exposed to direct solar
#'  illumination or shadowed by neighbor objects, such as mountains. See
#'  \insertCite{corripio_2003;textual}{SatRbedo} for details. The `doshade` subroutine
#'  was originally written by Javier Corripio and it was shipped with the `insol`
#'  package. This function has been optimized and updated to take advantage of the
#'  infrastructure provided by the `{terra}` package.
#'
#' @returns Returns an object of the same class as the input DEM (matrix or SpatRaster),
#'  with values of 0 for cast-shadowed pixels and 1 for not-shaded pixels.
#'
#' @references
#' \insertAllCited{}
#'
#' @examples
#' library(terra)
#' dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
#' dem <- terra::rast(dem)
#' SZA <- 49
#' SAA <- 165
#' cs <- cast_shadows(dem, SZA, SAA)
#' plot(cs, col = grey(0:1))
#'
#' @useDynLib SatRbedo doshade
#'
#' @export
cast_shadows <- function(dem, SZA, SAA, dl = 0, sombra = dem) {
  switchdem <- 0
  if (inherits(dem, "SpatRaster")) {
    switchdem <- 1
    dproj <- terra::crs(dem)
    dext <- terra::ext(dem)
    dl <- terra::res(dem)[1]
    dem0 <- dem
    dem <- terra::as.matrix(dem, wide = TRUE)
  }
  cols <- ncol(dem)
  rows <- nrow(dem)
  sv <- sun_vector(SZA, SAA)
  if (dl == 0) {
    cli::cli_abort("The DEM is not a SpatRaster. Please specify the DEM resolution")
  }
  dem[is.na(dem)] <- -99999
  out <- .Fortran("doshade",
    dem = as.numeric(t(dem)),
    sunvector = as.vector(sv),
    cols = as.integer(cols),
    rows = as.integer(rows),
    dl = as.double(dl),
    sombra = as.numeric(dem),
    PACKAGE = "SatRbedo"
  )
  sombra <- t(matrix(out$sombra, nrow = cols))
  if (switchdem) {
    sombra <- terra::rast(sombra, crs = dproj)
    terra::ext(sombra) <- dext
    sombra <- terra::crop(sombra, dem0, mask = TRUE)
  } else {
    sombra[dem == -99999] <- NA
  }
  sombra
}
