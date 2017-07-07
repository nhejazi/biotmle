library(dplyr)
library(biotmle)
library(biotmleData)
library(SummarizedExperiment)
data(illuminaData)
"%ni%" = Negate("%in%")

context("biomarkertmle estimation function.")

################################################################################
## SETUP TESTS #################################################################
################################################################################

colData(illuminaData) <- colData(illuminaData) %>%
  data.frame %>%
  dplyr::mutate(age = as.numeric(age > median(age))) %>%
  DataFrame

varInt_index <- which(names(colData(illuminaData)) %in% "benzene")

biomarkerTMLEout <- biomarkertmle(se = illuminaData[1, ],
                                  varInt = varInt_index,
                                  type = "exposure",
                                  parallel = 1,
                                  family = "gaussian",
                                  g_lib = c("SL.mean"),
                                  Q_lib = c("SL.mean")
                                 )

################################################################################
## BEGIN TESTS #################################################################
################################################################################

test_that("biomarkertmle output object is of class type S4", {
  expect_equivalent(typeof(biomarkerTMLEout), "S4")
})

test_that("biomarkertmle object is of appropriate custom class", {
  expect_equivalent(class(biomarkerTMLEout), "bioTMLE")
})

test_that("biomarkertmle output is consistent using example data", {
  expect_equal(assay(biomarkerTMLEout)[, c(17, 83, 117)],
               c(360.7073, 375.9316, 319.3649))
})

test_that("biomarkertmle output returns IC estimate for each subject", {
  expect_equal(ncol(assay(biomarkerTMLEout)), ncol(illuminaData))
})
