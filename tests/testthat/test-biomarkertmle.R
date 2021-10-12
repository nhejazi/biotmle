library(dplyr)
library(biotmleData)
library(SuperLearner)
library(SummarizedExperiment)
data(illuminaData)

## SETUP TESTS ################################################################
colData(illuminaData) <- colData(illuminaData) %>%
  data.frame() %>%
  mutate(age = as.numeric(age > median(age))) %>%
  DataFrame()
varInt_index <- which(names(colData(illuminaData)) %in% "benzene")

biomarkerTMLEout <- biomarkertmle(
  se = illuminaData[1:2, ],
  varInt = varInt_index,
  bppar_type = BiocParallel::SerialParam(),
  g_lib = c("SL.mean", "SL.glm"),
  Q_lib = c("SL.mean", "SL.glm")
)

## BEGIN TESTS ################################################################
test_that("biomarkertmle output object is of class type S4", {
  expect_equivalent(typeof(biomarkerTMLEout), "S4")
})

test_that("biomarkertmle object is of appropriate custom class", {
  expect_equivalent(class(biomarkerTMLEout), "bioTMLE")
})

test_that("biomarkertmle consistently stores input example data", {
  expect_equal(
    assay(biomarkerTMLEout)[1, c(17, 83, 117)],
    assay(illuminaData)[1, c(17, 83, 117)],
  )
})

test_that("biomarkertmle output returns IC estimate for each subject", {
  expect_equal(ncol(assay(biomarkerTMLEout)), ncol(illuminaData))
})
