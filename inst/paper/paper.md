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
    affiliation: 1
  - name: Ruzica Dadic
    orcid: 0000-0003-1303-1896
    affiliation: "2, 3"
  - name: Shelley MacDonell
    orcid: 0000-0001-9641-4547
    affiliation: 1
  - name: Heather Purdie
    orcid: 0000-0002-2723-6908
    affiliation: 1
  - name: Brian Anderson
    affiliation: 3
  - name: Marwan Katurji 
    orcid: 0000-0002-3368-1469
    affiliation: 1
affiliations:
 - name: School of Earth & Environment, University of Canterbury, Christchurch, New Zealand 
   index: 1
 - name: WSL Institute for Snow and Avalanche Research, Davos Dorf, Switzerland
   index: 2
 - name: Antarctic Research Centre, Victoria University, Wellington, New Zealand
   index: 3
date: 12 June 2025
bibliography: paper.bib
---

# Summary

Albedo is a key variable determining the amount of solar radiation absorbed by
snow and ice surfaces. As such, it influences meltwater production, glacier mass
balance, and the energy exchange between the Earth and the atmosphere [@jonsell_spatial_2003;@hock_glacier_2005]. Satellite remote sensing has been widely recognized as the best practical
approach for monitoring and mapping surface albedo across different spatial and temporal scales [@lin_estimating_2022;@urraca_assessing_2023]. Here, we present the `SatRbedo` R package:
an extensible, standalone toolbox for retrieving snow and ice albedo from optical satellite imagery.
The package includes functions for image preprocessing, converting nadir satellite observations to off-nadir values using view-angle corrections, detecting topographic shadows, discriminating snow and ice surfaces, correcting for topographic effects and the anisotropic behavior of reflected radiation of glacier snow and ice, and converting narrowband to broadband albedo. The package has a modular structure that allows for changing the implemented routines and provides output that can be used independently
or as input to other functions. `SatRbedo` is designed to work with medium-resolution satellite data
(e.g., Landsat and Sentinel-2), although data from different satellite sensors can also be used.

# Statement of need

The land surface albedo is an essential climate variable that controls the partitioning of radiative energy between the surface and the atmosphere [@bojinski_concept_2014;@radeloff_need_2024].
Albedo is the hemispherically integrated reflectance representing the proportion of the incoming solar
radiation reflected from a unit surface area [@budyko_effect_1969;@schaepman-strub_reflectance_2006]. In
the cryosphere, albedo ranges from <0.1 for debris-covered ice to 0.3-0.4 for bare ice to ~0.5 for aged, wet snow to >0.9 for fresh, dry snow [@cuffey_physics_2010].

Snow and ice albedo depend on the inherent optical properties of the surface (including snow grain size
and shape, snowpack thickness, surface roughness, and water and impurity content) and are also influenced by environmental conditions (apparent albedo), including the angular and spectral distribution of solar radiation, topography, the underlying substrate for thin snow cover, and cloud cover
[@warren_optical_2019;@whicker_snicar-adv4_2022].

Broadband albedo can be measured in the field using observations from a pyranometer pair, one looking upward and the other looking downward [@driemel_baseline_2018;@picard_spectral_2020]. Alternatively, albedo can be estimated using a combination of snow/ice properties and radiative transfer models [@flanner_snicar-adv3_2021;@whicker_snicar-adv4_2022] and from satellite remote sensing [@bertoncini_large-area_2022;@fugazza_spatial_2016].

Instrumentation deployed on towers and automatic weather stations can provide high-quality albedo data with high-temporal resolution at a single location. However, the pyranometer footprint limits the spatial extrapolation of the albedo data [@berg_finescale_2020].

Coupled snow radiative transfer and snowpack models can simulate the temporal and spatial evolution of snow optical properties. However, these coupled models are associated with high computational costs and limited spatial resolution [@gaillard_improving_2025]. Also, these models require input data that is often spatially variable and unavailable most of the time.

Remote sensing offers the best option for studying the changes in albedo, accounting for the high variability in space and time [@berg_finescale_2020]. Satellite albedo retrievals typically comprise three steps: atmospheric correction, modeling of the angular reflectance, and narrow-to-broadband albedo conversion [@carlsen_parameterizing_2020;@qu_mapping_2015]. The algorithms for atmospheric correction [@doxani_atmospheric_2023;@vermote_preliminary_2016], modeling of the angular reflectance distribution [@lucht_algorithm_2000;@ren_anisotropy_2021], and narrow-to-broadband albedo conversion
[@knap_narrowband_1999;@li_preliminary_2018;@liang_narrowband_2001] are well-established and validated in a number of case studies. In addition to these steps, satellite image preprocessing and topographic correction are necessary for homogenizing the input data and minimizing the effects of slope and aspect on albedo, respectively.

