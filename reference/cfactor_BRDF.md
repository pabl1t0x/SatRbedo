# c-factor BRDF normalization

Calculates the c-factor proposed by Roy et al. (2016) which can be used
to normalize surface reflectance data to nadir BRDF adjusted reflectance
(NBAR), or to convert NBAR observations to off-nadir surface
reflectance. The c-factor is calculated based on a spectral kernel-based
BRDF model. The mathematical formulation of the kernels is presented in
Wanner et al. (1995), Lucht et al. (2000) and Carlsen et al. (2020) .

## Usage

``` r
cfactor_BRDF(SAA, SZA, VAA, VZA, NSZ, br = 1, hb = 2, band)
```

## Arguments

- SAA:

  SpatRaster or numeric. Solar azimuth angle in degrees.

- SZA:

  SpatRaster or numeric. Solar zenith angle in degrees.

- VAA:

  SpatRaster or numeric. Satellite sensor azimuth angle in degrees.

- VZA:

  SpatRaster or numeric. Satellite sensor zenith angle in degrees.

- NSZ:

  numeric. NBAR solar zenith angle. This prescribed `NSZ` is obtained
  from the satellite product metadata or calculated using the algorithm
  and code provided by Li et al. (2019) .

- br:

  numeric. Crown relative height parameter. Defaults to 1.0.

- hb:

  numeric. Shape parameter. Defaults to 2.0.

- band:

  character. Spectral band to be processed. There are six bands that can
  be considered: "blue (0.43-0.45 um)", "green (0.53-0.59 u)", "red
  (0.64-0.67 um)", "NIR" (near-infrared, 0.85-0.88 um), "SWIR"
  (shortwave-infrared, 1.57-1.65 um), and "SWIR2 (shortwave-infrared,
  2.11-2.29 um)".

## Value

Returns a single numeric value or a SpatRaster with the c-factor values
for a spectral band.

## References

Carlsen T, Birnbaum G, Ehrlich A, Helm V, Jäkel E, Schäfer M, Wendisch M
(2020). “Parameterizing anisotropic reflectance of snow surfaces from
airborne digital camera observations in Antarctica.” *The Cryosphere*,
**14**(11), 3959–3978.
[doi:10.5194/tc-14-3959-2020](https://doi.org/10.5194/tc-14-3959-2020)
.  
  
Li Z, Zhang HK, Roy DP (2019). “Investigation of Sentinel-2
Bidirectional Reflectance Hot-Spot Sensing Conditions.” *IEEE
Transactions on Geoscience and Remote Sensing*, **57**(6), 3591–3598.
[doi:10.1109/TGRS.2018.2885967](https://doi.org/10.1109/TGRS.2018.2885967)
.  
  
Lucht W, Schaaf CB, Strahler AH (2000). “An algorithm for the retrieval
of albedo from space using semiempirical BRDF models.” *IEEE
Transactions on Geoscience and Remote Sensing*, **38**(2), 977–998.
[doi:10.1109/36.841980](https://doi.org/10.1109/36.841980) .  
  
Roy DP, Zhang HK, Ju J, Gomez-Dans JL, Lewis PE, Schaaf CB, Sun Q, Li J,
Huang H, Kovalskyy V (2016). “A general method to normalize Landsat
reflectance data to nadir BRDF adjusted reflectance.” *Remote Sensing of
Environment*, **176**, 255–271.
[doi:10.1016/j.rse.2016.01.023](https://doi.org/10.1016/j.rse.2016.01.023)
.  
  
Wanner W, Li X, Strahler AH (1995). “On the derivation of kernels for
kernel-driven models of bidirectional reflectance.” *Journal of
Geophysical Research*, **100**(D10), 21077.
[doi:10.1029/95JD02371](https://doi.org/10.1029/95JD02371) .

## Examples

``` r
# Using data with numeric format
cfactor_BRDF(SAA = 56.58, SZA = 35.6, VAA = 236.4, VZA = 1.00, NSZ = 34.97, band = "NIR")
#> [1] 0.9966411

# Using SpatRaster data
library(terra)
m1 <- matrix(seq(from = 56.54, to = 56.67, length.out = 9), nrow = 3, ncol = 3)
m2 <- matrix(seq(from = 35.54, to = 35.65, length.out = 9), nrow = 3, ncol = 3)
m3 <- matrix(seq(from = 221.05, to = 259.06, length.out = 9), nrow = 3, ncol = 3)
m4 <- matrix(seq(from = 0.53, to = 1.12, length.out = 9), nrow = 3, ncol = 3)
SAA <- terra::rast(m1)
SZA <- terra::rast(m2)
VAA <- terra::rast(m3)
VZA <- terra::rast(m4)
cfactor_BRDF(SAA, SZA, VAA, VZA, NSZ = 34.97, band = "NIR")
#> class       : SpatRaster 
#> size        : 3, 3, 1  (nrow, ncol, nlyr)
#> resolution  : 1, 1  (x, y)
#> extent      : 0, 3, 0, 3  (xmin, xmax, ymin, ymax)
#> coord. ref. :  
#> source(s)   : memory
#> name        :     lyr.1 
#> min value   : 0.9966314 
#> max value   : 0.9992424 
```
