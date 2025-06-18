# Remote sensing of snow and ice albedo
#' Anisotropy correction of reflected radiation over melting snow and glacier ice
#'
#' This tool corrects for the anisotropy of reflected radiation by melting snow and ice.
#' For a given surface type, the correction is carried out using an empirical model
#' of the Bidirectional Reflectance Distribution Function (BRDF) that depends on
#' the wavelength bands and the view-solar geometry. The procedure is applicable to visible,
#' near-infrared (NIR), and shortwave-infrared (SWIR) wavelenghts. More details about
#' the parameterizations can be found in the references list.
#' \insertNoCite{greuell_1999,koks_2001,de_ruyter_de_wildt_2002,ren_2021}{SatRbedo}
#'
#' @importFrom Rdpack reprompt
#'
#' @param SAA SpatRaster or numeric. Solar azimuth angle in degrees.
#' @param SZA SpatRaster or numeric. Solar zenith angle in degrees.
#' @param VAA SpatRaster or numeric. Satellite sensor azimuth angle in degrees.
#' @param VZA SpatRaster or numeric. Satellite sensor zenith angle in degrees.
#' @param slope SpatRaster or numeric. Surface slope in degrees.
#' @param aspect SpatRaster or numeric. Surface aspect in degrees.
#' @param method character. Number of spectral bands considered for the anisotropy
#'  correction. There are two options available: "twobands" (green and NIR) using
#'  the parameterizations of \insertCite{greuell_1999;textual}{SatRbedo} for ice
#'  and \insertCite{koks_2001;textual}{SatRbedo} for snow, and "fivebands"
#'  (blue, red, NIR, SWIR1, and SWIR2) using the methods described in
#'  \insertCite{ren_2021;textual}{SatRbedo}.
#' @param green SpatRaster. Green band surface reflectance (0.53-0.59 um).
#' @param NIR SpatRaster. Near-infrared band surface reflectance (0.85-0.88 um).
#' @param th numeric. NDSII threshold to discriminate between snow and ice.
#'
#' @section Notes:
#' `f` is not calculated for `method="twobands"` if the green or the NIR surface
#' reflectance values are greater than one or for pixels for which the SZA relative to the inclined
#' surface is >65.51° over snow or >74.2° over ice. For `method="fivebands"`, `f` is not
#' calculated if the SZA relative to the inclined surface is >70.9° over snow or >57.6°
#' over ice.
#'
#' @returns Returns a SpatRaster with two layers for `method="twobands"` and five layers
#'  for `method="fivebands"`. Each layer contains the anisotropic reflection factors (`f`)
#'  for each spectral band and surface type (snow or ice). All `f` values represent the
#'  difference between the satellite albedo retrievals and the surface reflectance observations.
#'
#' @references
#' \insertAllCited{}
#'
#' @seealso [preproc()], [terra::terrain()], [snow_or_ice()], [terra::plot()]
#'
#' @examples
#' library(terra)
#' outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' green <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' nir <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo")
#' dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
#' green <- preproc(grd = green, outline = outline)
#' nir <- preproc(grd = nir, outline = outline)
#' dem <- preproc(grd = dem, outline = outline)
#' SAA <- 164.8
#' SZA <- 48.9
#' VAA <- 90.9
#' VZA <- 5.2
#' slope <- terra::terrain(dem, v = "slope", neighbors = 4, unit = "degrees")
#' aspect <- terra::terrain(dem, v = "aspect", neighbors = 4, unit = "degrees")
#'
#' # f coefficients for two bands
#' th <- snow_or_ice(green, nir)$th
#' f <- f_BRDF(
#'   SAA = SAA, SZA = SZA, VAA = VAA, VZA = VZA,
#'   slope = slope, aspect = aspect,
#'   method = "twobands", green = green, NIR = nir,
#'   th = th
#' )
#' plot(f[[1]])
#' plot(f[[2]])
#'
#' # f coefficients for five bands
#' th <- snow_or_ice(green, nir)$th
#' f <- f_BRDF(
#'   SAA = SAA, SZA = SZA, VAA = VAA, VZA = VZA,
#'   slope = slope, aspect = aspect,
#'   method = "fivebands", green = green, NIR = nir,
#'   th = th
#' )
#' plot(f[[1]])
#' plot(f[[2]])
#' plot(f[[3]])
#' plot(f[[4]])
#' plot(f[[5]])
#'
#' @export
f_BRDF <- function(SAA, SZA, VAA, VZA,
                   slope, aspect,
                   method,
                   green,
                   NIR,
                   th) {
  if (inherits(SAA, "SpatRaster")) {
    SAA <- terra::ifel(terra::not.na(green), SAA, NA)
    phi_s <- SAA * pi / 180
  } else {
    SAA <- terra::rast(
      nrow = terra::nrow(green), ncol = terra::ncol(green),
      extent = terra::ext(green), crs = terra::crs(green), vals = SAA
    )
    SAA <- terra::ifel(terra::not.na(green), SAA, NA)
    phi_s <- SAA * pi / 180
  }
  if (inherits(SZA, "SpatRaster")) {
    SZA <- terra::ifel(terra::not.na(green), SZA, NA)
    theta_s <- SZA * pi / 180
  } else {
    SZA <- terra::rast(
      nrow = terra::nrow(green), ncol = terra::ncol(green),
      extent = terra::ext(green), crs = terra::crs(green), vals = SZA
    )
    SZA <- terra::ifel(terra::not.na(green), SZA, NA)
    theta_s <- SZA * pi / 180
  }
  if (inherits(VAA, "SpatRaster")) {
    VAA <- terra::ifel(terra::not.na(green), VAA, NA)
    phi_v <- VAA * pi / 180
  } else {
    VAA <- terra::rast(
      nrow = terra::nrow(green), ncol = terra::ncol(green),
      extent = terra::ext(green), crs = terra::crs(green), vals = VAA
    )
    VAA <- terra::ifel(terra::not.na(green), VAA, NA)
    phi_v <- VAA * pi / 180
  }
  if (inherits(VZA, "SpatRaster")) {
    VZA <- terra::ifel(terra::not.na(green), VZA, NA)
    theta_v <- VZA * pi / 180
  } else {
    VZA <- terra::rast(
      nrow = terra::nrow(green), ncol = terra::ncol(green),
      extent = terra::ext(green), crs = terra::crs(green), vals = VZA
    )
    VZA <- terra::ifel(terra::not.na(green), VZA, NA)
    theta_v <- VZA * pi / 180
  }
  if (inherits(slope, "SpatRaster")) {
    slope <- terra::ifel(terra::not.na(green), slope, NA)
    slp <- slope * pi / 180
  } else {
    slope <- terra::rast(
      nrow = terra::nrow(green), ncol = terra::ncol(green),
      extent = terra::ext(green), crs = terra::crs(green), vals = slope
    )
    slope <- terra::ifel(terra::not.na(green), slope, NA)
    slp <- slope * pi / 180
  }
  if (inherits(aspect, "SpatRaster")) {
    aspect <- terra::ifel(terra::not.na(green), aspect, NA)
    asp <- aspect * pi / 180
  } else {
    aspect <- terra::rast(
      nrow = terra::nrow(green), ncol = terra::ncol(green),
      extent = terra::ext(green), crs = terra::crs(green), vals = aspect
    )
    aspect <- terra::ifel(terra::not.na(green), aspect, NA)
    asp <- aspect * pi / 180
  }
  delta_phi <- phi_s - phi_v
  phi_r <- terra::ifel(delta_phi < 0, abs(delta_phi + pi), abs(delta_phi - pi))
  cos_theta_vc <- cos(slp) * cos(theta_v) + sin(slp) * sin(theta_v) * cos(asp - phi_v)
  cos_theta_sc <- cos(slp) * cos(theta_s) + sin(slp) * sin(theta_s) * cos(asp - phi_s)
  theta_vc <- acos(cos_theta_vc)
  theta_sc <- acos(cos_theta_sc)
  green <- terra::ifel(green < 0, NA, green)
  NIR <- terra::ifel(NIR < 0, NA, NIR)
  NDSII <- (green - NIR) / (green + NIR)
  METHODS <- c("twobands", "fivebands")
  method <- pmatch(method, METHODS)
  if (is.na(method)) {
    cli::cli_abort("Invalid method. Please select either 'twobands' or 'fivebands'.")
  } else if (method == 1) {
    green_max <- 1.00
    NIR_max <- 1.00
    SZA_max_ice <- 74.2 * pi / 180
    SZA_max_snow <- 65.51 * pi / 180
    green <- terra::ifel(green > green_max, NA, green)
    NIR <- terra::ifel(NIR > NIR_max, NA, NIR)
    theta_sc <- terra::ifel(
      NDSII > th,
      {
        terra::ifel(theta_sc < SZA_max_ice, theta_sc, NA)
      },
      {
        terra::ifel(theta_sc < SZA_max_snow, theta_sc, NA)
      }
    )
    f <- terra::ifel(
      NDSII > th,
      {
        c1 <- BRDF_parameters_ice_twobands$c1
        c2 <- BRDF_parameters_ice_twobands$c2
        c3 <- BRDF_parameters_ice_twobands$c3
        theta_c <- BRDF_parameters_ice_twobands$theta_c
        f_green <- (c1[1] * (cos_theta_vc - 2.0 / 3.0) + c2[1] * theta_vc^2 * cos(phi_r) +
          c3[1] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[1])
        f_nir <- (c1[2] * (cos_theta_vc - 2.0 / 3.0) + c2[2] * theta_vc^2 * cos(phi_r) +
          c3[2] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[2])
        result <- c(f_green, f_nir)
        names(result) <- c("f_green", "f_NIR")
        result
      },
      {
        a1 <- BRDF_parameters_snow_twobands$a1
        a2 <- BRDF_parameters_snow_twobands$a2
        a3 <- BRDF_parameters_snow_twobands$a3
        epsilon <- 1e-5
        alpha_green <- green
        difference <- green / green
        while (max(terra::values(difference), na.rm = TRUE) > epsilon) {
          alpha_old <- alpha_green
          alpha_green <- terra::ifel(difference < epsilon, alpha_green, {
            b1_green <- a1[1] + a1[2] * alpha_green + a1[3] * theta_sc * 180 / pi
            b2_green <- a2[1] + a2[2] * alpha_green + a2[3] * theta_sc * 180 / pi
            b3_green <- a3[1] + a3[2] * alpha_green + a3[3] * theta_sc * 180 / pi
            f <- 1 + b1_green * (cos_theta_vc - 2.0 / 3.0) + b2_green * theta_vc^2 * cos(phi_r) +
              b3_green * (theta_vc * (cos(phi_r))^2 - pi / 8.0)
            f_green <- terra::ifel(f > 0.727, f, NA)
            green / f_green
          })
          difference <- abs(alpha_green - alpha_old)
        }
        f_green_diff <- green * (1 - 1 / f_green)
        alpha_nir <- NIR
        difference <- NIR / NIR
        while (max(terra::values(difference), na.rm = TRUE) > epsilon) {
          alpha_old <- alpha_nir
          alpha_nir <- terra::ifel(difference < epsilon, alpha_nir, {
            b1_nir <- a1[4] + a1[5] * alpha_nir + a1[6] * theta_sc * 180 / pi
            b2_nir <- a2[4] + a2[5] * alpha_nir + a2[6] * theta_sc * 180 / pi
            b3_nir <- a3[4] + a3[5] * alpha_nir + a3[6] * theta_sc * 180 / pi
            f <- 1 + b1_nir * (cos_theta_vc - 2.0 / 3.0) + b2_nir * theta_vc^2 * cos(phi_r) +
              b3_nir * (theta_vc * (cos(phi_r))^2 - pi / 8.0)
            f_nir <- terra::ifel(f > 0.718, f, NA)
            NIR / f_nir
          })
          difference <- abs(alpha_nir - alpha_old)
        }
        f_nir_diff <- NIR * (1 - 1 / f_nir)
        result <- c(f_green_diff, f_nir_diff)
        names(result) <- c("f_green", "f_NIR")
        result
      }
    )
  } else if (method == 2) {
    SZA_max_ice <- 57.6 * pi / 180
    SZA_max_snow <- 70.9 * pi / 180
    theta_sc <- terra::ifel(
      NDSII > th,
      {
        terra::ifel(theta_sc < SZA_max_ice, theta_sc, NA)
      },
      {
        terra::ifel(theta_sc < SZA_max_snow, theta_sc, NA)
      }
    )
    f <- terra::ifel(
      NDSII > th,
      {
        c1 <- BRDF_parameters_ice_fivebands$c1
        c2 <- BRDF_parameters_ice_fivebands$c2
        c3 <- BRDF_parameters_ice_fivebands$c3
        theta_c <- BRDF_parameters_ice_fivebands$theta_c
        f_blue <- (c1[1] * (cos_theta_vc - 2.0 / 3.0) + c2[1] * theta_vc^2 * cos(phi_r) +
          c3[1] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[1])
        f_red <- (c1[2] * (cos_theta_vc - 2.0 / 3.0) + c2[2] * theta_vc^2 * cos(phi_r) +
          c3[2] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[2])
        f_nir <- (c1[3] * (cos_theta_vc - 2.0 / 3.0) + c2[3] * theta_vc^2 * cos(phi_r) +
          c3[3] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[3])
        f_swir1 <- (c1[4] * (cos_theta_vc - 2.0 / 3.0) + c2[4] * theta_vc^2 * cos(phi_r) +
          c3[4] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[4])
        f_swir2 <- (c1[5] * (cos_theta_vc - 2.0 / 3.0) + c2[5] * theta_vc^2 * cos(phi_r) +
          c3[5] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[5])
        result <- c(f_blue, f_red, f_nir, f_swir1, f_swir2)
        names(result) <- c("f_blue", "f_red", "f_NIR", "f_SWIR1", "f_SWIR2")
        result
      },
      {
        c1 <- BRDF_parameters_snow_fivebands$c1
        c2 <- BRDF_parameters_snow_fivebands$c2
        c3 <- BRDF_parameters_snow_fivebands$c3
        theta_c <- BRDF_parameters_snow_fivebands$theta_c
        f_blue <- (c1[1] * (theta_vc^2 + 1.0 / 2.0 - pi^2 / 8) + c2[1] * theta_vc^2 * cos(phi_r) +
          c3[1] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[1])
        f_red <- (c1[2] * (theta_vc^2 + 1.0 / 2.0 - pi^2 / 8) + c2[2] * theta_vc^2 * cos(phi_r) +
          c3[2] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[2])
        f_nir <- (c1[3] * (theta_vc^2 + 1.0 / 2.0 - pi^2 / 8) + c2[3] * theta_vc^2 * cos(phi_r) +
          c3[3] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[3])
        f_swir1 <- (c1[4] * (theta_vc^2 + 1.0 / 2.0 - pi^2 / 8) + c2[4] * theta_vc^2 * cos(phi_r) +
          c3[4] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[4])
        f_swir2 <- (c1[5] * (theta_vc^2 + 1.0 / 2.0 - pi^2 / 8) + c2[5] * theta_vc^2 * cos(phi_r) +
          c3[5] * (theta_vc^2 * (cos(phi_r))^2 - pi^2 / 16 + 1.0 / 4.0)) * exp(theta_sc / theta_c[5])
        result <- c(f_blue, f_red, f_nir, f_swir1, f_swir2)
        names(result) <- c("f_blue", "f_red", "f_NIR", "f_SWIR1", "f_SWIR2")
        result
      }
    )
  }
}

