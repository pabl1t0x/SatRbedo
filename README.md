
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SatRbedo

<!-- badges: start -->

[![licence](https://img.shields.io/badge/Licence-GPL--3-blue.svg)](https://www.r-project.org/Licenses/GPL-3)
[![Codecov test
coverage](https://codecov.io/gh/pabl1t0x/SatRbedo/graph/badge.svg)](https://app.codecov.io/gh/pabl1t0x/SatRbedo)
[![R-CMD-check](https://github.com/pabl1t0x/SatRbedo/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pabl1t0x/SatRbedo/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `SatRbedo` package consists of a set of tools for retrieving snow
and ice albedo from optical satellite imagery (e.g., Landsat and
Sentinel-2). `SatRbedo` functions require the following datasets:
- Atmospherically corrected surface reflectance.
- A digital elevation model (DEM).
- Satellite ($\varphi_v$, $\theta_v$) and solar
($\varphi_s$, $\theta_s$) azimuth and zenith angles.
The package
includes tools for: image pre-processing (crop grids to a specified
extent, project grids with different coordinate systems, and convert
data from integer to floating point); convert nadir satellite
observations to off-nadir values using view-angle corrections; detect
and mask topographic shadows; automatic discrimination of snow and ice
surfaces; anisotropic correction of reflected radiation of glacier snow
and ice using empirical parameterizations of the bidirectional
reflectance distribution function (BRDF); topographic correction; and
narrow-to-broadband albedo conversion.

## Installation

You can install the development version of SatRbedo from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("pabl1t0x/SatRbedo")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(SatRbedo)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
