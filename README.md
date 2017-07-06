
<!-- README.md is generated from README.Rmd. Please edit that file -->
R/`biotmle`
===========

[![Travis-CI Build Status](https://travis-ci.org/nhejazi/biotmle.svg?branch=master)](https://travis-ci.org/nhejazi/biotmle) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/nhejazi/biotmle?branch=master&svg=true)](https://ci.appveyor.com/project/nhejazi/biotmle/) [![Coverage Status](https://img.shields.io/codecov/c/github/nhejazi/biotmle/master.svg)](https://codecov.io/github/nhejazi/biotmle?branch=master) [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Bioc Time](http://bioconductor.org/shields/years-in-bioc/biotmle.svg)](https://bioconductor.org/packages/release/bioc/html/biotmle.html) [![JOSS Status](http://joss.theoj.org/papers/02be843d9bab1b598187bfbb08ce3949/status.svg)](http://joss.theoj.org/papers/02be843d9bab1b598187bfbb08ce3949) [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

> Targeted Learning with moderated statistics for biomarker discovery

**Author:** [Nima Hejazi](http://nimahejazi.org)

------------------------------------------------------------------------

Description
-----------

`biotmle` is an R package that facilitates biomarker discovery by generalizing the moderated t-statistic of Smyth for use with asymptotically linear target parameters. The set of methods implemented in this R package rely on the use of Targeted Minimum Loss-Based Estimation (TMLE) to transform biological sequencing data (e.g., microarray, RNA-seq) based on the influence curve representation of a particular causal target parameter (e.g., Average Treatment Effect). The transformed data are then used to test for differences between the statistical estimate of the target parameter and a hypothesized value of said parameter using the approach of moderated statistics.

------------------------------------------------------------------------

Installation
------------

For standard use, install from [Bioconductor](https://bioconductor.org):

``` r
source("https://bioconductor.org/biocLite.R")
biocLite("biotmle")
```

Install the most recent *stable release* from GitHub via [`devtools`](https://www.rstudio.com/products/rpackages/devtools/):

``` r
devtools::install_github("nhejazi/biotmle")
```

To contribute, install the *development version* from GitHub via [`devtools`](https://www.rstudio.com/products/rpackages/devtools/):

``` r
devtools::install_github("nhejazi/biotmle", ref = "develop")
```

------------------------------------------------------------------------

Issues
------

If you encounter any bugs or have any specific feature requests, please [file an issue](https://github.com/nhejazi/biotmle/issues).

------------------------------------------------------------------------

Citation
--------

After using the `biotmle` R package, please cite it:

        @article{hejazi2017biotmle,
          doi = {},
          url = {},
          year  = {2017},
          month = {},
          publisher = {The Open Journal},
          volume = {},
          number = {},
          author = {Hejazi, Nima S and Cai, Weixin and Hubbard, Alan E},
          title = {biotmle: Targeted Learning for Biomarker Discovery},
          journal = {The Journal of Open Source Software}
        }

------------------------------------------------------------------------

Related
-------

-   [R/`biotmleData`](https://github.com/nhejazi/biotmleData) - R package with example experimental data for use with this analysis package.

------------------------------------------------------------------------

References
----------

-   [Nima S. Hejazi, Sara Kherad-Pajouh, Mark J. van der Laan, and Alan E. Hubbard. "Generalized application of the moderated t-statistic to asymptotically linear target parameters." **in preparation**, 2017.]()

-   [Gordon K. Smyth. "Linear models and empirical Bayes methods for assessing differential expression in microarray experiments." *Statistical Applications in Genetics and Molecular Biology*, 3(1), 2004.](http://www.statsci.org/smyth/pubs/ebayes.pdf)

------------------------------------------------------------------------

License
-------

© 2016-2017 [Nima S. Hejazi](http://nimahejazi.org) & [Alan E. Hubbard](http://hubbard.berkeley.edu/)

The contents of this repository are distributed under the MIT license. See file `LICENSE` for details.
