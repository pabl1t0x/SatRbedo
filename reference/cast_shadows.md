# Cast shadows

Calculates cast shadows over a matrix or SpatRaster digital elevation
model (DEM) for a given illumination direction.

## Usage

``` r
cast_shadows(dem, SZA, SAA, dl = 0, sombra = dem)
```

## Arguments

- dem:

  matrix or SpatRaster. Digital elevation model representing terrain
  elevation on a regular grid.

- SZA:

  SpatRaster or numeric. Solar zenith angle in degrees.

- SAA:

  SpatRaster or numeric. Solar azimuth angle in degrees.

- dl:

  numeric. Grid spacing. Not needed if `dem` is SpatRaster.

- sombra:

  Returned matrix or SpatRaster.

## Value

Returns an object of the same class as the input DEM (matrix or
SpatRaster), with values of 0 for cast-shadowed pixels and 1 for
not-shaded pixels.

## Details

`cast_shadows()` calls a fortran routine called `doshade` that scans the
DEM in lines parallel to the sun direction. It compares the projection
of the grid cells on a plane perpendicular to the sun to determine
whether they are exposed to direct solar illumination or shadowed by
neighbor objects, such as mountains. See Corripio (2003) for details.
The `doshade` subroutine was originally written by Javier Corripio and
it was shipped with the `insol` package. This function has been
optimized and updated to take advantage of the infrastructure provided
by the `{terra}` package.

## References

Corripio JG (2003). “Vectorial algebra algorithms for calculating
terrain parameters from DEMs and solar radiation modelling in
mountainous terrain.” *International Journal of Geographical Information
Science*, **17**(1), 1–23.
[doi:10.1080/713811744](https://doi.org/10.1080/713811744) .

## Examples

``` r
library(terra)
dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
dem <- terra::rast(dem)
SZA <- 49
SAA <- 165
cs <- cast_shadows(dem, SZA, SAA)
plot(cs, col = grey(0:1))

```
