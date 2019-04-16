
<!-- README.md is generated from README.Rmd. Please edit that file -->

# R/`biotmle`

[![Travis-CI Build
Status](https://travis-ci.org/nhejazi/biotmle.svg?branch=master)](https://travis-ci.org/nhejazi/biotmle)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/nhejazi/biotmle?branch=master&svg=true)](https://ci.appveyor.com/project/nhejazi/biotmle/)
[![Coverage
Status](https://img.shields.io/codecov/c/github/nhejazi/biotmle/master.svg)](https://codecov.io/github/nhejazi/biotmle?branch=master)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![BioC
status](http://www.bioconductor.org/shields/build/release/bioc/biotmle.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/biotmle)
[![Bioc
Time](http://bioconductor.org/shields/years-in-bioc/biotmle.svg)](https://bioconductor.org/packages/release/bioc/html/biotmle.html)
[![Bioc
Downloads](http://bioconductor.org/shields/downloads/biotmle.svg)](https://bioconductor.org/packages/release/bioc/html/biotmle.html)
[![MIT
license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![DOI](https://zenodo.org/badge/65854775.svg)](https://zenodo.org/badge/latestdoi/65854775)
[![JOSS
Status](http://joss.theoj.org/papers/02be843d9bab1b598187bfbb08ce3949/status.svg)](http://joss.theoj.org/papers/02be843d9bab1b598187bfbb08ce3949)

> Targeted Learning with Moderated Statistics for Biomarker Discovery

**Authors:** [Nima Hejazi](https://nimahejazi.org) and [Alan
Hubbard](https://hubbard.berkeley.edu)

-----

## What’s `biotmle`?

The `biotmle` R package facilitates biomarker discovery through a
generalization of the moderated t-statistic (Smyth 2004) that extends
the procedure to locally efficient estimators of asymptotically linear
target parameters (Tsiatis 2007). The set of methods implemented modify
targeted maximum likelihood (TML) estimators of statistical (or causal)
target parameters (e.g., average treatment effect) to apply variance
moderation to the efficient influence function (EIF) representation of
the target parameter (van der Laan and Rose 2011, 2018). The influence
function-based representation of the data are then subjected to a
moderated hypothesis test of the statistical estimate of the target
parameter, effectively stabilizing the standard error estimates (derived
directly from the relevant efficient influence function) and allowing
such estimators to be employed in smaller sample sizes, such as those
common in computational biology and bioinformatics applications. The
resultant procedure, *supervised variance moderation*, allows for the
construction of a conservative hypothesis test of a statistically
estimable target parameter that controls the standard error in a manner
that reduces the false discovery rate or the family-wise error rate
(Hejazi et al., n.d.). Utilities are also provided for performing
clustering through *supervised distance matrices*, using the EIF-based
estimates to draw out the underlying contributions of individual
biomarkers to the target parameter of interest (Pollard and van der Laan
2008).

-----

## Installation

For standard use, install from
[Bioconductor](https://bioconductor.org/packages/biotmle) using
[`BiocManager`](https://CRAN.R-project.org/package=BiocManager):

``` r
if (!requireNamespace("BiocManager", quietly=TRUE)) {
  install.packages("BiocManager")
}
BiocManager::install("biotmle")
```

To contribute, install the bleeding-edge *development version* from
GitHub via
[`devtools`](https://www.rstudio.com/products/rpackages/devtools/):

``` r
devtools::install_github("nhejazi/biotmle")
```

Current and prior [Bioconductor](https://bioconductor.org) releases are
available under branches with numbers prefixed by “RELEASE\_”. For
example, to install the version of this package available via
Bioconductor 3.6, use

``` r
devtools::install_github("nhejazi/biotmle", ref = "RELEASE_3_6")
```

-----

## Example

For details on how to best use the `biotmle` R package, please consult
the most recent [package
vignette](https://bioconductor.org/packages/release/bioc/vignettes/biotmle/inst/doc/exposureBiomarkers.html)
available through the [Bioconductor
project](https://bioconductor.org/packages/biotmle).

-----

## Issues

If you encounter any bugs or have any specific feature requests, please
[file an issue](https://github.com/nhejazi/biotmle/issues).

-----

## Contributions

Contributions are very welcome. Interested contributors should consult
our [contribution
guidelines](https://github.com/nhejazi/biotmle/blob/master/CONTRIBUTING.md)
prior to submitting a pull request.

-----

## Citation

After using the `biotmle` R package, please cite both of the following:

``` 
    @article{hejazi2017biotmle,
      author = {Hejazi, Nima S and Cai, Weixin and Hubbard, Alan E},
      title = {biotmle: Targeted Learning for Biomarker Discovery},
      journal = {The Journal of Open Source Software},
      volume = {2},
      number = {15},
      month = {July},
      year  = {2017},
      publisher = {The Open Journal},
      doi = {10.21105/joss.00295},
      url = {https://doi.org/10.21105/joss.00295}
    }

    @article{hejazi2018+supervised,
      url = {https://arxiv.org/abs/1710.05451},
      year = {2018+},
      author = {Hejazi, Nima S and {Kherad-Pajouh}, Sara and {van der
        Laan}, Mark J and Hubbard, Alan E},
      title = {Supervised variance moderation of locally efficient
        estimators, with applications in in high-dimensional biology}
    }
```

-----

## Related

  - [R/`biotmleData`](https://github.com/nhejazi/biotmleData) - R
    package with example experimental data for use with this analysis
    package.

-----

## Funding

The development of this software was supported in part through grants
from the National Institutes of Health: [P42
ES004705-29](https://projectreporter.nih.gov/project_info_details.cfm?aid=9260357&map=y)
and [R01
ES021369-05](https://projectreporter.nih.gov/project_info_description.cfm?aid=9210551&icde=37849782&ddparam=&ddvalue=&ddsub=&cr=1&csb=default&cs=ASC&pball=).

-----

## License

© 2016-2019 [Nima S. Hejazi](https://nimahejazi.org)

The contents of this repository are distributed under the MIT license.
See file `LICENSE` for details.

-----

## References

<div id="refs" class="references">

<div id="ref-hejazi2018+supervised">

Hejazi, Nima S, Sara Kherad-Pajouh, Mark J van der Laan, and Alan E
Hubbard. n.d. “Supervised Variance Moderation of Locally Efficient
Estimators in High-Dimensional Biology.”
<https://arxiv.org/abs/1710.05451>.

</div>

<div id="ref-pollard2008supervised">

Pollard, Katherine S, and Mark J van der Laan. 2008. “Supervised
Distance Matrices.” *Statistical Applications in Genetics and Molecular
Biology* 7 (1). De Gruyter.

</div>

<div id="ref-smyth2004linear">

Smyth, Gordon K. 2004. “Linear Models and Empirical Bayes Methods for
Assessing Differential Expression in Microarray Experiments.”
*Statistical Applications in Genetics and Molecular Biology* 3 (1).
Walter de Gruyter: 1–25. <https://doi.org/10.2202/1544-6115.1027>.

</div>

<div id="ref-tsiatis2007semiparametric">

Tsiatis, Anastasios. 2007. *Semiparametric Theory and Missing Data*.
Springer Science & Business Media.

</div>

<div id="ref-vdl2011targeted">

van der Laan, Mark J., and Sherri Rose. 2011. *Targeted Learning: Causal
Inference for Observational and Experimental Data*. Springer Science &
Business Media.

</div>

<div id="ref-vdl2018targeted">

van der Laan, Mark J, and Sherri Rose. 2018. *Targeted Learning in Data
Science: Causal Inference for Complex Longitudinal Studies*. Springer
Science & Business Media.

</div>

</div>
