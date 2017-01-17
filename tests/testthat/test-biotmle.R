library(biotmle)
context("Testing constructor for S3 class.")

test_that("biotmle generates equivalent objects when called with same inputs", {

  expect_equivalent( biotmle(call = NULL, topTable = NULL, limmaOut = NULL,
                             tmleOut = NULL),
                     biotmle(call = NULL, topTable = NULL, limmaOut = NULL,
                             tmleOut = NULL)
              )

})
