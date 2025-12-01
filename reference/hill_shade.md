# Topographic hillshading

Computes the hypothetical illumination of a surface by setting the
position of the sun and calculating the illumination values for each
grid cell of a DEM. The `hill_shade` function is based upon the
vectorial algebra algorithms developed by Corripio (2003) . This
function has been optimized and updated to take advantage of the
infrastructure provided by the `{terra}` package.

## Usage

``` r
hill_shade(dem, SZA, SAA)
```

## Arguments

- dem:

  SpatRaster. Digital elevation model representing terrain elevation on
  a regular grid.

- SZA:

  SpatRaster or numeric. Solar zenith angle in degrees.

- SAA:

  SpatRaster or numeric. Solar azimuth angle in degrees.

## Value

Returns a hillshade map in SpatRaster format.

## References

Corripio JG (2003). “Vectorial algebra algorithms for calculating
terrain parameters from DEMs and solar radiation modelling in
mountainous terrain.” *International Journal of Geographical Information
Science*, **17**(1), 1–23.
[doi:10.1080/713811744](https://doi.org/10.1080/713811744) .

## See also

[`normal_vector()`](https://pabl1t0x.github.io/SatRbedo/reference/normal_vector.md),
[`sun_vector()`](https://pabl1t0x.github.io/SatRbedo/reference/sun_vector.md)

## Examples

``` r
library(terra)
dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
dem <- terra::rast(dem)
SZA <- 49
SAA <- 165
hs <- hill_shade(dem, SZA, SAA)
plot(hs, col = grey(1:100 / 100))

```
