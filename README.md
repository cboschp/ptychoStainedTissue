# ptychoStainedTissue
Brain tissue ultrastructure resolved with synchrotron X-ray ptychography. 

The code in this repo supports the plots and findings presented in this study:

> **Non-destructive X-ray tomography of brain tissue ultrastructure**
> 
> Carles Bosch, Tomas Aidukas, Mirko Holler, Alexandra Pacureanu, Elisabeth Müller, Christopher J. Peddie, Yuxin Zhang, Phil Cook, Lucy Collinson, Oliver Bunk, Andreas Menzel, Manuel Guizar-Sicairos, Gabriel Aeppli, Ana Diaz, Adrian A. Wanner, Andreas T. Schaefer.
> 
> bioRxiv 2023.11.16.567403; doi: [https://doi.org/10.1101/2023.11.16.567403](https://doi.org/10.1101/2023.11.16.567403) 


## Datasets

### Tomogram metadata

The data to run several plots in this repo can be found in this structured table: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.12802475.svg)](https://doi.org/10.5281/zenodo.12802475).

### All tomograms

A list of all PXCT tomographic reconstructions can be accessed [here](https://github.com/cboschp/ptychoStainedTissue/blob/main/1-dataset/tomogram_list.md).

A csv version of this same table for easier data readout can be found [here](https://github.com/cboschp/ptychoStainedTissue/blob/main/1-dataset/tT_sorted_series_h_csv.csv). This table is referred to in the manuscript as `Supplementary Table 1`.

### Correlative PXCT-FIBSEM

Paired PXCT-FIBSEM datasets.

| specimenID | region | pillarID | tomo_ID | resolution_rigid | resolution_nonRigid | filter | wk_ptychoRigid | wk_ptychoNonRigid | vxSize_ptycho | wk_FIBSEM | vxSize_FIBSEM | wk_joined_wFIBSEM-cSAXS | vxSize_joined | wk_matchedPtycho_zRev | wk_wFIBSEM |
| -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- | -- |
| C319 | EPL | EPL-1 | 273 | **53.97 nm** | 54.52 nm | hann | **[C319_EPL1_cSAXS_273_S1394toS2014_r](https://wklink.org/9243)** | [C319_EPL1_cSAXS_273_S01394-S02014_nr_hann](https://wklink.org/8943) |  (37.6 nm)^3 | [C319_EPL1_FIBSEM_mesh3](https://wklink.org/7875) | (8 nm)^3 | [C319_EPL1_joint_wFIBSEM-cSAXS](https://wklink.org/3318) | (9.4 nm)^3 | [C319_EPL1_cSAXS_tomo273_rev](https://wklink.org/1120) | [C319_EPL1_warpedFIBSEM](https://wklink.org/6432) |
| Y357 | N/A (likely EPL) | Y357_3dot | 853 | 42.41 nm | **38.21 nm** | ram-lak | [Y357_3dot_cSAXS_853_S14468-S15686_rigid_ramlak](https://wklink.org/4442) | **[Y357_3dot_cSAXS_853_S14468_to_S15686_nr_ramlak](https://wklink.org/3741)** |  (27.6 nm)^3 | [Y357_3dot_FIBSEM](https://wklink.org/5566) | (8 nm)^3 | [Y357_3dot_joined_wFIBSEM-cSAXS](https://wklink.org/3209); [FIBSEM & PXCT segmentation in CAVE](https://spelunker.cave-explorer.org/#!middleauth+https://global.daf-apis.com/nglstate/api/v1/5950833582669824) | (6.9 nm)^3 | [Y357_3dot_cSAXS_853_S14468-S15686_nr_ramlak_zRev](https://wklink.org/4296) | [Y357_3dot_wFIBSEM](https://wklink.org/1896) |
| Y357 | N/A (likely GCL) | Y357_30um | 856-859 | 67.50 nm | **49.48 nm** | ram-lak | [Y357_30mu_cSAXS_856_S17672-S19092_rigid_ramlak](https://wklink.org/6945) | **[Y357_30mu_cSAXS_856_S17672-S19092_nr_ramlak](https://wklink.org/2864)** |  (27.6 nm)^3 | [Y357_30um_FIBSEM](https://wklink.org/3529) | (8 nm)^3 | [Y357_30um_joined_wFIBSEM-cSAXS](https://wklink.org/7681) | (6.9 nm)^3 | [Y357_30mu_cSAXS_856_S17672-S19092_nr_ramlak_zRev](https://wklink.org/1947) | [Y357_30um_wFIBSEM](https://wklink.org/9612) |

## Methods for ptychographic and tomographic reconstructions

The algorithms used fot ptychographic and tomographic reconstructions are derived from the generic packages openly accessible in the [cSAXS beamline's webpage](https://www.psi.ch/en/sls/csaxs/software).
