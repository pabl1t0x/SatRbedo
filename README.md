
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- knitr::opts_knit$set(global.par = TRUE) -->

# SatRbedo

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/pabl1t0x/SatRbedo/branch/master/graph/badge.svg)](https://app.codecov.io/gh/pabl1t0x/SatRbedo/tree/master)
[![status](https://joss.theoj.org/papers/c5899414306d4cf318350654b7aa38fa/status.svg)](https://joss.theoj.org/papers/c5899414306d4cf318350654b7aa38fa)
<!-- badges: end -->

The `SatRbedo` package consists of a set of tools for retrieving snow
and ice albedo from optical satellite imagery (e.g.,
[Landsat](https://www.usgs.gov/landsat-missions/landsat-collection-2-surface-reflectance)
and
[Sentinel-2](https://dataspace.copernicus.eu/explore-data/data-collections/sentinel-data/sentinel-2)).
`SatRbedo` functions require the following datasets:

- Atmospherically corrected surface reflectance (gridded).
- Satellite ($\varphi_v$, $\theta_v$) and solar ($\varphi_s$,
  $\theta_s$) azimuth and zenith angles (numeric or gridded).
- A digital elevation model (DEM) (gridded).
- An outline of the area of interest (shapefile).

The package includes tools for:

- Image pre-processing: crop grids to a specified extent, project grids
  with different coordinate systems, and convert data from integer to
  floating point.
- Convert nadir satellite observations to off-nadir values using
  view-angle corrections.
- Detect and mask topographic shadows.
- Automatic discrimination of snow and ice surfaces.
- Anisotropic correction of reflected radiation of glacier snow and ice
  using empirical parameterizations of the bidirectional reflectance
  distribution function (BRDF).
- Topographic correction.
- Narrow-to-broadband albedo conversion.

## Installation

You can install `SatRbedo` with:

<!-- # install.packages("devtools") -->

<!-- devtools::install_github("pabl1t0x/SatRbedo") -->

``` r
install.packages('SatRbedo', repos = c('https://pabl1t0x.r-universe.dev', 'https://cloud.r-project.org'))
```

## Getting Started

Snow and ice albedo retrieval from satellite imagery is a four-step
workflow that includes image pre-processing, topographic and anisotropic
corrections, and a narrow-to-broadband albedo conversion (Fig. 1).

<div class="figure">

<img src="man/figures/workflow.png" alt="Fig. 1 Flowchart of the satellite albedo retrieval workflow" width="80%" />
<p class="caption">

Fig. 1 Flowchart of the satellite albedo retrieval workflow
</p>

</div>

A basic usage example of estimating satellite albedo from Sentinel-2
surface reflectance data can be found
[here](https://pabl1t0x.github.io/SatRbedo/articles/SatRbedo.html).

## Contributing

All contributions are welcomed. See our [Contributing
Guidelines](CONTRIBUTING.md) for more details.

## Citing

Please cite `SatRbedo` using:

    @Manual{,
      title = {SatRbedo: An R package for retrieving snow and ice albedo from optical satellite imagery},
      author = {Pablo Fuchs and Ruzica Dadic and Shelley MacDonell and Heather Purdie and Brian Anderson and Marwan Katurji},
      year = {2025},
      note = {R package version 1.0},
      url = {https://github.com/pabl1t0x/SatRbedo},
    }

## License

This project is licensed under the terms of the GNU General Public
License v3.0. See [LICENSE](/LICENSE.md) for more details.

![](https://www.gnu.org/graphics/gplv3-127x51.png)
