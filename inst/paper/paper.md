---
title: 'SatRbedo: An R package for retrieving snow and ice albedo from optical satellite imagery'
tags:
  - Snow
  - Glacier ice
  - Albedo
  - Remote sensing
  - Optical satellite imagery
authors:
  - name: Pablo Fuchs
    corresponding: true
    orcid: 0000-0002-6042-5620
    affiliation: "1, 2"
  - name: Ruzica Dadic
    orcid: 0000-0003-1303-1896
    affiliation: "3, 4"
  - name: Shelley MacDonell
    orcid: 0000-0001-9641-4547
    affiliation: 1
  - name: Heather Purdie
    orcid: 0000-0002-2723-6908
    affiliation: 1
  - name: Brian Anderson
    affiliation: 4
  - name: Marwan Katurji 
    orcid: 0000-0002-3368-1469
    affiliation: 1
affiliations:
 - name: School of Earth & Environment, University of Canterbury, Christchurch, New Zealand 
   index: 1
 - name: Instituto de Hidráulica e Hidrología, Universidad Mayor de San Andrés, La Paz, Bolivia
   index: 2
 - name: WSL Institute for Snow and Avalanche Research, Davos Dorf, Switzerland
   index: 3
 - name: Antarctic Research Centre, Victoria University, Wellington, New Zealand
   index: 4
date: 10 May 2025
bibliography: paper.bib
---

# Summary

Albedo is a key variable determining the amount of solar radiation absorbed by
snow and ice surfaces. As such, it influences meltwater production, glacier mass
balance, and the energy exchange between the Earth and the atmosphere [@jonsell_spatial_2003;@hock_glacier_2005]. Satellite remote sensing has been widely recognized as the best practical
approach for monitoring and mapping surface albedo across different spatial and temporal scales [@lin_estimating_2022;@urraca_assessing_2023]. Here, we present the `SatRbedo` R package:
an extensible, standalone toolbox for retrieving snow and ice albedo from optical satellite imagery.
The package includes tools for image preprocessing, converting nadir satellite observations to off-nadir values using view-angle corrections, detecting topographic shadows, discriminating snow and ice surfaces, correcting for topographic effects and the anisotropic behavior of reflected radiation of glacier snow
and ice, and converting narrowband to broadband albedo. The toolbox has a modular structure that
allows for changing the implemented routines and provides output that can be used independently
or as input to other functions. `SatRbedo` is designed to work with medium-resolution
satellite data (e.g., Landsat and Sentinel-2), although data from different satellite sensors
can also be used.

# Statement of need

The land surface albedo is an essential climate variable controlling the partitioning of the radiative energy between the surface and the atmosphere [@bojinski_concept_2014;@radeloff_need_2024].
Albedo is the hemispherically integrated reflectance representing the proportion of the incoming solar
radiation reflected from a unit surface area [@budyko_effect_1969;@schaepman-strub_reflectance_2006]. In
the cryosphere, albedo ranges from <0.1 for debris-covered ice to 0.3-0.4 for bare ice to ~0.5 for aged, wet snow to >0.9 for fresh, dry snow [@cuffey_physics_2010].

Snow and ice albedo depend on the inherent optical properties of the surface (including snow grain size
and shape, snowpack thickness, surface roughness, and water and impurity content) and are also influenced by environmental conditions (apparent albedo), including the angular and spectral distribution of solar radiation, topography, the underlying substrate for thin snow cover, and cloud cover
[@warren_optical_2019;@whicker_snicar-adv4_2022].

Broadband albedo can be measured in the field using observations from a pyranometer pair, one looking upward and the other looking downward [@driemel_baseline_2018;@picard_spectral_2020]. Alternatively, albedo can be estimated using a combination of snow/ice properties and radiative transfer models [@flanner_snicar-adv3_2021;@whicker_snicar-adv4_2022] and from satellite remote sensing [@bertoncini_large-area_2022;@fugazza_spatial_2016].

Instrumentation deployed on towers and automatic weather stations can provide high-quality albedo data with high-temporal resolution at a single location. However, the pyranometer footprint limits the spatial extrapolation of the albedo data [@berg_finescale_2020].

Coupled snow radiative transfer and snowpack models can simulate the temporal and spatial evolution of snow optical properties. However, these coupled models are associated with high computational costs and limited spatial resolution [@gaillard_improving_2025]. Also, these models require input data that is often spatially variable and unavailable most of the time.

