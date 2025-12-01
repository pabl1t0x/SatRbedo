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

#' Topographic correction
#'
#' This tool corrects surface reflectance for the effects of topography. The objective
#' of the topographic correction is to compensate for the differences in solar
#' illumination to minimize the variability of observed reflectance for similar
#' targets and obtain the equivalent reflectance values over flat terrain. The empirical
#' methods provided here are suitable for mountain environments with rugged topography
#' and non-Lambertian surface properties. More details about these methods can be found
#' in the references below. \insertNoCite{riano_2003,tan_2013,chen_2023}{SatRbedo}
#'
#' @importFrom Rdpack reprompt
#'
#' @param band SpatRaster. Spectral band to be corrected.
#' @param dem SpatRaster. Digital elevation model representing terrain elevation
#'  on a regular grid.
#' @param SAA SpatRaster or numeric. Solar azimuth angle in degrees.
#' @param SZA SpatRaster or numeric. Solar zenith angle in degrees.
#' @param method character. Topographic correction model to be used. Two options are
#'  available: "tanrotation" \insertCite{@implements the rotation model proposed by @tan_2010}{SatRbedo},
#'  and "ccorrection" \insertCite{@C model, @teillet_1982}{SatRbedo}.
#' @param IC_min numeric. Minimum incidence angle to mask out regions of low illumination.
#'
#' @returns Returns a list with two objets. The first component is a SpatRaster with two layers
#'  providing the illumination condition (IC) and the corrected surface reflectance, and the
#'  second component contains the values of the empirical parameters obtained by each topographic
#'  correction model.
#'
#' @references
#' \insertAllCited{}
#'
#' @seealso [preproc()], [landsat::topocorr()]
#'
#' @examples
#' library(terra)
#' outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' nir <- system.file("extdata/athabasca_2020253_B8A_S30.tif", package = "SatRbedo")
#' dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
#' nir <- preproc(grd = nir)
#' dem <- preproc(grd = dem)
#' SAA <- 164.8
#' SZA <- 48.9
#'
#' # Topographic correction using method="tanrotation"
#' corr <- topo_corr(band = nir, dem = dem, SAA = SAA, SZA = SZA, method = "tanrotation")
#' plot(corr$bands[[1]]) # plot IC
#' plot(corr$bands[[2]]) # plot corrected surface reflectance
#'
#' # Topographic correction using method="ccorrection"
#' corr <- topo_corr(band = nir, dem = dem, SAA = SAA, SZA = SZA, method = "ccorrection", IC_min = 0.3)
#' plot(corr$bands[[2]]) # plot corrected surface reflectance
#'
#' @export
topo_corr <- function(band, dem, SAA, SZA, method = "tanrotation", IC_min = NULL) {
  slope <- terra::terrain(dem, v = "slope", neighbors = 4, unit = "radians")
  aspect <- terra::terrain(dem, v = "aspect", neighbors = 4, unit = "radians")
  sun_azimuth <- SAA * pi / 180
  sun_zenith <- SZA * pi / 180
  IC <- cos(slope) * cos(sun_zenith) + sin(slope) * sin(sun_zenith) * cos(aspect - sun_azimuth)
  METHODS <- c("tanrotation", "ccorrection")
  method <- pmatch(method, METHODS)
  if (is.na(method)) {
    cli::cli_abort("Invalid method. Please select one of the methods available.")
  } else if (method == 1) {
    band_lm <- stats::lm(as.vector(band) ~ as.vector(IC))
    a_band <- stats::coef(band_lm)[[2]]
    band_corr <- band - a_band * (IC - cos(sun_zenith))
    result <- c(IC, band_corr)
    names(result) <- c("IC", "band_corr")
    list(bands = result, a_band = a_band)
  } else if (method == 2) {
    if (is.null(IC_min)) {
      cli::cli_abort("Please introduce a value for IC_min.")
    }
    msk <- terra::ifel(IC > IC_min, 1, NA)
    band_lm <- stats::lm(as.vector(band) ~ as.vector(IC))
    c_band <- stats::coef(band_lm)[[1]] / stats::coef(band_lm)[[2]]
    band_corr <- band * (cos(sun_zenith) + c_band) / (IC + c_band)
    band_corr <- terra::mask(band_corr, msk)
    result <- c(IC, band_corr)
    names(result) <- c("IC", "band_corr")
    list(bands = result, c_band = c_band)
  }
}

#' Reflectance-IC scatterplot
#'
#' This function creates a scatterplot of surface reflectance vs. illumination
#' condition (IC). The plot can be used to explore the dependency of the original
#' and the topographically-corrected surface reflectance data on IC.
#'
#' @param IC SpatRaster. Illumination condition.
#' @param band SpatRaster. Spectral band to be processed.
#' @inheritParams terra::plot
#'
#' @seealso [topo_corr()], [graphics::abline()], [stats::lm()]
#'
#' @examples
#' outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' nir <- system.file("extdata/athabasca_2020253_B8A_S30.tif", package = "SatRbedo")
#' dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
#' nir <- preproc(grd = nir)
#' dem <- preproc(grd = dem)
#' SAA <- 164.8
#' SZA <- 48.9
#' corr <- topo_corr(band = nir, dem = dem, SAA = SAA, SZA = SZA, method = "tanrotation")
#'
#' # Scatterplot of IC vs. uncorrected surface reflectance
#' topo_splot(corr$bands[[1]], nir)
#'
#' # Scatterplot of IC vs. topographically-corrected surface reflectance
#' topo_splot(corr$bands[[1]], corr$bands[[2]])
#'
#' @export
topo_splot <- function(IC, band, maxcell = 100000) {
  IC <- terra::mask(IC, band)
  band_lm <- stats::lm(as.vector(band) ~ as.vector(IC))
  terra::plot(IC, band, maxcell, xlab = "IC", ylab = "Reflectance")
  graphics::abline(band_lm, lwd = 2, col = "blue")
}
