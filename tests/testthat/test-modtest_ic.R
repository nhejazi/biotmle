context("moderated testing of influence curve-based estimates.")
library(dplyr)
library(biotmleData)
library(SuperLearner)
library(SummarizedExperiment)
data(illuminaData)

## SETUP TESTS #################################################################
colData(illuminaData) <- colData(illuminaData) %>%
  data.frame() %>%
  dplyr::mutate(age = as.numeric(age > median(age))) %>%
  DataFrame()
varInt_index <- which(names(colData(illuminaData)) %in% "benzene")

biomarkerTMLEout <- biomarkertmle(
  se = illuminaData[1:2, ],
  varInt = varInt_index,
  parallel = FALSE,
  g_lib = c("SL.mean", "SL.glm"),
  Q_lib = "SL.mean"
)
limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)

## BEGIN TESTS #################################################################
test_that("modtest_ic output object is of class type S4", {
  expect_equivalent(typeof(limmaTMLEout), "S4")
})

test_that("modtest_ic output is of appropriate custom class", {
  expect_equivalent(class(limmaTMLEout), "bioTMLE")
})

test_that("modtest_ic output contains data frame in topTable slot", {
  expect_true(any(class(limmaTMLEout@topTable) == "data.frame"))
})

test_that("topTable slot has most column names produced by limma::topTable", {
  expect_named(
    limmaTMLEout@topTable,
    c("ID", "AveExpr", "t", "P.Value", "adj.P.Val", "B", "var_bayes")
  )
})
