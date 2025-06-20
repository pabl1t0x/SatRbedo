
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SatRbedo

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/pabl1t0x/SatRbedo/branch/master/graph/badge.svg)](https://app.codecov.io/gh/pabl1t0x/SatRbedo/tree/master)
[![status](https://joss.theoj.org/papers/c5899414306d4cf318350654b7aa38fa/status.svg)](https://joss.theoj.org/papers/c5899414306d4cf318350654b7aa38fa)
<!-- badges: end -->

The `SatRbedo` package consists of a set of tools for retrieving snow
and ice albedo from optical satellite imagery (e.g.,
[Landsat](https://www.usgs.gov/landsat-missions/landsat-collection-2-surface-reflectance)
and
[Sentinel-2](https://dataspace.copernicus.eu/explore-data/data-collections/sentinel-data/sentinel-2)).
`SatRbedo` functions require the following datasets:

- Atmospherically corrected surface reflectance (gridded).
- Satellite ($\varphi_v$, $\theta_v$) and solar ($\varphi_s$,
  $\theta_s$) azimuth and zenith angles (numeric or gridded).
- A digital elevation model (DEM) (gridded).
- An outline of the area of interest (shapefile).

The package includes tools for:

- Image pre-processing: crop grids to a specified extent, project grids
  with different coordinate systems, and convert data from integer to
  floating point.
- Convert nadir satellite observations to off-nadir values using
  view-angle corrections.
- Detect and mask topographic shadows.
- Automatic discrimination of snow and ice surfaces.
- Anisotropic correction of reflected radiation of glacier snow and ice
  using empirical parameterizations of the bidirectional reflectance
  distribution function (BRDF).
- Topographic correction.
- Narrow-to-broadband albedo conversion.

## Installation

You can install the development version of SatRbedo from
[GitHub](https://github.com/pabl1t0x/SatRbedo) with:

``` r
# install.packages("devtools")
devtools::install_github("pabl1t0x/SatRbedo")
```

## Getting Started

Snow and ice albedo retrieval from satellite imagery is a four-step
workflow that includes image pre-processing, topographic and anisotropic
corrections, and a narrow-to-broadband albedo conversion (Fig. 1).

<div class="figure">

<img src="inst/paper/workflow.png" alt="Fig. 1 Flowchart of the satellite albedo retrieval workflow" width="80%" />
<p class="caption">

Fig. 1 Flowchart of the satellite albedo retrieval workflow
</p>

</div>

The following example shows how to estimate albedo using surface
reflectance data from five spectral bands at the Athabasca Glacier in
Canada on 11 September 2020.

**Step 1: Load the data for the area of interest**

``` r
# Load the packages
library(SatRbedo)
library(terra)
#> terra 1.8.54

# Load the raw Sentinel-2 surface reflectance data
# Note: each spectral band was previously cut out to the extent of the area of interest and renamed
blue_SR <- system.file("extdata/athabasca_B02_20200911.tif", package = "SatRbedo") # blue band surface reflectance
green_SR <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo") # green band surface reflectance
red_SR <- system.file("extdata/athabasca_B04_20200911.tif", package = "SatRbedo") # red band surface reflectance
NIR_SR <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo") # near-infrared band surface reflectance
SWIR1_SR <- system.file("extdata/athabasca_B11_20200911.tif", package = "SatRbedo") # shortwave-infrared band 1 surface reflectance
SWIR2_SR <- system.file("extdata/athabasca_B12_20200911.tif", package = "SatRbedo") # shortwave-infrared band 2 surface reflectance

# Load the DEM and the outline
# Note: the DEM was re-projected to the extent of the area of interest
dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
```

**Step 2: Data pre-processing**

``` r
# Transform the input data to SpatRaster and crop to the area of interest
dem <- terra::rast(dem)
blue <- preproc(grd = blue_SR, outline = outline)
green <- preproc(grd = green_SR, outline = outline)
red <- preproc(grd = red_SR, outline = outline)
nir <- preproc(grd = NIR_SR, outline = outline)
swir1 <- preproc(grd = SWIR1_SR, outline = outline)
swir2 <- preproc(grd = SWIR2_SR, outline = outline)
```

**Step 3: Topographic correction**

``` r
SAA <- 164.8 # solar azimuth angle
SZA <- 48.9 # solar zenith angle
blue_corr <- topo_corr(blue, dem, SAA, SZA)
green_corr <- topo_corr(green, dem, SAA, SZA)
red_corr <- topo_corr(red, dem, SAA, SZA)
nir_corr <- topo_corr(nir, dem, SAA, SZA)
swir1_corr <- topo_corr(swir1, dem, SAA, SZA)
swir2_corr <- topo_corr(swir2, dem, SAA, SZA)
```

**Step 4: Estimation of broadband albedo after anisotropic correction**

``` r
SAA <- 164.8 # solar azimuth angle
SZA <- 48.9 # solar zenith angle
VAA <- 90.9 # view azimuth angle
VZA <- 5.2 # view zenith angle
slope <- terra::terrain(dem, v = "slope", neighbors = 4, unit = "degrees")
aspect <- terra::terrain(dem, v = "aspect", neighbors = 4, unit = "degrees")
threshold <- snow_or_ice(green, nir)$th # threshold used to discriminate between snow and ice
broadband_albedo <- albedo_sat(
  SAA, SZA, VAA, VZA,
  slope, aspect, method = "fivebands",
  blue = blue_corr$bands[[2]], green = green_corr$bands[[2]], red = red_corr$bands[[2]],
  NIR = nir_corr$bands[[2]], SWIR1 = swir1_corr$bands[[2]], SWIR2 = swir2_corr$bands[[2]],
  th = threshold
)
# Plot the results
plot(broadband_albedo[[6]])
```

<div class="figure">

<img src="man/figures/README-example-anisotropy-1.png" alt="Fig. 2 Broadband albedo" width="80%" />
<p class="caption">

Fig. 2 Broadband albedo
</p>

</div>

## Citing

Please cite `SatRbedo` using:

    @Manual{,
      title = {SatRbedo: An R package for retrieving snow and ice albedo from optical satellite imagery},
      author = {Pablo Fuchs and Ruzica Dadic and Shelley MacDonell and Heather Purdie and Brian Anderson and Marwan Katurji},
      year = {2025},
      note = {R package version 1.0},
      url = {https://github.com/pabl1t0x/SatRbedo},
    }

## License

This project is licensed under the terms of the GNU General Public
License v3.0. See [LICENSE](/LICENSE.md) for more details.

![](https://www.gnu.org/graphics/gplv3-127x51.png)
