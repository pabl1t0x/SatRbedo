#' c-factor BRDF normalization
#'
#' Calculates the c-factor proposed by \insertCite{roy_2016;textual}{SatRbedo}
#' which can be used to normalize surface reflectance data to nadir BRDF adjusted
#' reflectance (NBAR), or to convert NBAR observations to off-nadir surface reflectance.
#' The c-factor is calculated based on a spectral kernel-based BRDF model. The mathematical
#' formulation of the kernels is presented in
#' \insertCite{@ @wanner_1995, @lucht_2000 and @carlsen_2020;textual}{SatRbedo}.
#'
#' @importFrom Rdpack reprompt
#'
#' @param SAA SpatRaster or numeric. Solar azimuth angle in degrees.
#' @param SZA SpatRaster or numeric. Solar zenith angle in degrees.
#' @param VAA SpatRaster or numeric. Satellite sensor azimuth angle in degrees.
#' @param VZA SpatRaster or numeric. Satellite sensor zenith angle in degrees.
#' @param NSZ numeric. NBAR solar zenith angle. This prescribed `NSZ`
#'  is obtained from the satellite product metadata or calculated using
#'  the algorithm and code provided by \insertCite{li_2019;textual}{SatRbedo}.
#' @param br numeric. Crown relative height parameter. Defaults to 1.0.
#' @param hb numeric. Shape parameter. Defaults to 2.0.
#' @param band character. Spectral band to be processed. There are six bands
#'  that can be considered: "blue (0.43-0.45 um)", "green (0.53-0.59 u)",
#'  "red (0.64-0.67 um)", "NIR" (near-infrared, 0.85-0.88 um),
#'  "SWIR" (shortwave-infrared, 1.57-1.65 um), and "SWIR2 (shortwave-infrared, 2.11-2.29 um)".
#'
#' @returns Returns a single numeric value or a SpatRaster with the c-factor
#'  values for a spectral band.
#'
#' @references
#' \insertAllCited{}
#'
#' @examples
#' # Using data with numeric format
#' cfactor_BRDF(SAA = 56.58, SZA = 35.6, VAA = 236.4, VZA = 1.00, NSZ = 34.97, band = "NIR")
#'
#' # Using SpatRaster data
#' library(terra)
#' m1 <- matrix(seq(from = 56.54, to = 56.67, length.out = 9), nrow = 3, ncol = 3)
#' m2 <- matrix(seq(from = 35.54, to = 35.65, length.out = 9), nrow = 3, ncol = 3)
#' m3 <- matrix(seq(from = 221.05, to = 259.06, length.out = 9), nrow = 3, ncol = 3)
#' m4 <- matrix(seq(from = 0.53, to = 1.12, length.out = 9), nrow = 3, ncol = 3)
#' SAA <- terra::rast(m1)
#' SZA <- terra::rast(m2)
#' VAA <- terra::rast(m3)
#' VZA <- terra::rast(m4)
#' cfactor_BRDF(SAA, SZA, VAA, VZA, NSZ = 34.97, band = "NIR")
#'
#' @export
cfactor_BRDF <- function(SAA, SZA, VAA, VZA, NSZ, br = 1.0, hb = 2.0, band) {
  c_factor <- BRDF(SAA, NSZ, VAA, VZA * 0.0, br, hb, band) / BRDF(SAA, SZA, VAA, VZA, br, hb, band)
  c_factor
}

# Compute the RossThick kernel (radiative transfer-type
# volumetric scattering)
kvol <- function(SZA, VZA, phi_r) {
  cos_xi <- cos(SZA) * cos(VZA) + sin(SZA) * sin(VZA) * cos(phi_r)
  xi <- acos(cos_xi)
  k_vol <- (((pi / 2 - xi) * cos_xi + sin(xi)) / (cos(SZA) + cos(VZA))) - pi / 4
  k_vol
}

# Compute the LiSparse-R kernel (geometric-optical surface scattering)
kgeo <- function(SZA, VZA, phi_r, br, hb) {
  SZA_eq <- atan(br * tan(SZA))
  VZA_eq <- atan(br * tan(VZA))
  cos_xi_eq <- cos(SZA_eq) * cos(VZA_eq) + sin(SZA_eq) * sin(VZA_eq) * cos(phi_r)
  D <- sqrt(tan(SZA_eq)^2 + tan(VZA_eq)^2 - 2 * tan(SZA_eq) * tan(VZA_eq) * cos(phi_r))
  cos_t <- hb * sqrt(D^2 + (tan(SZA_eq) * tan(VZA_eq) * sin(phi_r))^2) / (1 / cos(SZA_eq) + 1 / cos(VZA_eq))
  if (inherits(cos_t, "SpatRaster")) {
    cos_t <- terra::ifel(cos_t < 1.0, cos_t, 1.0)
    cos_t <- terra::ifel(cos_t > -1.0, cos_t, -1.0)
  } else if (is.numeric(cos_t)) {
    cos_t <- ifelse(cos_t < 1.0, cos_t, 1.0)
    cos_t <- ifelse(cos_t > -1.0, cos_t, -1.0)
  } else {
    cli::cli_abort("The solar and view angles should be SpatRaster or numeric")
  }
  t <- acos(cos_t)
  O <- 1 / pi * (t - sin(t) * cos_t) * (1 / cos(SZA_eq) + 1 / cos(VZA_eq))
  k_geo <- O - 1 / cos(SZA_eq) - 1 / cos(VZA_eq) + 0.5 * (1 + cos_xi_eq) * 1 / cos(SZA_eq) * 1 / cos(VZA_eq)
  k_geo
}

# Compute the spectral kernel-based BRDF model
BRDF <- function(SAA, SZA, VAA, VZA, br, hb, band) {
  BANDS <- BRDF_parameters_cfactor$band
  band <- pmatch(band, BANDS)
  if (is.na(band)) {
    cli::cli_abort("Invalid band name. Please select one of the
	               six valid band designations")
  }
  f_band <- BRDF_parameters_cfactor[band, ]
  SZA <- SZA * pi / 180
  VZA <- VZA * pi / 180
  delta_phi <- SAA - VAA
  if (inherits(delta_phi, "SpatRaster")) {
    phi_r <- terra::ifel(delta_phi < 0, abs(delta_phi + 180.0), abs(delta_phi - 180.0))
  } else if (is.numeric(delta_phi)) {
    phi_r <- ifelse(delta_phi < 0, abs(delta_phi + 180.0), abs(delta_phi - 180.0))
  } else {
    cli::cli_abort("The solar and view angles should be SpatRaster or numeric")
  }
  phi_r <- phi_r * pi / 180
  f_BRDF <- f_band[, 2] + f_band[, 3] * kvol(SZA, VZA, phi_r) + f_band[, 4] * kgeo(SZA, VZA, phi_r, br, hb)
  f_BRDF
}