Remote sensing offers the best option for studying the changes in albedo, accounting for the high variability in space and time [@berg_finescale_2020]. Satellite albedo retrievals typically comprise three steps: (1) atmospheric correction, (2) modeling of the angular reflectance, and (3) narrow-to-broadband albedo conversion [@carlsen_parameterizing_2020;@qu_mapping_2015]. The algorithms for atmospheric correction [@doxani_atmospheric_2023;@vermote_preliminary_2016], modeling of the angular reflectance distribution [@lucht_algorithm_2000;@ren_anisotropy_2021], and narrow-to-broadband albedo conversion
[@knap_narrowband_1999;@li_preliminary_2018;@liang_narrowband_2001] are well-established and validated in a number of case studies. In addition to these steps, satellite image pre-processing and topographic correction are necessary for homogenizing the input data and minimizing the effects of slope and aspect on albedo, respectively.

Several worflows have been proposed to address these processing steps [e.g.,@klok_temporal_2003;@shuai_algorithm_2011]. However, research code supporting their implementation is not always readily available. This paper introduces the `SatRbedo` package, which implements a workflow in R to estimate snow and ice albedo from satellite data.

# Implementation

`SatRbedo` consists of tools that run in a processing pipeline (\autoref{fig:workflow}).

![Flowchart of the satellite albedo retrieval workflow. It includes four processing steps: (1) pre-processing, (2) topographic correction, (3) anisotropic correction, and (4) narrow-to-broadband albedo conversion. The details of the methods are described in the text.\label{fig:workflow}](workflow.png){ width=80% }

First, it takes application-ready surface reflectance data ($\rho_s$) derived from top-of-atmosphere reflectance, satellite ($\varphi_v$, $\theta_v$) and solar ($\varphi_s$, $\theta_s$) azimuth and zenith angles, and an outline of the area of interest (AOI) to perform the following pre-processing steps: (1) crop the satellite grids to a specified extent; (2) convert data from integer to floating point; (3) re-project grids to a common coordinate system; and (4) convert nadir satellite observations to off-nadir values using view-angle corrections based on the c-factor method [@roy_general_2016].

Subsequently, the non-view-angle corrected surface reflectance ($\rho_T$) is corrected for the effects of topography to obtain the equivalent reflectance values over flat terrain ($\rho_H$). Two empirical methods are provided in `SatRbedo`: (1) the rotation model proposed by @tan_improved_2013 and the C-correction model [@teillet_slope-aspect_1982]. These algorithms are suitable for mountain environments with rugged topography and non-Lambertian surface properties and require a digital elevation model (DEM) and the solar azimuth and zenith angles as input data. The two models assume a linear relationship between reflectance and the solar incidence angle on an inclined surface. Additionally, a tool is provided to remove topographic shadows (self and cxast shadows) using the vectorial algebra algorithms proposed by @corripio_vectorial_2003.

The next step accounts for the anisotropic reflection of snow and ice. For a given surface type, the correction is carried out using an empirical model of the Bidirectional Reflectance Distribution Function (BRDF) that depends on the wavelength bands and the view-solar geometry. `SatRbedo` provides two different models: (1) the BRDF models of @koks_anisotropic_2001 for snow and @greuell_anisotropic_1999 for ice when the green and near-infrared (NIR) bands are used, and (2) the parameterizations proposed by @ren_anisotropy_2021 for the combination of the blue, red, NIR, and shortwave-infrared bands. To distinguish between snow and ice surfaces, we need to calculate the Normalized Difference Snow Ice Index
[NDSII,@keshri_aster_2009]. The subsequent discrimination between snow and ice is performed using an automatic threshold selection method based on the Otsu algorithm [@otsu_threshold_1979].

Finally, broadband albedo can be calculated from narrowband albedo using three empirical relationships:
@knap_narrowband_1999, @liang_narrowband_2001, and @feng_remote_2023.

# Future development

It is expected that active development on `SatRbedo` will continue in the future through the incorporation of the newest tools and methods as they become available, as well as through the active participation of the research community through the software repository platform. Developments in progress include a kernel-based semiempirical BRDF model and new snow and snow-free narrow-to-broadband albedo conversion algorithms.

# Acknowledgements

This research was supported by a University of Canterbury Doctoral Scholarship. The authors wish to acknowledge using the `terra` package that provided the raster data handling infrastructure on which `SatRbedo` was built. We also thank Javier Corripi, who wrote the original vectorial algebra algorithms for computing topographic shading on complex terrain.

# References