#' Satellite albedo retrieval
#'
#' This function calculates narrowband and broadband albedo from surface reflectance data. The albedo
#' retrieval method includes corrections for the anisotropic behavior of the reflected radiation field
#' over snow and ice, and narrow-to-broadband albedo conversion algorithms.
#'
#' @importFrom Rdpack reprompt
#'
#' @inheritParams f_BRDF
#' @param method character. Number of spectral bands to calculate broadband albedo.
#'  There are three options available: "twobands" (green and near-infrared), "fourbands"
#'  (blue, green, red, near-infrared), and "fivebands" (blue, red, near-infrared,
#'  shortwave-infrared 1, and shortwave-infrared 2). If `method="twobands"` or
#'  `method="fivebands"`, surface reflectance data is corrected for anisotropy before
#'  generating broadband albedo. In contrast, `method="fourbands"` assumes Lambertian
#'  reflection and converts surface reflectance to broadband albedo directly. More details
#'  and examples about these workflows can be found in the references below.
#'  \insertNoCite{klok_2003,ren_2021,feng_2023a}{SatRbedo}
#' @param blue SpatRaster. Blue band surface reflectance (0.43-0.45 um). Required for
#'  `method="fourbands"` and `method="fivebands"`.
#' @param green SpatRaster. Green band surface reflectance (0.53-0.59 um). Required for
#'  all methods.
#' @param red SpatRaster. Red band surface reflectance (0.64-0.67 um). Required for
#'  `method="fourbands"` and `method="fivebands"`.
#' @param NIR SpatRaster. Near-infrared surface reflectance (0.85-0.88 um). Required for
#'  all methods.
#' @param SWIR1 SpatRaster. Shortwave-infrared surface reflectance (1.57-1.65 um). Required for
#'  `method="fivebands"`.
#' @param SWIR2 SpatRaster. Shortwave-infrared surface reflectance (2.11-2.29 um). Required for
#'  `method="fivebands"`.
#'
#' @section Notes:
#' If `method="fourbands"` is used, it is not necessary to call the following arguments:
#' SAA, SZA, VAA, VZA, slope, aspect, and th.
#'
#' @returns Returns a SpatRaster with four layers for `method="twobands"`, five layers for
#'  `method="fourbands"` and six layers for `method="fivebands"`. These layers are:
#'  * If `method="twobands"`: green and NIR narrowband albedo, broadband albedo, and
#'    quality flags indicating whether broadband albedo was calculated using the corrected
#'    green and NIR narrowband albedos (`flag=1`) or the NIR albedo only (`flag=2`).
#'    Broadband albedo values higher than one are not excluded for this method.
#'  * If `method="fourbands"`: blue, green, red, and NIR surface reflectance and
#'    broadband albedo. Broadband albedo values higher than one and lower than zero are
#'    masked out.
#'  * If `method="fivebands"`: blue, red, NIR, SWIR1, SWIR2 narrowband albedo, and
#'    broadband albedo. Broadband albedo values higher than one and lower than zero are
#'    masked out.
#'
#' @references
#' \insertAllCited{}
#'
#' @seealso [preproc()], [snow_or_ice()], [f_BRDF()], [albedo_Knap()],
#'   [albedo_Liang()], [albedo_Feng()], [terra::terrain()], [terra::plot()]
#'
#' @examples
#' library(terra)
#' outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' blue <- system.file("extdata/athabasca_B02_20200911.tif", package = "SatRbedo")
#' green <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' red <- system.file("extdata/athabasca_B04_20200911.tif", package = "SatRbedo")
#' nir <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo")
#' swir1 <- system.file("extdata/athabasca_B11_20200911.tif", package = "SatRbedo")
#' swir2 <- system.file("extdata/athabasca_B12_20200911.tif", package = "SatRbedo")
#' dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
#' blue <- preproc(grd = blue, outline = outline)
#' green <- preproc(grd = green, outline = outline)
#' red <- preproc(grd = red, outline = outline)
#' nir <- preproc(grd = nir, outline = outline)
#' swir1 <- preproc(grd = swir1, outline = outline)
#' swir2 <- preproc(grd = swir2, outline = outline)
#' dem <- preproc(grd = dem, outline = outline)
#' SAA <- 164.8
#' SZA <- 48.9
#' VAA <- 90.9
#' VZA <- 5.2
#' slope <- terra::terrain(dem, v = "slope", neighbors = 4, unit = "degrees")
#' aspect <- terra::terrain(dem, v = "aspect", neighbors = 4, unit = "degrees")
#'
#' # Broadband albedo using green and near-infrared surface reflectance data
#' th <- snow_or_ice(green, nir)$th
#' alb <- albedo_sat(
#'   SAA = SAA, SZA = SZA, VAA = VAA, VZA = VZA,
#'   slope = slope, aspect = aspect, method = "twobands",
#'   green = green, NIR = nir, th = th
#' )
#' plot(alb[[3]]) # Broadband albedo
#' plot(alb[[4]]) # Flags
#'
#' # Broadband albedo using blue, green, red and near-infrared surface reflectance data
#' alb <- albedo_sat(
#'   method = "fourbands",
#'   blue = blue, green = green, red = red, NIR = nir
#' )
#' plot(alb[[5]]) # Broadband albedo
#'
#' # Broadband albedo using blue, red, near-infrared, and shortwave-infrared surface reflectance data
#' th <- snow_or_ice(green, nir)$th
#' alb <- albedo_sat(
#'   SAA = SAA, SZA = SZA, VAA = VAA, VZA = VZA,
#'   slope = slope, aspect = aspect, method = "fivebands",
#'   blue = blue, green = green, red = red, NIR = nir, SWIR1 = swir1, SWIR2 = swir2, th = th
#' )
#' plot(alb[[6]]) # Broadband albedo
#'
#' @export
albedo_sat <- function(SAA, SZA, VAA, VZA,
                       slope, aspect,
                       method,
                       blue = NULL,
                       green = NULL,
                       red = NULL,
                       NIR = NULL,
                       SWIR1 = NULL,
                       SWIR2 = NULL,
                       th) {
  METHODS <- c("twobands", "fourbands", "fivebands")
  method <- pmatch(method, METHODS)
  if (is.na(method)) {
    cli::cli_abort("Invalid method. Please select: 'twobands', 'fourbands' or 'fivebands'.")
  } else if (method == 1) {
    if (!is.null(green) & !is.null(NIR)) {
      green <- terra::ifel(green < 0, NA, green)
      NIR <- terra::ifel(NIR < 0, NA, NIR)
      f <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect,
        method = "twobands",
        green, NIR, th
      )
      f_green <- f[[1]]
      f_nir <- f[[2]]
      albedo_green <- green - f_green
      albedo_NIR <- NIR - f_nir
      albedo_broad <- terra::ifel(
        albedo_green > 1.0,
        {
          albedo_Knap(green, albedo_NIR, saturated = TRUE)
        },
        {
          albedo_Knap(albedo_green, albedo_NIR, saturated = FALSE)
        }
      )
      flag <- terra::ifel(
        albedo_green > 1.0,
        {
          albedo_NIR / albedo_NIR * 2
        },
        {
          albedo_green / albedo_green * 1
        }
      )
#      albedo_green <- terra::ifel(albedo_green <= 1.0, albedo_green, NA)
#      albedo_NIR <- terra::ifel(albedo_NIR <= 1.0, albedo_NIR, NA)
      result <- c(albedo_green, albedo_NIR, albedo_broad, flag)
      names(result) <- c("albedo_green", "albedo_NIR", "albedo_broad", "flag")
      result
    } else {
      cli::cli_abort("Please make sure that the green and NIR bands have been provided.")
    }
  } else if (method == 2) {
    if (!is.null(blue) & !is.null(green) & !is.null(red) & !is.null(NIR)) {
#      albedo_blue <- terra::ifel(blue < 0 | blue > 1, NA, blue)
#      albedo_green <- terra::ifel(green < 0 | green > 1, NA, green)
#      albedo_red <- terra::ifel(red < 0 | red > 1, NA, red)
#      albedo_NIR <- terra::ifel(NIR < 0 | NIR > 1, NA, NIR)
      albedo_blue <- terra::ifel(blue < 0, NA, blue)
      albedo_green <- terra::ifel(green < 0, NA, green)
      albedo_red <- terra::ifel(red < 0, NA, red)
      albedo_NIR <- terra::ifel(NIR < 0, NA, NIR)
      albedo_broad <- albedo_Feng(albedo_blue, albedo_green, albedo_red, albedo_NIR)
#      albedo_broad <- terra::ifel(albedo_broad <= 1.0, albedo_broad, NA)
      result <- c(albedo_blue, albedo_green, albedo_red, albedo_NIR, albedo_broad)
      names(result) <- c("albedo_blue", "albedo_green", "albedo_red", "albedo_NIR", "albedo_broad")
      result
    } else {
      cli::cli_abort("Please make sure that the blue, green, red, and NIR
	    bands have been provided.")
    }
  } else if (method == 3) {
    if (!is.null(blue) & !is.null(green) & !is.null(red) &
      !is.null(NIR) & !is.null(SWIR1) & !is.null(SWIR2)) {
      blue <- terra::ifel(blue < 0, NA, blue)
      red <- terra::ifel(red < 0, NA, red)
      NIR <- terra::ifel(NIR < 0, NA, NIR)
      SWIR1 <- terra::ifel(SWIR1 < 0, 0, SWIR1)
      SWIR2 <- terra::ifel(SWIR2 < 0, 0, SWIR2)
      f <- f_BRDF(SAA, SZA, VAA, VZA, slope, aspect,
        method = "fivebands",
        green, NIR, th = th
      )
      f_blue <- f[[1]]
      f_red <- f[[2]]
      f_nir <- f[[3]]
      f_swir1 <- f[[4]]
      f_swir2 <- f[[5]]
      albedo_blue <- terra::ifel(blue > 0, blue - f_blue, 0 * f_blue)
      albedo_red <- terra::ifel(red > 0, red - f_red, 0 * f_red)
      albedo_NIR <- terra::ifel(NIR > 0, NIR - f_nir, 0 * f_nir)
      albedo_SWIR1 <- terra::ifel(SWIR1 > 0, SWIR1 - f_swir1, 0 * f_swir1)
      albedo_SWIR2 <- terra::ifel(SWIR2 > 0, SWIR2 - f_swir2, 0 * f_swir2)
      albedo_broad <- albedo_Liang(albedo_blue, albedo_red, albedo_NIR, albedo_SWIR1, albedo_SWIR2)
#      albedo_broad <- terra::ifel(albedo_broad <= 1.0 & albedo_broad >= 0, albedo_broad, NA) 
#      albedo_blue <- terra::ifel(albedo_blue <= 1.0 & albedo_blue > 0, albedo_blue, NA)
#      albedo_red <- terra::ifel(albedo_red <= 1.0 & albedo_red > 0, albedo_red, NA)
#      albedo_NIR <- terra::ifel(albedo_NIR <= 1.0 & albedo_NIR > 0, albedo_NIR, NA)
#      albedo_SWIR1 <- terra::ifel(albedo_SWIR1 <= 1.0 & albedo_SWIR1 > 0, albedo_SWIR1, NA)
#      albedo_SWIR2 <- terra::ifel(albedo_SWIR2 <= 1.0 & albedo_SWIR2 > 0, albedo_SWIR2, NA)
      result <- c(
        albedo_blue, albedo_red, albedo_NIR, albedo_SWIR1,
        albedo_SWIR2, albedo_broad
      )
      names(result) <- c(
        "albedo_blue", "albedo_red", "albedo_NIR", "albedo_SWIR1",
        "albedo_SWIR2", "albedo_broad"
      )
      result
    } else {
      cli::cli_abort("Please make sure that the blue, green, red, NIR,
	      SWIR1, and SWIR2 bands have been provided.")
    }
  }
}

#' Narrow-to-broadband albedo conversion
#'
#' This function converts narrowband to broadband albedo of snow and ice surfaces
#' using the empirical relationships developed by \insertCite{knap_1999;textual}{SatRbedo},
#' \insertCite{liang_2001;textual}{SatRbedo}, and \insertCite{feng_2023b;textual}{SatRbedo}.
#'
#' @importFrom Rdpack reprompt
#'
#' @param albedo_blue SpatRaster. Blue band albedo (0.43-0.45 um).
#' @param albedo_green SpatRaster. Green band albedo (0.53-0.59 um).
#' @param albedo_red SpatRaster. Red band albedo (0.64-0.67 um).
#' @param albedo_NIR SpatRaster. Near-infrared band albedo (0.85-0.88 um).
#' @param albedo_SWIR1 SpatRaster. Shortwave-infrared band albedo (1.57-1.65 um).
#' @param albedo_SWIR2 SpatRaster. Shortwave-infrared band albedo (2.11-2.29 um).
#' @param saturated logical. If `TRUE`, the green band is saturated, and an expression that is
#'  only a function of the near-infrared band is used.
#'
#' @returns broadband albedo (i.e., the albedo integrated over the entire solar spectrum).
#'
#' @references
#' \insertAllCited{}
#'
#' @seealso [preproc()], [albedo_sat()]
#'
#' @examples
#' library(terra)
#' outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
#' blue <- system.file("extdata/athabasca_B02_20200911.tif", package = "SatRbedo")
#' green <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
#' red <- system.file("extdata/athabasca_B04_20200911.tif", package = "SatRbedo")
#' nir <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo")
#' swir1 <- system.file("extdata/athabasca_B11_20200911.tif", package = "SatRbedo")
#' swir2 <- system.file("extdata/athabasca_B12_20200911.tif", package = "SatRbedo")
#' blue <- preproc(blue, outline)
#' green <- preproc(green, outline)
#' red <- preproc(red, outline)
#' nir <- preproc(nir, outline)
#' swir1 <- preproc(swir1, outline)
#' swir2 <- preproc(swir2, outline)
#'
#' # Broadband albedo using Knap et al. (1999)
#' albedo_Knap(green, nir)
#'
#' # Broadband albedo using Liang (2001)
#' albedo_Liang(blue, red, nir, swir1, swir2)
#'
#' # Broadband albedo using Feng et al. (2023)
#' albedo_Feng(blue, green, red, nir)
#'
#' @name albedo_broad
NULL

#' @rdname albedo_broad
#' @export
albedo_Knap <- function(albedo_green, albedo_NIR, saturated = FALSE) {
  if (saturated) {
    return(0.782 * albedo_NIR + 0.148 * albedo_NIR^2)
  }
  0.726 * albedo_green - 0.322 * albedo_green^2 - 0.051 * albedo_NIR + 0.581 * albedo_NIR^2
}

#' @rdname albedo_broad
#' @export
albedo_Liang <- function(albedo_blue, albedo_red, albedo_NIR, albedo_SWIR1, albedo_SWIR2) {
  0.356 * albedo_blue + 0.130 * albedo_red + 0.373 * albedo_NIR + 0.085 * albedo_SWIR1 + 0.072 * albedo_SWIR2 - 0.0018
}

#' @rdname albedo_broad
#' @export
albedo_Feng <- function(albedo_blue, albedo_green, albedo_red, albedo_NIR) {
  0.7963 * albedo_blue + 2.2724 * albedo_green - 3.8252 * albedo_red + 1.4343 * albedo_NIR + 0.2503
}
