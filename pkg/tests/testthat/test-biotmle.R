library(tmlelimma)
context("Testing construction of S3 class.")

test_that("biotmle generates equivalent objects when called with same inputs", {

  expect_equal( biotmle(call = NULL, topTable = NULL, limmaOut = NULL,
                        tmleOut = NULL),
                biotmle(call = NULL, topTable = NULL, limmaOut = NULL,
                        tmleOut = NULL)
              )

})
