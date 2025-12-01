# NDSII histogram

This function creates an NDSII histogram with a vertical line showing
the selected threshold discriminating snow and ice.

## Usage

``` r
NDSII_hist(NDSII, th, breaks = 64, stdev = 2)
```

## Arguments

- NDSII:

  SpatRaster. Normalized Difference Snow Ice Index (NDSII).

- th:

  numeric. NDSII threshold to discriminate between snow and ice.

- breaks:

  one of:

  - a vector giving the breakpoints between histogram cells,

  - a function to compute the vector of breakpoints,

  - a single number giving the number of cells for the histogram,

  - a character string naming an algorithm to compute the number of
    cells (see ‘Details’),

  - a function to compute the number of cells.

  In the last three cases the number is a suggestion only; as the
  breakpoints will be set to
  [`pretty`](https://rdrr.io/r/base/pretty.html) values, the number is
  limited to `1e6` (with a warning if it was larger). If `breaks` is a
  function, the `x` vector is supplied to it as the only argument (and
  the number of breaks is only limited by the amount of available
  memory).

- stdev:

  numeric. Standard deviation cutoff value for histogram stretching.

## See also

[`preproc()`](https://pabl1t0x.github.io/SatRbedo/reference/preproc.md),
[`snow_or_ice()`](https://pabl1t0x.github.io/SatRbedo/reference/snow_or_ice.md),
[`graphics::hist()`](https://rdrr.io/r/graphics/hist.html)

## Examples

``` r
green <- system.file("extdata/athabasca_2020253_B03_S30.tif", package = "SatRbedo")
nir <- system.file("extdata/athabasca_2020253_B8A_S30.tif", package = "SatRbedo")
outline <- system.file("extdata/athabasca_outline.shp", package = "SatRbedo")
green <- preproc(grd = green, outline = outline)
nir <- preproc(grd = nir, outline = outline)
res <- snow_or_ice(green, nir)
NDSII_hist(res$NDSII, res$th, breaks = 16, stdev = 3)

```
