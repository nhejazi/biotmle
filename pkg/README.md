# R/limmaTMLE

[![MIT
license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Travis-CI Build
Status](https://travis-ci.org/nhejazi/limmaTMLE.svg)](https://travis-ci.org/nhejazi/limmaTMLE)

`limmaTMLE` is an R package for using the empirical Bayes method formulated
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

&copy; 2016-2017 Nima Hejazi, Wilson Cai, Alan Hubbard

This repository is licensed under the MIT license. See below for details:
```
The MIT License (MIT)

Copyright (c) 2016-2017 Nima Hejazi, Wilson Cai, Alan Hubbard

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
