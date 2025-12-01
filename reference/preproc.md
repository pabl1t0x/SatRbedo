# Satellite data pre-processing

`preproc()` crops an input grid to a specified extent with a polygon or
SpatExtent, reprojects the grid to a specified coordinate system, and
converts the data from integer to floating point using an offset and a
scale factor.

## Usage

``` r
preproc(
  grd,
  drivers = NULL,
  outline = NULL,
  coords = NULL,
  add_offset = 0,
  scale_factor = 1
)
```

## Arguments

- grd:

  filename (character) or SpatRaster of the raster to be processed, in
  one of GDAL's raster
  [drivers](https://gdal.org/en/stable/drivers/raster/index.html).

- drivers:

  character. GDAL drivers to consider

- outline:

  filename (character) of the shapefile containing the outline of the
  area of interest, in `.shp` format, or SpatExtent giving a vector of
  length four (xmin, xmax, ymin, ymax).

- coords:

  filename (character) or SpatRaster of the raster with the coordinate
  system definition. Alternatively, a coordinate reference system (CRS)
  description can be provided. In this case, the CRS can be described
  using the PROJ-string (e.g., "+proj=longlat +datum=WGS84") or the WKT
  format (e.g., "EPSG:4326").

- add_offset:

  band-specific offset added to each grid value. Defaults to zero.

- scale_factor:

  band-specific scale factor applied to each grid value. Defaults to
  one.

## Value

Returns a pre-processed SpatRaster grid.

## See also

[`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html),
[`terra::ext()`](https://rspatial.github.io/terra/reference/ext.html),
and
[`terra::project()`](https://rspatial.github.io/terra/reference/project.html)
which this function wraps.

## Examples

``` r
# uncorrected grid
f <- system.file("extdata/athabasca_2020253_B03_S30.tif", package = "SatRbedo")
preproc(grd = f)
#> class       : SpatRaster 
#> size        : 205, 215, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 477870, 484320, 5778330, 5784480  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 11N (EPSG:32611) 
#> source(s)   : memory
#> varname     : athabasca_2020253_B03_S30 
#> name        :   Green 
#> min value   : -0.0701 
#> max value   :  1.3828 

# crop grid
g <- system.file("extdata/athabasca_2020253_B03_S30.tif", package = "SatRbedo")
v <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
preproc(grd = g, outline = v)
#> class       : SpatRaster 
#> size        : 205, 214, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 477870, 484290, 5778330, 5784480  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 11N (EPSG:32611) 
#> source(s)   : memory
#> varname     : athabasca_2020253_B03_S30 
#> name        :   Green 
#> min value   : -0.0414 
#> max value   :  1.2874 

# crop and reproject grid
g <- system.file("extdata/athabasca_2020253_B03_S30.tif", package = "SatRbedo")
v <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
preproc(grd = g, outline = v, coords = "+proj=longlat +datum=WGS84")
#> class       : SpatRaster 
#> size        : 151, 256, 1  (nrow, ncol, nlyr)
#> resolution  : 0.0003683312, 0.0003683312  (x, y)
#> extent      : -117.3239, -117.2296, 52.15492, 52.21054  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=longlat +datum=WGS84 +no_defs 
#> source(s)   : memory
#> name        :      Green 
#> min value   : -0.0335326 
#> max value   :  1.2748423 

preproc(grd = g, outline = v, coords = "EPSG:4326")
#> class       : SpatRaster 
#> size        : 151, 256, 1  (nrow, ncol, nlyr)
#> resolution  : 0.0003683312, 0.0003683312  (x, y)
#> extent      : -117.3239, -117.2296, 52.15492, 52.21054  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 (EPSG:4326) 
#> source(s)   : memory
#> name        :      Green 
#> min value   : -0.0335326 
#> max value   :  1.2748423 

# Transform grid values
library(terra)
g <- system.file("extdata/athabasca_2020253_B03_S30.tif", package = "SatRbedo")
orig <- preproc(grd = g)
minmax(orig)
#>       Green
#> min -0.0701
#> max  1.3828
new <- preproc(grd = g, add_offset = 5, scale_factor = 10)
minmax(new)
#>      Green
#> min  4.299
#> max 18.828
```
