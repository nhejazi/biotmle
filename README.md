# R/`biotmle`

[![Travis-CI Build Status](https://travis-ci.org/nhejazi/biotmle.svg?branch=master)](https://travis-ci.org/nhejazi/biotmle)
[![AppVeyor Build  Status](https://ci.appveyor.com/api/projects/status/github/nhejazi/biotmle?branch=master&svg=true)](https://ci.appveyor.com/project/nhejazi/biotmle)
[![Coverage Status](https://img.shields.io/codecov/c/github/nhejazi/biotmle/master.svg)](https://codecov.io/github/nhejazi/biotmle?branch=master)
[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

> Targeted Learning for Biomarker Discovery with the Moderated T-Statistic

---

## Description

`biotmle` is an R package that facilitates biomarker discovery by generalizing
the moderated t-statistic of Smyth for use with asymptotically linear target
parameters. The set of methods implemented in this R package rely on the use of
Targeted Minimum Loss-Based Estimation (TMLE) to transform biological sequencing
data (e.g., microarray, RNA-seq) based on the influence curve representation of
a particular statistical target parameter (e.g., the Average Treatment Effect).
The transformed data is then used to test for group differences using the
moderated t-statistic as implemented in the R package
[`limma`](https://bioconductor.org/packages/release/bioc/html/limma.html).

---

## Installation

- For standard use, install from [Bioconductor](https://bioconductor.org):
  ```r
  source("https://bioconductor.org/biocLite.R")
  biocLite("biotmle")
  ```

- Install the most recent _stable release_ from GitHub:
  ```r
  devtools::install_github("nhejazi/biotmle")
  ```

- To contribute, install the _development version_:
  ```r
  devtools::install_github("nhejazi/biotmle", ref = "develop")
  ```

---

## Issues

If you encounter any bugs or have any specific feature requests, please [file an
issue](https://github.com/nhejazi/biotmle/issues).

---

## Citation

After using the `biotmle` R package, please cite it:

        @article{hejazi2017,
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

---

## Principal References

* [Nima S. Hejazi, Sara Kherad-Pajouh, and Alan E. Hubbard. "Generalizing the
    moderated t-statistic with targeted maximum likelihood estimation." __in
    preparation__, 2017.]()

* [Gordon K. Smyth. "Linear models and empirical Bayes methods for assessing
    differential expression in microarray experiments." _Statistical
    Applications in Genetics and Molecular Biology_, 3(1),
    2004.](http://www.statsci.org/smyth/pubs/ebayes.pdf)

---

## License

&copy; 2016-2017 [Nima S. Hejazi](http://nimahejazi.org) & [Alan E.
Hubbard](https://hubbardgroup.github.io)

The contents of this repository are distributed under the MIT license. See file
`LICENSE` for details.
