# Topographic shadows

Detects and removes self-shadowed pixels (i.e., pixels having aspect
angles oriented away from the sun) and cast shadows (i.e, pixels facing
towards the direction of the sun but where sunlight is blocked by
neighbor topographic features such as mountains). Self-shadowed pixels
are detected when the angle between the sun and the vector normal to the
grid cell's surface is higher than \\\frac{\pi}{2}\\. Cast shadows are
calculated using the
[`cast_shadows()`](https://pabl1t0x.github.io/SatRbedo/reference/cast_shadows.md)
function.

## Usage

``` r
shadow_removal(dem, SZA, SAA, mask = TRUE)
```

## Arguments

- dem:

  SpatRaster. Digital elevation model representing terrain elevation on
  a regular grid.

- SZA:

  SpatRaster or numeric. Solar zenith angle in degrees.

- SAA:

  SpatRaster or numeric. Solar azimuth angle in degrees.

- mask:

  logical. If `TRUE`, shadow pixels are masked.

## Value

Returns a SpatRaster with topographic shadows removed.

## See also

[`cast_shadows()`](https://pabl1t0x.github.io/SatRbedo/reference/cast_shadows.md),
[`hill_shade()`](https://pabl1t0x.github.io/SatRbedo/reference/hill_shade.md)

## Examples

``` r
library(terra)
dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
dem <- terra::rast(dem)
SZA <- 49
SAA <- 165
msk <- shadow_removal(dem, SZA, SAA, mask = TRUE)
plot(msk, col = "blue")


# Overlay an RGB composite with the shadow masks
blue <- preproc(system.file("extdata/athabasca_2020253_B02_S30.tif", package = "SatRbedo"))
green <- preproc(system.file("extdata/athabasca_2020253_B03_S30.tif", package = "SatRbedo"))
red <- preproc(system.file("extdata/athabasca_2020253_B04_S30.tif", package = "SatRbedo"))
r <- c(stretch(blue), stretch(green), stretch(red))
RGB(r) <- c(3, 2, 1)
plot(r)
msk <- shadow_removal(dem, SZA, SAA, mask = FALSE)
plot(msk, col = grey(0:1), alpha = 0.2, add = TRUE)

```
