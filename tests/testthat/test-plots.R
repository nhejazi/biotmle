library(SummarizedExperiment)

## SETUP TESTS ################################################################
## A synthetic bioTMLE object is built directly, avoiding the cost of a full
## TMLE fit, since these tests exercise only the plotting code.
set.seed(74782)
n_bmark <- 20
n_obs <- 16
design <- rep(c(0, 1), each = n_obs / 2)
bmark_ids <- paste0("bmark", seq_len(n_bmark))
obs_ids <- paste0("obs", seq_len(n_obs))

eif_mat <- matrix(rnorm(n_bmark * n_obs),
  nrow = n_bmark,
  dimnames = list(bmark_ids, obs_ids)
)
## the first five biomarkers respond to the exposure
eif_mat[seq_len(5), design == 1] <- eif_mat[seq_len(5), design == 1] + 3
## a biomarker with no variation, to exercise the standardization guard
eif_mat[n_bmark, ] <- 0

se <- SummarizedExperiment(
  assays = list(expMeasures = eif_mat),
  colData = DataFrame(benzene = design, row.names = obs_ids)
)

top_table <- data.frame(
  ID = bmark_ids,
  adj.P.Val = c(runif(5, 0, 0.01), runif(n_bmark - 5, 0.3, 1)),
  stringsAsFactors = FALSE
)

biotmle_obj <- .biotmle(se,
  call = quote(biomarkertmle()),
  ateOut = rep(NA_real_, n_bmark),
  tmleOut = as.data.frame(eif_mat),
  topTable = top_table
)

## BEGIN TESTS ################################################################
test_that("heatmap_ic returns an object of class ggplot", {
  p <- heatmap_ic(x = biotmle_obj, design = design, FDRcutoff = 0.05, top = 5)
  expect_s3_class(p, "ggplot")
})

test_that("heatmap_ic renders without error", {
  p <- heatmap_ic(x = biotmle_obj, design = design, FDRcutoff = 0.05, top = 5)
  expect_error(ggplot2::ggplot_build(p), NA)
})

test_that("heatmap_ic plots only the requested top biomarkers", {
  p <- heatmap_ic(x = biotmle_obj, design = design, FDRcutoff = 0.05, top = 5)
  plotted <- unique(as.character(p$data$biomarker))
  expect_setequal(plotted, top_table$ID[order(top_table$adj.P.Val)][seq_len(5)])
})

test_that("heatmap_ic with type = 'all' retains every biomarker", {
  p <- heatmap_ic(x = biotmle_obj, design = design, type = "all")
  expect_equal(length(unique(as.character(p$data$biomarker))), n_bmark)
})

test_that("heatmap_ic preserves the EIF values when unscaled", {
  p <- heatmap_ic(
    x = biotmle_obj, design = design, type = "all", scale = FALSE
  )
  recon <- matrix(NA_real_,
    nrow = n_bmark, ncol = n_obs,
    dimnames = dimnames(eif_mat)
  )
  recon[cbind(
    as.character(p$data$biomarker),
    as.character(p$data$subject)
  )] <- p$data$eif_contrib
  expect_equal(recon, eif_mat)
})

test_that("heatmap_ic standardizes biomarkers when scale = TRUE", {
  p <- heatmap_ic(x = biotmle_obj, design = design, type = "all", scale = TRUE)
  by_bmark <- split(p$data$eif_contrib, as.character(p$data$biomarker))
  varying <- by_bmark[names(by_bmark) != bmark_ids[n_bmark]]
  expect_true(all(abs(vapply(varying, sd, numeric(1)) - 1) < 1e-8))
})

test_that("heatmap_ic leaves an invariant biomarker free of NaN", {
  p <- heatmap_ic(x = biotmle_obj, design = design, type = "all", scale = TRUE)
  invariant <- p$data$eif_contrib[
    as.character(p$data$biomarker) == bmark_ids[n_bmark]
  ]
  expect_false(any(is.na(invariant)))
})

test_that("heatmap_ic groups observations by the supplied design", {
  p <- heatmap_ic(x = biotmle_obj, design = design, type = "all")
  groups <- unique(p$data[, c("subject", "group")])
  expected <- ifelse(design == 0, "Control", "Treated")
  names(expected) <- obs_ids
  expect_equal(
    as.character(groups$group),
    unname(expected[as.character(groups$subject)])
  )
})

test_that("heatmap_ic rejects a design of the wrong length", {
  expect_error(
    heatmap_ic(x = biotmle_obj, design = design[seq_len(3)], type = "all")
  )
})

test_that("volcano_ic returns an object of class ggplot", {
  vp_table <- data.frame(
    ID = bmark_ids,
    AveExpr = rnorm(n_bmark),
    P.Value = runif(n_bmark),
    adj.P.Val = runif(n_bmark),
    stringsAsFactors = FALSE
  )
  vp_obj <- .biotmle(se,
    call = quote(biomarkertmle()),
    ateOut = rep(NA_real_, n_bmark),
    tmleOut = as.data.frame(eif_mat),
    topTable = vp_table
  )
  expect_s3_class(volcano_ic(biotmle = vp_obj), "ggplot")
})
