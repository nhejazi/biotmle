library(dplyr)
library(biotmle)
library(biotmleData)
library(SummarizedExperiment)
data(illuminaData)

context("moderated testing of influence curve-based estimates.")

################################################################################
## SETUP TESTS #################################################################
################################################################################

colData(illuminaData) <- colData(illuminaData) %>%
  data.frame %>%
  dplyr::mutate(age = as.numeric(age > median(age))) %>%
  DataFrame

varInt_index <- which(names(colData(illuminaData)) %in% "benzene")

biomarkerTMLEout <- biomarkertmle(se = illuminaData[1:2, ],
                                  varInt = varInt_index,
                                  parallel = FALSE,
                                  family = "gaussian",
                                  g_lib = c("SL.mean", "SL.glm"),
                                  Q_lib = "SL.mean"
                                 )

limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)

################################################################################
## BEGIN TESTS #################################################################
################################################################################

test_that("modtest_ic output object is of class type S4", {
  expect_equivalent(typeof(limmaTMLEout), "S4")
})

test_that("modtest_ic output is of appropriate custom class", {
  expect_equivalent(class(limmaTMLEout), "bioTMLE")
})

test_that("modtest_ic output contains data frame in topTable slot", {
  expect_equivalent(class(limmaTMLEout@topTable), "data.frame")
})

test_that("topTable slot has column names produced by limma::topTable", {
  expect_named(limmaTMLEout@topTable,
               c("logFC", "AveExpr", "t", "P.Value", "adj.P.Val", "B", "IDs"))
})
