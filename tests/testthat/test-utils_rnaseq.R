library(biotmle)
library(SummarizedExperiment)
library(biotmleData)
data(illuminaData)

context("Utilities for next-generation / RNA-seq data.")

################################################################################
## SETUP TESTS #################################################################
################################################################################

set.seed(6423709)
n <- 50
g <- 2500
cases_pois <- 50
controls_pois <- 10

ngs_cases <- as.data.frame(matrix(replicate(n, rpois(g, cases_pois)), g))
ngs_controls <- as.data.frame(matrix(replicate(n, rpois(g, controls_pois)), g))

ngs_data <- as.data.frame(cbind(ngs_cases, ngs_controls))
exp_var <- c(rep(1, n), rep(0, n))
batch <- rep(1:2, n)
covar <- rep(1, n * 2)
design <- as.data.frame(cbind(exp_var, batch, covar))

se <- SummarizedExperiment(
  assays = list(counts = DataFrame(ngs_data)),
  colData = DataFrame(design)
)
call <- "testing" # dumb workaround to failure of match.call() for now...
class(call) <- "call" # force class to be what biotmle expects...

biotmle <- .biotmle(
  SummarizedExperiment(
    assays = list(expMeasures = assay(se)),
    rowData = rowData(se),
    colData = colData(se)
  ),
  call = call,
  tmleOut = as.data.frame(matrix(NA, 10, 10)),
  topTable = as.data.frame(matrix(NA, 10, 10))
)

voom_out <- rnaseq_ic(biotmle)

################################################################################
## BEGIN TESTS #################################################################
################################################################################

test_that("Object returned by RNA-seq tools matches output of voom", {
  expect_is(voom_out, "EList")
})

test_that("Object returned by RNA-seq tools is of correct dimensionality", {
  expect_equal(dim(voom_out), c(g, 2 * n))
})
