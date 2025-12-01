# Reflectance-IC scatterplot

This function creates a scatterplot of surface reflectance vs.
illumination condition (IC). The plot can be used to explore the
dependency of the original and the topographically-corrected surface
reflectance data on IC.

## Usage

``` r
topo_splot(IC, band, maxcell = 1e+05)
```

## Arguments

- IC:

  SpatRaster. Illumination condition.

- band:

  SpatRaster. Spectral band to be processed.

- maxcell:

  positive integer. Maximum number of cells to use for the plot

## See also

[`topo_corr()`](https://pabl1t0x.github.io/SatRbedo/reference/topo_corr.md),
[`graphics::abline()`](https://rdrr.io/r/graphics/abline.html),
[`stats::lm()`](https://rdrr.io/r/stats/lm.html)

## Examples

``` r
outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
nir <- system.file("extdata/athabasca_2020253_B8A_S30.tif", package = "SatRbedo")
dem <- system.file("extdata/athabasca_dem.tif", package = "SatRbedo")
nir <- preproc(grd = nir)
dem <- preproc(grd = dem)
SAA <- 164.8
SZA <- 48.9
corr <- topo_corr(band = nir, dem = dem, SAA = SAA, SZA = SZA, method = "tanrotation")
#> Warning: [-] CRS do not match
#> Warning: [rast] CRS do not match

# Scatterplot of IC vs. uncorrected surface reflectance
topo_splot(corr$bands[[1]], nir)
#> Warning: [mask] CRS do not match
#> Warning: [rast] CRS do not match


# Scatterplot of IC vs. topographically-corrected surface reflectance
topo_splot(corr$bands[[1]], corr$bands[[2]])
#> Warning: [mask] CRS do not match
#> Warning: [rast] CRS do not match

```
