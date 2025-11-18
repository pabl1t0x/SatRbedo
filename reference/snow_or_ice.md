# Automatic discrimination of snow and ice cover types

Calculates the Normalized Difference Snow Ice Index (NDSII) (Keshri et
al. 2009) to discriminate between snow and ice surfaces. The
discrimination is performed using an automatic threshold selection
method based on the Otsu algorithm (Otsu 1979) .

## Usage

``` r
snow_or_ice(green, NIR)
```

## Arguments

- green:

  SpatRaster. Green band surface reflectance (0.53-0.59 um).

- NIR:

  SpatRaster. Near-infrared band surface reflectance (0.85-0.88 um).

## Value

Returns a list with two objects. The first component is an NDSII
SpatRaster and the second component provides the optimal threshold to
discriminate between snow and ice surfaces.

## References

Keshri AK, Shukla A, Gupta RP (2009). “ASTER ratio indices for
supraglacial terrain mapping.” *International Journal of Remote
Sensing*, **30**(2), 519–524.
[doi:10.1080/01431160802385459](https://doi.org/10.1080/01431160802385459)
.  
  
Otsu N (1979). “A Threshold Selection Method from Gray-Level
Histograms.” *IEEE Transactions on Systems, Man, and Cybernetics*,
**9**(1), 62–66.
[doi:10.1109/TSMC.1979.4310076](https://doi.org/10.1109/TSMC.1979.4310076)
.

## See also

[`preproc()`](https://pabl1t0x.github.io/SatRbedo/reference/preproc.md),
[`EBImage::otsu()`](https://rdrr.io/pkg/EBImage/man/otsu.html),
[`terra::plot()`](https://rspatial.github.io/terra/reference/plot.html)

## Examples

``` r
green <- system.file("extdata/athabasca_B03_20200911.tif", package = "SatRbedo")
nir <- system.file("extdata/athabasca_B8A_20200911.tif", package = "SatRbedo")
outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
green <- preproc(grd = green, outline = outline)
nir <- preproc(grd = nir, outline = outline)
res <- snow_or_ice(green, nir)

# Plot NDSII
library(terra)
plot(res$NDSII, range = c(-0.5, 0.5))


# Plot a cover type binary map (snow/ice)
library(terra)
plot(res$NDSII > res$th, type = "classes", col = c("#FFFFC8", "#00407F"), levels = c("snow", "ice"))

```
