% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/albedo_sat.R
\name{albedo_broad}
\alias{albedo_broad}
\alias{albedo_Knap}
\alias{albedo_Liang}
\alias{albedo_Feng}
\title{Narrow-to-broadband albedo conversion}
\usage{
albedo_Knap(albedo_green, albedo_NIR, saturated = FALSE)

albedo_Liang(albedo_blue, albedo_red, albedo_NIR, albedo_SWIR1, albedo_SWIR2)

albedo_Feng(albedo_blue, albedo_green, albedo_red, albedo_NIR)
}
\arguments{
\item{albedo_green}{SpatRaster. Green band albedo (0.53-0.59 um).}

\item{albedo_NIR}{SpatRaster. Near-infrared band albedo (0.85-0.88 um).}

\item{saturated}{logical. If \code{TRUE}, the green band is saturated, and an expression that is
only a function of the near-infrared band is used.}

\item{albedo_blue}{SpatRaster. Blue band albedo (0.43-0.45 um).}

\item{albedo_red}{SpatRaster. Red band albedo (0.64-0.67 um).}

\item{albedo_SWIR1}{SpatRaster. Shortwave-infrared band albedo (1.57-1.65 um).}

\item{albedo_SWIR2}{SpatRaster. Shortwave-infrared band albedo (2.11-2.29 um).}
}
\value{
broadband albedo (i.e., the albedo integrated over the entire solar spectrum).
}
\description{
This function converts narrowband to broadband albedo of snow and ice surfaces
using the empirical relationships developed by \insertCite{knap_1999;textual}{SatRbedo},
\insertCite{liang_2001;textual}{SatRbedo}, and \insertCite{feng_2023b;textual}{SatRbedo}.
}
\examples{
library(terra)
outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
blue <- system.file("extdata/athabasca_B02_20200911.tif", package = "SatRbedo")
green <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
red <- system.file("extdata/athabasca_B04_20200911.tif", package = "SatRbedo")
nir <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo")
swir1 <- system.file("extdata/athabasca_B11_20200911.tif", package = "SatRbedo")
swir2 <- system.file("extdata/athabasca_B12_20200911.tif", package = "SatRbedo")
blue <- preproc(blue, outline)
green <- preproc(green, outline)
red <- preproc(red, outline)
nir <- preproc(nir, outline)
swir1 <- preproc(swir1, outline)
swir2 <- preproc(swir2, outline)

# Broadband albedo using Knap et al. (1999)
albedo_Knap(green, nir)

# Broadband albedo using Liang (2001)
albedo_Liang(blue, red, nir, swir1, swir2)

# Broadband albedo using Feng et al. (2023)
albedo_Feng(blue, green, red, nir)

}
\references{
\insertAllCited{}
}
\seealso{
\code{\link[=preproc]{preproc()}}, \code{\link[=albedo_sat]{albedo_sat()}}
}
