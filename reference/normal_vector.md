# Unit normal vector of a surface

Computes a unit vector normal to each grid cell in a digital elevation
model.

## Usage

``` r
normal_vector(dem, dlx = 0, dly = dlx, cArea = FALSE)
```

## Arguments

- dem:

  matrix or SpatRaster. Digital elevation model representing terrain
  elevation on a regular grid.

- dlx:

  numeric. Spatial resolution along the `x` axis in meters.

- dly:

  numeric. Spatial resolution along the `y` axis in meters.

- cArea:

  logical. If `TRUE`, returns the surface area of each grid cell. The
  default returns the gradient.

## Value

Returns a 3D array with the same number of rows and columns as the DEM
and the three layers in the third dimension corresponding to the (x, y,
z) components of the normal vectors to each of the grid cells. If cArea
is `TRUE`, the result is a 2D matrix with the surface area of each grid
cell.

## Details

Mathematically, a vector normal to an inclined surface, which is
represented by a plane enclosed by four data points (see Fig. 1 of
Corripio 2003) , is defined as the average of the cross products of the
vectors along the sides of the grid cell. By definition, the length of
this vector is equal to the surface area of the grid cell. This function
was originally written by Javier Corripio as part of the `insol`
package. The function has been optimized and updated to take advantage
of the infrastructure provided by the `terra` package.

## References

Corripio JG (2003). “Vectorial algebra algorithms for calculating
terrain parameters from DEMs and solar radiation modelling in
mountainous terrain.” *International Journal of Geographical Information
Science*, **17**(1), 1–23.
[doi:10.1080/713811744](https://doi.org/10.1080/713811744) .
