
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

**Author:** [Nima Hejazi](https://nimahejazi.org)

-----

## What’s `biotmle`?

`biotmle` is an R package that facilitates biomarker discovery by
generalizing the moderated t-statistic (Smyth 2004) for use with target
parameters that have asymptotically linear representations (van der Laan
and Rose 2011). The set of methods implemented rely on the use of
targeted maximum likelihood (TML) estimation to transform biological
sequencing data (e.g., microarray, RNA-seq) based on the (efficient)
influence function (EIF) representation of a particular causal target
parameter (e.g., average treatment effect). The transformed data
(rotated into influence function space) are then be subjected to a
moderated test for differences between the statistical estimate of the
target parameter and a hypothesized value of said parameter (usually a
null value defined in relation to the parameter itself). Such an
approach provides a valid and conservative statistical hypothesis test
of a statistically estimable target parameter while controlling the
standard error (derived from the variance of the EIF) such that the
error rate of the test is more strongly controlled relative to testing
procedures that do fail moderate the variance estimate
(<span class="citeproc-not-found" data-reference-id="hejazi2018variance">**???**</span>)
while simultaneously avoiding many of the pitfalls that plague analogous
procedures predicated upon correctly specifying linear models (Smyth
2004). Utilities are also provided for performing clustering based on
*supervised distance matrices*, using the EIF-based estimates to draw
out underlying contributions of biomarkers to the target parameter of
interest (Pollard and van der Laan 2008).

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

    @article{hejazi2018+variance,
      url = {https://arxiv.org/abs/1710.05451},
      year = {2018+},
      author = {Hejazi, Nima S and {Kherad-Pajouh}, Sara and {van der
        Laan}, Mark J and Hubbard, Alan E},
      title = {Variance moderation of locally efficient estimators in
        high-dimensional biology}
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

© 2016-2018 [Nima S. Hejazi](https://nimahejazi.org)

The contents of this repository are distributed under the MIT license.
See file `LICENSE` for details.

-----

## References

<div id="refs" class="references">

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

<div id="ref-vdl2011targeted">

van der Laan, Mark J., and Sherri Rose. 2011. *Targeted Learning: Causal
Inference for Observational and Experimental Data*. Springer Science &
Business Media.

</div>

</div>
