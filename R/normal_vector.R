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

#' Unit normal vector of a surface
#'
#' Computes a unit vector normal to each grid cell in a digital elevation model.
#'
#' @importFrom Rdpack reprompt
#'
#' @param dem matrix or SpatRaster. Digital elevation model representing terrain elevation
#'  on a regular grid.
#' @param dlx numeric. Spatial resolution along the `x` axis in meters.
#' @param dly numeric. Spatial resolution along the `y` axis in meters.
#' @param cArea logical. If `TRUE`, returns the surface area of each grid cell. The default
#'  returns the gradient.
#'
#' @details Mathematically, a vector normal to an inclined surface, which is represented by
#' a plane enclosed by four data points \insertCite{@see Fig. 1 of @corripio_2003}{SatRbedo},
#' is defined as the average of the cross products of the vectors along the sides of the grid
#' cell. By definition, the length of this vector is equal to the surface area of the grid cell.
#' This function was originally written by Javier Corripio as part of the `insol` package.
#' The function has been optimized and updated to take advantage of the infrastructure provided
#' by the `{terra}` package.
#'
#' @returns Returns a 3D array with the same number of rows and columns as the DEM and the three
#'  layers in the third dimension corresponding to the (x, y, z) components of the normal vectors
#'  to each of the grid cells. If cArea is `TRUE`, the result is a 2D matrix with the
#'  surface area of each grid cell.
#'
#' @references
#' \insertAllCited{}
#'
#' @keywords internal
normal_vector <- function(dem, dlx = 0, dly = dlx, cArea = FALSE) {
  if (inherits(dem, "SpatRaster")) {
    dlx <- terra::res(dem)[1]
    dly <- terra::res(dem)[2]
    dem <- terra::as.matrix(dem, wide = TRUE)
  }
  if (dlx == 0) {
    cli::cli_abort("The DEM is not a SpatRaster. Please specify the DEM resolution dlx")
  }
  mm <- as.matrix(dem)
  rows <- nrow(mm)
  cols <- ncol(mm)
  cellgr <- array(dim = c(rows, cols, 3))
  md <- mm[-rows, -1]
  mr <- mm[-1, -cols]
  mrd <- mm[-1, -1]
  cellgr[-rows, -cols, 2] <- .5 * dlx * (mm[-rows, -cols] + md - mr - mrd)
  cellgr[-rows, -cols, 1] <- .5 * dly * (mm[-rows, -cols] - md + mr - mrd)
  cellgr[-rows, -cols, 3] <- dlx * dly
  # The last row and col are undefined. Replicate the last values from the previous row/col
  cellgr[rows, , ] <- cellgr[(rows - 1), , ]
  cellgr[, cols, ] <- cellgr[, (cols - 1), ]
  cellArea <- sqrt(cellgr[, , 1]^2 + cellgr[, , 2]^2 + cellgr[, , 3]^2)
  if (cArea) {
    return(cellArea)
  } else {
    for (i in 1:3) {
      cellgr[, , i] <- cellgr[, , i] / cellArea
    }
    return(cellgr)
  }
}