Several workflows have been proposed to address these processing steps [e.g.,@klok_temporal_2003;@shuai_algorithm_2011]. However, research code supporting their implementation is not always readily available. This paper introduces the `SatRbedo` package, which implements workflows in R to estimate snow and ice albedo from satellite data.

# Implementation

`SatRbedo` consists of four workflows that run in a processing pipeline (\autoref{fig:workflow}).

![Flowchart of the SatRbedo package. It includes four workflows: preprocessing, topographic correction, anisotropic correction, and narrow-to-broadband albedo conversion. The details of the workflows are described in the text.\label{fig:workflow}](workflow.png){ width=80% }

Firstly, the Preprocessing Workflow requires application-ready surface reflectance data for all available spectral bands ($\rho_s$), satellite ($\varphi_v$, $\theta_v$) and solar ($\varphi_s$, $\theta_s$) azimuth and zenith angles, and an outline of the area of interest (AOI) to carry out the following preprocessing steps: crop the satellite grids to a specified extent; convert data from integer to floating point; re-project grids to a common coordinate system; and convert nadir satellite observations to off-nadir values using view-angle corrections based on the c-factor method [@roy_general_2016].

Subsequently, in the Topographic Correction Workflow, surface reflectance that is not adjusted for view angle ($\rho_T$) is corrected for topographic effects to generate equivalent reflectance values over flat terrain ($\rho_H$). `SatRbedo` provides two empirical methods: the rotation model by @tan_improved_2013 and the C-correction model [@teillet_slope-aspect_1982]. These algorithms are appropriate for mountainous environments with rugged topography and non-Lambertian surface properties, requiring a digital elevation model (DEM) and solar azimuth and zenith angles as inputs. Both models assume a linear relationship between reflectance and the solar incidence angle on an inclined surface. Additional functions are available to remove topographic shadows (both self- and cast) using the vectorial algebra algorithms introduced by @corripio_vectorial_2003.

The Anisotropic Correction Workflow corrects for the anisotropic reflection properties of snow and ice. For each surface type, the anisotropic reflection factors ($f$) are calculated using empirical Bidirectional Reflectance Distribution Function (BRDF) models that consider the view-solar geometry relative to the inclined surface, described by slope and aspect. `SatRbedo` includes two models: the BRDF models of @koks_anisotropic_2001 for snow and @greuell_anisotropic_1999 for ice, both used with green and near-infrared (NIR) bands, and parameterizations from @ren_anisotropy_2021 for combinations of blue, red, NIR, and shortwave-infrared bands. To distinguish snow from ice, the Normalized Difference Snow/Ice Index
[NDSII,@keshri_aster_2009] is computed from green ($\rho_{T, green}$) and NIR ($\rho_{T, NIR}$) surface reflectance, and surface discrimination is performed using an automatic threshold selection based on the Otsu algorithm [@otsu_threshold_1979].

The Narrow-to-broadband albedo conversion Workflow employs empirical BRDF models to compute narrowband albedo ($\alpha_{narrowband}$) for each spectral band after topographic correction ($\rho_H$). It then derives broadband albedo ($\alpha_{broadband}$) from these narrowband values using the empirical relationships proposed by @knap_narrowband_1999 and @liang_narrowband_2001. Furthermore, a function is included that implements a direct approach that does not require an anisotropy correction and transforms surface reflectance into albedo using the algorithm from @feng_remote_2023.

# Future development

It is expected that active development on `SatRbedo` will continue in the future through the incorporation of the newest tools and methods as they become available, as well as through the active participation of the research community through the software repository platform. Developments in progress include a kernel-based semiempirical BRDF model and new snow and snow-free narrow-to-broadband albedo conversion algorithms.

# Acknowledgements

This research was supported by a University of Canterbury Doctoral Scholarship. The authors wish to acknowledge using the `terra` package [@hijmans_terra_2025] that provided the raster data handling infrastructure on which `SatRbedo` was built. We also thank Javier Corripio, who wrote the original vectorial algebra algorithms for computing topographic shading on complex terrain.

# References