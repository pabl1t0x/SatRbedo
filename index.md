# SatRbedo

Albedo is a key parameter that controls the energy exchange between the
atmosphere and snow or ice surfaces, playing a crucial role in
estimating glacier melt and mass balance. While commonly measured in the
field with pyranometers, these instruments have limited spatial coverage
due to their footprint. Therefore, remote sensing offers the best option
for deriving snow and ice albedo data and analysing its spatial and
temporal variability. `SatRbedo` is an extensible, well-documented
package for retrieving snow and ice albedo from optical satellite
images, such as
[Landsat](https://www.usgs.gov/landsat-missions/landsat-collection-2-surface-reflectance)
and
[Sentinel-2](https://dataspace.copernicus.eu/explore-data/data-collections/sentinel-data/sentinel-2).
It requires the following input datasets:

- Atmospherically corrected surface reflectance (gridded).
- Satellite (\\\varphi_v\\, \\\theta_v\\) and solar (\\\varphi_s\\,
  \\\theta_s\\) azimuth and zenith angles (numeric or gridded).
- A digital elevation model (DEM) (gridded).
- An outline of the area of interest (shapefile).

The `SatRbedo` package has been designed for researchers, consultants,
and individuals interested in exploring changes in snow and ice albedo.
It includes the following functions:

- [`preproc()`](https://pabl1t0x.github.io/SatRbedo/reference/preproc.md)
  provides tools for image pre-processing, including cropping grids to a
  specified extent, projecting grids with different coordinate systems,
  and converting data from integer to floating point.
- [`cfactor_BRDF()`](https://pabl1t0x.github.io/SatRbedo/reference/cfactor_BRDF.md)
  converts nadir satellite observations to off-nadir values using
  view-angle corrections.
- [`cast_shadows()`](https://pabl1t0x.github.io/SatRbedo/reference/cast_shadows.md),
  [`hill_shade()`](https://pabl1t0x.github.io/SatRbedo/reference/hill_shade.md),
  and
  [`shadow_removal()`](https://pabl1t0x.github.io/SatRbedo/reference/shadow_removal.md)
  detect and mask topographic shadows.
- [`topo_corr()`](https://pabl1t0x.github.io/SatRbedo/reference/topo_corr.md)
  and
  [`topo_splot()`](https://pabl1t0x.github.io/SatRbedo/reference/topo_splot.md)
  provide tools to correct surface reflectance for the effects of
  topography and to visualise the dependency of surface reflectance on
  the illumination condition.
- [`snow_or_ice()`](https://pabl1t0x.github.io/SatRbedo/reference/snow_or_ice.md),
  and
  [`NDSII_hist()`](https://pabl1t0x.github.io/SatRbedo/reference/NDSII_hist.md)
  are used for the automatic discrimination of snow and ice surfaces.
- [`f_BRDF()`](https://pabl1t0x.github.io/SatRbedo/reference/f_BRDF.md)
  performs the anisotropic correction of reflected radiation of glacier
  snow and ice using empirical parameterisations of the bidirectional
  reflectance distribution function (BRDF).
- [`albedo_sat()`](https://pabl1t0x.github.io/SatRbedo/reference/albedo_sat.md)
  calculates narrowband and broadband albedo from surface reflectance
  data. The albedo retrieval methods include corrections for the
  anisotropic behaviour of the reflected radiation field over snow and
  ice, as well as narrow-to-broadband albedo conversion algorithms.
- [`albedo_Knap()`](https://pabl1t0x.github.io/SatRbedo/reference/albedo_broad.md),
  [`albedo_Feng()`](https://pabl1t0x.github.io/SatRbedo/reference/albedo_broad.md),
  and
  [`albedo_Liang()`](https://pabl1t0x.github.io/SatRbedo/reference/albedo_broad.md)
  convert narrowband to broadband albedo.

## Installation

You can install `SatRbedo` with:

``` r
install.packages('SatRbedo', repos = c('https://pabl1t0x.r-universe.dev', 'https://cloud.r-project.org'))
```

## Getting Started

Snow and ice albedo retrieval from satellite imagery is a four-step
workflow that includes image pre-processing, topographic and anisotropic
corrections, and a narrow-to-broadband albedo conversion (Fig. 1).

![Fig. 1 Flowchart of the satellite albedo retrieval
workflow](reference/figures/workflow.png)

Fig. 1 Flowchart of the satellite albedo retrieval workflow

A basic usage example of estimating satellite albedo from Sentinel-2
surface reflectance data can be found
[here](https://pabl1t0x.github.io/SatRbedo/articles/SatRbedo.html).

## Contributing

All contributions are welcomed. See our [Contributing
Guidelines](https://pabl1t0x.github.io/SatRbedo/CONTRIBUTING.md) for
more details.

## Citing

Please cite `SatRbedo` using:

``` R
@Manual{,
  title = {SatRbedo: An R package for retrieving snow and ice albedo from optical satellite imagery},
  author = {Pablo Fuchs and Ruzica Dadic and Shelley MacDonell and Heather Purdie and Brian Anderson and Marwan Katurji},
  year = {2025},
  note = {R package version 1.0.0},
  url = {https://github.com/pabl1t0x/SatRbedo},
}
```

## License

This project is licensed under the terms of the GNU General Public
License v3.0. See [LICENSE](https://pabl1t0x.github.io/LICENSE.md) for
more details.

![](https://www.gnu.org/graphics/gplv3-127x51.png)
