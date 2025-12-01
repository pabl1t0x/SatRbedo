# Narrow-to-broadband albedo conversion

This function converts narrowband to broadband albedo of snow and ice
surfaces using the empirical relationships developed by Knap et al.
(1999) , Liang (2001) , and Feng et al. (2023) .

## Usage

``` r
albedo_Knap(albedo_green, albedo_NIR, saturated = FALSE)

albedo_Liang(albedo_blue, albedo_red, albedo_NIR, albedo_SWIR1, albedo_SWIR2)

albedo_Feng(albedo_blue, albedo_green, albedo_red, albedo_NIR)
```

## Arguments

- albedo_green:

  SpatRaster. Green band albedo (0.53-0.59 um).

- albedo_NIR:

  SpatRaster. Near-infrared band albedo (0.85-0.88 um).

- saturated:

  logical. If `TRUE`, the green band is saturated, and an expression
  that is only a function of the near-infrared band is used.

- albedo_blue:

  SpatRaster. Blue band albedo (0.43-0.45 um).

- albedo_red:

  SpatRaster. Red band albedo (0.64-0.67 um).

- albedo_SWIR1:

  SpatRaster. Shortwave-infrared band albedo (1.57-1.65 um).

- albedo_SWIR2:

  SpatRaster. Shortwave-infrared band albedo (2.11-2.29 um).

## Value

broadband albedo (i.e., the albedo integrated over the entire solar
spectrum).

## References

Feng S, Cook JM, Onuma Y, Naegeli K, Tan W, Anesio AM, Benning LG,
Tranter M (2023). “Remote sensing of ice albedo using harmonized Landsat
and Sentinel 2 datasets: validation.” *International Journal of Remote
Sensing*, 1–29.
[doi:10.1080/01431161.2023.2291000](https://doi.org/10.1080/01431161.2023.2291000)
.  
  
Knap WH, Reijmer CH, Oerlemans J (1999). “Narrowband to broadband
conversion of Landsat TM glacier albedos.” *International Journal of
Remote Sensing*, **20**(10), 2091–2110.
[doi:10.1080/014311699212362](https://doi.org/10.1080/014311699212362)
.  
  
Liang S (2001). “Narrowband to broadband conversions of land surface
albedo I: Algorithms.” *Remote Sensing of Environment*, **76**(2),
213–238.
[doi:10.1016/S0034-4257(00)00205-4](https://doi.org/10.1016/S0034-4257%2800%2900205-4)
.

## See also

[`preproc()`](https://pabl1t0x.github.io/SatRbedo/reference/preproc.md),
[`albedo_sat()`](https://pabl1t0x.github.io/SatRbedo/reference/albedo_sat.md)

## Examples

``` r
library(terra)
#> terra 1.8.80
outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
blue <- system.file("extdata/athabasca_2020253_B02_S30.tif", package = "SatRbedo")
green <- system.file("extdata/athabasca_2020253_B03_S30.tif", package = "SatRbedo")
red <- system.file("extdata/athabasca_2020253_B04_S30.tif", package = "SatRbedo")
nir <- system.file("extdata/athabasca_2020253_B8A_S30.tif", package = "SatRbedo")
swir1 <- system.file("extdata/athabasca_2020253_B11_S30.tif", package = "SatRbedo")
swir2 <- system.file("extdata/athabasca_2020253_B12_S30.tif", package = "SatRbedo")
blue <- preproc(blue, outline)
green <- preproc(green, outline)
red <- preproc(red, outline)
nir <- preproc(nir, outline)
swir1 <- preproc(swir1, outline)
swir2 <- preproc(swir2, outline)

# Broadband albedo using Knap et al. (1999)
albedo_Knap(green, nir)
#> class       : SpatRaster 
#> size        : 205, 215, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 477870, 484320, 5778330, 5784480  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 11N (EPSG:32611) 
#> source(s)   : memory
#> varname     : athabasca_2020253_B03_S30 
#> name        :       Green 
#> min value   : -0.04773838 
#> max value   :  1.16060598 

# Broadband albedo using Liang (2001)
albedo_Liang(blue, red, nir, swir1, swir2)
#> class       : SpatRaster 
#> size        : 205, 215, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 477870, 484320, 5778330, 5784480  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 11N (EPSG:32611) 
#> source(s)   : memory
#> varname     : athabasca_2020253_B02_S30 
#> name        :       Blue 
#> min value   : -0.0598207 
#> max value   :  1.0845899 

# Broadband albedo using Feng et al. (2023)
albedo_Feng(blue, green, red, nir)
#> class       : SpatRaster 
#> size        : 205, 215, 1  (nrow, ncol, nlyr)
#> resolution  : 30, 30  (x, y)
#> extent      : 477870, 484320, 5778330, 5784480  (xmin, xmax, ymin, ymax)
#> coord. ref. : WGS 84 / UTM zone 11N (EPSG:32611) 
#> source(s)   : memory
#> varname     : athabasca_2020253_B02_S30 
#> name        :      Blue 
#> min value   : 0.1514815 
#> max value   : 0.8585487 
```
