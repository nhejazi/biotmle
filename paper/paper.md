Summary
=======

The `biotmle` package provides an implementation of a biomarker
discovery methodology based on targeted minimum loss-Based estimation
(TMLE) (van der Laan and Rose 2011) and a generalization of the
moderated t-statistic of (Smyth 2004), designed for use with biological
sequencing data (e.g., microarrays, RNA-seq). The statistical approach
made available in this package relies on the use of TMLE to rigorously
evaluate the association between a set of potential biomarkers and
another variable of interest while adjusting for potential confounding
from another set of user-specified covariates. The implementation is in
the form of a package for the R language for statistical computing (R
Core Team 2017).

There are two principal ways in which the biomarker discovery techniques
in the `biotmle` R package can be used: to evaluate the association
between (1) a phenotypic measure (say, environmental exposure) and a
biomarker of interest, and (2) an outcome of interest (e.g., survival
status at a given time) and a biomarker measurement, both while
controlling for background covariates (e.g., BMI, age). By using an
estimation procedure based on TMLE, the package produces results based
on the Average Treatment Effect (ATE), a statistical parameter with a
well-studied causal interpretation (see van der Laan and Rose (2011) for
extended discussions), making the `biotmle` R package well-suited for
applications in bioinformatics, epidemiology, and genomics.

Let's take a look at an example data set and clean it up for use with
this R package:

    library(biotmle)

    ## biotmle: Moderated Statistics and Targeted Learning for Biomarker Discovery

    ## Version: 1.1.2

    library(biotmleData)
    data(illuminaData)

    # discretize "age" in the phenotype-level data
    colData(illuminaData) <- colData(illuminaData) %>%
      data.frame %>%
      dplyr::mutate(age = as.numeric(age > median(age))) %>%
      DataFrame

    # specify column index of treatment/exposure variable of interest
    varInt_index <- which(names(colData(illuminaData)) %in% "benzene")

We would call the principal function of this R package (`biomarkertmle`)
with the following syntax:

    biomarkerTMLEout <- biomarkertmle(se = illuminaData,
                                      varInt = varInt_index,
                                      family = "gaussian",
                                      g_lib = c("SL.glmnet", "SL.randomForest",
                                                "SL.polymars", "SL.mean"),
                                      Q_lib = c("SL.glmnet", "SL.randomForest",
                                                "SL.nnet", "SL.mean")
                                     )

Note that the above call is not executed, as the estimation procedure is
both time- and resource-intensive.

We would perform a moderated test on the output of the `biomarkertmle`
function using the function `modtest_ic`:

    limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)

While the principal table of results produced by this R package matches
those produced by the well-known `limma` R package (Smyth 2005), there
are also several plot methods made available for the `bioTMLE` S4 class
-- subclassed from the popular `SummarizedExperiment` class --
introduced by this package (Huber et al. 2015). For illustrative
purposes, we demonstrate the ouput of two such functions on anonymized
experimental data below:

    varInt_index <- which(names(colData(illuminaData)) %in% "benzene")
    designVar <- as.data.frame(colData(illuminaData))[, varInt_index]
    designVar <- as.numeric(designVar == max(designVar))

    heatmap_ic(x = limmaTMLEout, design = designVar, FDRcutoff = 0.05, top = 25)

<img src="paper_files/figure-markdown_strict/plot_heatmap-1.png" style="display: block; margin: auto;" />

The above heatmap displays the results for the top 25 biomarkers. The
package also provides conveniences for generating volcano plots:

    volcano_ic(biotmle = limmaTMLEout)

<img src="paper_files/figure-markdown_strict/plot_volcano-1.png" style="display: block; margin: auto;" />

References
==========

Huber, Wolfgang, Vincent J Carey, Robert Gentleman, Simon Anders, Marc
Carlson, Benilton S Carvalho, Hector Corrada Bravo, et al. 2015.
“Orchestrating High-Throughput Genomic Analysis with Bioconductor.”
*Nature Methods* 12 (2). Nature Research: 115–21.

R Core Team. 2017. *R: A Language and Environment for Statistical
Computing*. Vienna, Austria: R Foundation for Statistical Computing.
<https://www.R-project.org/>.

Smyth, Gordon K. 2004. “Linear Models and Empirical Bayes Methods for
Assessing Differential Expression in Microarray Experiments.”
*Statistical Applications in Genetics and Molecular Biology* 3 (1):
1–25.

———. 2005. “Limma: Linear Models for Microarray Data.” In
*Bioinformatics and Computational Biology Solutions Using R and
Bioconductor*, 397–420. Springer.

van der Laan, Mark J, and Sherri Rose. 2011. *Targeted Learning: Causal
Inference for Observational and Experimental Data*. Springer Science &
Business Media.
