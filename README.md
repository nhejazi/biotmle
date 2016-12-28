# R/`tmlelimma`

[![MIT
license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Travis-CI Build
Status](https://travis-ci.org/nhejazi/limmaTMLE.svg)](https://travis-ci.org/nhejazi/limmaTMLE)

`tmlelimma` is an R package that generalizes the moderated t-statistic of Smyth
for use with asymptotically linear target parameters. The technique implemented
here relies on the use of Targeted Minimum Loss-Based Estimation (TMLE) to
transform observed data based on influence curve representations of statistical
target parameters (e.g., the Average Treatment Effect), with the transformed
data then being used to test for differences between groups using the moderated
t-statistic as implemented in the R package
[limma](https://bioconductor.org/packages/release/bioc/html/limma.html).

---

## Installation

- To install the most recent _stable release_ from GitHub, use
  ```r
  devtools::install_github("nhejazi/tmlelimma", subdir = "pkg")
  ```

- To install the _development version_, use
  ```r
  devtools::install_github("nhejazi/tmlelimma", ref = "develop", subdir = "pkg")
  ```

---

## Dependencies

1. [`tmle`](https://cran.r-project.org/web/packages/tmle/index.html) - R
    package implementing Targeted Minimum Loss-Based Estimation.

2. [`limma`](https://bioconductor.org/packages/release/bioc/html/limma.html) -
    R package providing linear modeling tools for microarray data.

---

## License

&copy; 2016-2017 Nima S. Hejazi, Weixin (Wilson) Cai, Alan E. Hubbard

The contents of this repository are distributed under the MIT license. See file
`LICENSE` for details.
