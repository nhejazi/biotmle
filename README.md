# R/`biotmle`

[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)

> Targeted Learning for Biomarker Discovery with the Moderated T-Statistic

---

## Description

`biotmle` is an R package that generalizes the moderated t-statistic of Smyth
for use with asymptotically linear target parameters. The technique implemented
here relies on the use of Targeted Minimum Loss-Based Estimation (TMLE) to
transform a given omics data set based on the influence curve representation of
a particular statistical target parameter (e.g., the Average Treatment Effect).
The transformed data is then used to test for differences between groups using
the moderated t-statistic as implemented in the R package
[`limma`](https://bioconductor.org/packages/release/bioc/html/limma.html).

### Builds/Testing

@           | Build (macOS/Linux)     | Build (Windows)     | Coverage
------------|-------------------------|---------------------|--------------
**master**  |  [![Travis-CI Build Status](https://travis-ci.org/nhejazi/biotmle.svg?branch=master)](https://travis-ci.org/nhejazi/biotmle)  |  [![AppVeyor Build  Status](https://ci.appveyor.com/api/projects/status/github/nhejazi/biotmle?branch=master&svg=true)](https://ci.appveyor.com/project/nhejazi/biotmle)  |  [![Coverage Status](https://coveralls.io/repos/github/nhejazi/biotmle/badge.svg?branch=master)](https://coveralls.io/github/nhejazi/biotmle?branch=master)
**develop**  |  [![Travis-CI Build Status](https://travis-ci.org/nhejazi/biotmle.svg?branch=develop)](https://travis-ci.org/nhejazi/biotmle)  |  [![AppVeyor Build  Status](https://ci.appveyor.com/api/projects/status/github/nhejazi/biotmle?branch=develop&svg=true)](https://ci.appveyor.com/project/nhejazi/biotmle)  |  [![Coverage Status](https://coveralls.io/repos/github/nhejazi/biotmle/badge.svg?branch=develop)](https://coveralls.io/github/nhejazi/biotmle?branch=develop)

---

## Installation

- Install the most recent _stable release_ from GitHub:
  `devtools::install_github("nhejazi/biotmle", subdir = "pkg")`

- To contribute, install the _development version_:
  `devtools::install_github("nhejazi/biotmle", ref = "develop", subdir = "pkg")`

---

## License

&copy; 2016-2017 [Nima S. Hejazi](http://nimahejazi.org) & [Alan E.
Hubbard](https://ahubb40.github.io)

The contents of this repository are distributed under the MIT license. See file
`LICENSE` for details.
