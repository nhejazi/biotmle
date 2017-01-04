---
title: 'biotmle: Targeted Learning for Biomarker Discovery'
tags:
  - targeted learning
  - multiple testing
  - bioinformatics
  - biomarkers
  - genomics
  - R
authors:
  - name: Nima Hejazi
    orcid: 0000-0002-7127-2789
    affiliation: 1
  - name: Weixin Cai
    orcid: 0000-0003-2680-3066
    affiliation: 1
  - name: Alan Hubbard
    orcid: 0000-0002-3769-0127
    affiliation: 1
affiliations:
  - name: Division of Biostatistics, University of California, Berkeley
    index: 1
date: 04 January 2017
bibliography: manuscript.bib
---

# Summary

The `biotmle` package provides an implementation of a biomarker discovery
methodology based on Targeted Minimum Loss-Based Estimation (TMLE) and a
generalization of the moderated t-statistic of [@smyth2005limma], designed for
use with biological sequencing data (e.g., microarrays, RNA-seq). The
statistical approach made available in this package relies on TMLE to
rigorously evaluate the association between a set of potential biomarkers and
another variable of interest (either an exposure or outcome), while adjusting
for potential confounding from another set of user-specified covariates. The
implementation provided here comes the form of a package for the R language for
statistical computing [@R].

The ...

![Heatmap visualizing ATE difference by exposure](figs/heatmap_biotmle.png)

![Adjusted p-value histogram (moderated t-test)](figs/hist_adjp_biotmle.png)

![Volcano plot of ATE difference by exposure](figs/volcanoplot_biotmle.png)

\newpage

# References
