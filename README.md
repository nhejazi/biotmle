# R/`tmlelimma`

[![MIT
license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Travis-CI Build
Status](https://travis-ci.org/nhejazi/limmaTMLE.svg)](https://travis-ci.org/nhejazi/limmaTMLE)

`tmlelimma` is an R package for using the empirical Bayes method formulated
in the [Limma]() (Linear Models for Microarrays) package alongside Targeted
Minimum Loss-Based Estimation (TMLE) to estimate a causally identifiable
statistical target parameter (_e.g._, the Average Treatment Effect (ATE)) that
relates changes in levels of gene expression to a particular outcome of
interest (_e.g._, survival).

---

## Installation

- To install the most recent _stable release_ from GitHub, use
  ```r
  devtools::install_github("nhejazi/limmaTMLE", subdir = "pkg")
  ```

- To install the _development version_, use
  ```r
  devtools::install_github("nhejazi/limmaTMLE", ref = "develop", subdir = "pkg")
  ```

---

## License

&copy; 2016-2017 Nima S. Hejazi, Wilson (Weixin) Cai, Alan E. Hubbard

The contents of this repository are distributed under the MIT license. See file
`LICENSE` for details.
