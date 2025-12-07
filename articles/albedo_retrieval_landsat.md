# Retrieving snow and ice albedo from Landsat data

This vignette shows how to use Landsat surface reflectance, topographic
data, and glacier outlines to retrieve snow and ice albedo at the
Athabasca Glacier in Canada. We provide the input datasets for 16 August
2020 and guide the user through the processing steps implemented in
`SatRbedo`. It is assumed that users have basic knowledge of geographic
information systems, satellite remote sensing, and accessing Earth
Observation data.

## Load the required packages

First, we load the `SatRbedo` and [terra](https://rspatial.org/)
packages. The latter is used for spatial data manipulation,
visualization, and analysis.

``` r
library(SatRbedo)
library(terra)
```

## Input data

Landsat surface reflectance (Landsat Collection 2 Level-2) and
topographic (e.g., SRTM) data for the area of interest can be downloaded
from the USGS [EarthExplorer](https://earthexplorer.usgs.gov/). Glacier
outlines are available on the [GLIMS](https://www.glims.org/) website.

The `SatRbedo` package provides functions to calculate albedo using two
(green and near-infrared), four (blue, green, red, and near-infrared),
and five (blue, red, near-infrared, shortwave-infrared 1, and
shortwave-infrared 2) spectral bands. These functions also require the
solar and view angles. To generate these angles, the [Landsat Angles
Creation
Tools](https://www.usgs.gov/landsat-missions/solar-illumination-and-sensor-viewing-angle-coefficient-files)
can be used.

After downloading the necessary input data, reproject the digital
elevation model (DEM) grid and the glacier outline shapefile to
Landsat’s coordinate system, then resample them to 30 m spatial
resolution. Crop the DEM, spectral surface reflectance, and angle bands
to the area of interest. The tasks can be performed using the
[`preproc()`](https://pabl1t0x.github.io/SatRbedo/reference/preproc.md)
function and the [terra](https://rspatial.org/) package.

This workflow can be applied tor other instruments and sensors, by
specifying the spectral bands in the functions.
