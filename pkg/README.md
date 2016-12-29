# R/`tmlelimma`

[![MIT
license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Travis-CI Build
Status](https://travis-ci.org/nhejazi/tmlelimma.svg)](https://travis-ci.org/nhejazi/tmlelimma)
[![Coverage
Status](https://coveralls.io/repos/github/nhejazi/limmatmle/badge.svg?branch=master)](https://coveralls.io/github/nhejazi/tmlelimma?branch=master)

> Targeted Learning in high dimensions with the moderated t-statistic.

---

## Description

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

## License

&copy; 2016-2017 Nima S. Hejazi, Weixin (Wilson) Cai, Alan E. Hubbard

This repository is licensed under the MIT license. See below for details:
```
The MIT License (MIT)

Copyright (c) 2016-2017 Nima S. Hejazi, Weixin (Wilson) Cai, Alan E. Hubbard

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
