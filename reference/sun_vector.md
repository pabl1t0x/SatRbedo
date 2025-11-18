# Solar vector

Computes a unit vector in the direction of the sun based on the solar
azimuth and zenith angles.

## Usage

``` r
sun_vector(zenith, azimuth)
```

## Arguments

- zenith:

  SpatRaster or numeric. Solar zenith angle in degrees.

- azimuth:

  SpatRaster or numeric. Solar azimuth angle in degrees.

## Details

Given the spherical coordinates (radius = 1, zenith, and azimuth
angles), the `sun_vector()` function gives the (x, y, z) coordinates of
a unit normal vector pointing towards the sun, where the X-axis is
positive eastwards, the Y-axis is positive southwards, and Z along the
Earth radius and positive upwards (Corripio 2003) .

## References

Corripio JG (2003). “Vectorial algebra algorithms for calculating
terrain parameters from DEMs and solar radiation modelling in
mountainous terrain.” *International Journal of Geographical Information
Science*, **17**(1), 1–23.
[doi:10.1080/713811744](https://doi.org/10.1080/713811744) .
