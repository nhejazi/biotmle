library(SummarizedExperiment)
library(biotmleData)
data(illuminaData)

## SETUP TESTS ################################################################
example_biotmle_class <- function(se) {
  call <- match.call(expand.dots = TRUE)
  biotmle <- .biotmle(
    SummarizedExperiment(
      assays = assay(se),
      rowData = rowData(se),
      colData = colData(se)
    ),
    call = call,
    tmleOut = as.data.frame(matrix(NA, 10, 10)),
    topTable = as.data.frame(matrix(NA, 10, 10))
  )
  return(biotmle)
}
biotmle <- example_biotmle_class(se = illuminaData)

## BEGIN TESTS ################################################################
test_that("biotmle object is of class type S4", {
  expect_equivalent(typeof(biotmle), "S4")
})

test_that("biotmle object is of appropriate class", {
  expect_equivalent(class(biotmle), "bioTMLE")
})

test_that("biotmle is a subclass of SummarizedExperiment", {
  expect_is(biotmle, "SummarizedExperiment")
})
