# Retrieving snow and ice albedo from Landsat data

This vignette shows how to use Landsat surface reflectance, topographic
data, and glacier outlines to retrieve snow and ice albedo at the
Athabasca Glacier in Canada. We provide the input datasets for 11
September 2020 and guide the user through the processing steps
implemented in `SatRbedo`. It is assumed that users have basic knowledge
of geographic information systems, satellite remote sensing, and
accessing Earth Observation data.

## Input data

Landsat surface reflectance and topographic data for the area of
interest can be downloaded from the USGS
[EarthExplorer](https://earthexplorer.usgs.gov/). Glacier outlines are
available at the [GLIMS](https://www.glims.org/) website.

After downloading the required input data, the grid and shapefiles can
be reprojected to a common coordinate system and resampled to the same
spatial resolution. Finally, they are cropped to the extent of the area
of interest. The
[`preproc()`](https://pabl1t0x.github.io/SatRbedo/reference/preproc.md)
function and the [terra](https://rspatial.org/) package can be used to
perform these tasks.

``` r
library(SatRbedo)
```

This workflow can be applied tor other instruments and sensors, by
specifying the spectral bands in the functions.
