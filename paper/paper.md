---
title: 'biotmle: Targeted Learning for Biomarker Discovery'
tags:
  - targeted learning
  - variable importance
  - causal inference
  - bioinformatics
  - genomics
  - R
authors:
  - name: Nima S. Hejazi
    orcid: 0000-0002-7127-2789
    affiliation: 1
  - name: Weixin Cai
    orcid: 0000-0003-2680-3066
    affiliation: 1
  - name: Alan E. Hubbard
    orcid: 0000-0002-3769-0127
    affiliation: 1
affiliations:
  - name: Division of Biostatistics, University of California, Berkeley
    index: 1
date: 26 July 2017
bibliography: paper.bib
---

# Summary

The `biotmle` package provides an implementation of a biomarker discovery
methodology based on targeted minimum loss-Based estimation (TMLE)
[@vdl2011targeted] and a generalization of the moderated t-statistic of
[@smyth2004linear], designed for use with biological sequencing data (e.g.,
microarrays, RNA-seq). The statistical approach made available in this package
relies on the use of TMLE to rigorously evaluate the association between a set
of potential biomarkers and another variable of interest while adjusting for
potential confounding from another set of user-specified covariates. The
implementation is in the form of a package for the R language for statistical
computing [@R].

There are two principal ways in which the biomarker discovery techniques in
the `biotmle` R package can be used: to evaluate the association between (1) a
phenotypic measure (say, environmental exposure) and a biomarker of interest,
and (2) an outcome of interest (e.g., survival status at a given time) and a
biomarker measurement, both while controlling for background covariates (e.g.,
BMI, age). By using an estimation procedure based on TMLE, the package produces
results based on the Average Treatment Effect (ATE), a statistical parameter
with a well-studied causal interpretation (see @vdl2011targeted for extended
discussions), making the `biotmle` R package well-suited for applications in
bioinformatics, epidemiology, and genomics.

After adjusting our data set to be consistent with the expect input format --
please consult the vignette accompanying the R package for details -- we would
call the principal function of this R package: `biomarkertmle`.

We would perform a moderated test on the output of the `biomarkertmle` function
using the function `modtest_ic`.

While the principal table of results produced by this R package matches those
produced by the well-known `limma` R package [@smyth2005limma], there are also
several plot methods made available for the `bioTMLE` S4 class -- subclassed
from the popular `SummarizedExperiment` class -- introduced by this package
[@huber2015orchestrating]. For illustrative purposes, we demonstrate the ouput
of two such functions on anonymized experimental data below:

![Heatmap visualizing the Average Treatment Effect contribution of a change in
exposure to each biomarker of interest](figs/heatmap_biotmle.png)

![Volcano plot visualizing the log fold change in the Average Treatment Effect
against the raw p-value from the moderated t-test performed on each
biomarker](figs/volcanoplot_biotmle.png)

\newpage

# References
