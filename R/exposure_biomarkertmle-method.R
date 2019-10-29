#' TMLE procedure using ATE for Biomarker Identication from Exposure
#'
#' This function performs influence curve-based estimation of the effect of an
#' exposure on biological expression values associated with a given biomarker,
#' controlling for a user-specified set of baseline covariates.
#'
#' @param Y A \code{numeric} vector of expression values for a single biomarker.
#' @param W A \code{Matrix} of \code{numeric} values corresponding to baseline
#'  covariates to be marginalized over in the estimation process.
#' @param A A \code{numeric} vector of discretized exposure vector (e.g., from a
#'  design matrix whose effect on expression values is of interest.
#' @param a The \code{numeric} value indicating levels of \code{A} above against
#'  which comparisons are to be made.
#' @param subj_ids A \code{numeric} vector of subject IDs to be passed directly
#'  to \code{\link[tmle]{tmle}} when there are repeated measures; measurements
#'  on the same subject should have the exact same numerical identifier. The
#'  correction performed utilizes a more conservative estimator of the variance
#'  based on the efficient influence function.
#' @param g_lib A \code{character} vector identifying the library of learning
#'  algorithms to be used in fitting the propensity score P[A = 1 | W].
#' @param Q_lib A \code{character} vector identifying the library of learning
#'  algorithms to be used in fitting the outcome regression E[Y | A, W].
#' @param cv_folds A \code{numeric} scalar indicating how many folds to use in
#'  performing targeted minimum loss estimation. Cross-validated estimates are
#'  more robust, allowing relaxing of theoretical conditions and construction of
#'  conservative variance estimates.
#' @param ... Additional arguments passed to \code{\link[tmle]{tmle}} in fitting
#'  the targeted minimum loss estimator of the average treatment effect.
#'
#' @importFrom assertthat assert_that
#' @importFrom tmle tmle
#'
#' @return TMLE-based estimate of the relationship between biomarker expression
#'  and changes in an exposure variable, computed iteratively and saved in the
#'  \code{tmleOut} slot in a \code{biotmle} object.
#
biomarkerTMLE_exposure <- function(Y,
                                   W,
                                   A,
                                   a,
                                   subj_ids = NULL,
                                   g_lib,
                                   Q_lib,
                                   cv_folds = 5,
                                   ...) {
  # check the case that Y is passed in as a column of a data.frame
  if (any(class(Y) == "data.frame")) Y <- as.numeric(unlist(Y[, 1]))
  if (any(class(A) == "data.frame")) A <- as.numeric(unlist(A[, 1]))
  if (is.null(subj_ids)) {
    subj_ids <- seq_along(Y)
  } else {
    subj_ids <- as.numeric(subj_ids)
  }
  assertthat::assert_that(length(a) > 1)

  # initialize
  eif <- NULL
  EY <- NULL

  for (i in seq_along(a)) {
    A_star <- as.numeric(A == a[i])
    fit_tmle <- tmle::tmle(
      Y = Y,
      A = A_star,
      W = W,
      g.SL.library = g_lib,
      Q.SL.library = Q_lib,
      id = subj_ids,
      V = cv_folds,
      prescreenW.g = FALSE,
      target.gwt = FALSE,
      verbose = FALSE,
      ...
    )
    g_0 <- fit_tmle$g$g1W
    Qst_0 <- fit_tmle$Qstar[, 2]
    EY_0 <- mean(Qst_0)
    EY <- c(EY, EY_0)
    eif <- cbind(eif, (A_star / g_0) * (Y - Qst_0) + Qst_0 - EY_0)
  }
  EY_diff <- EY[seq_along(a)[-1]] - EY[1]
  eif_diff <- eif[, seq_along(a)[-1]] - eif[, 1]

  if (class(eif_diff) != "numeric") {
    output <- eif_diff[, ncol(eif_diff)] + EY_diff[length(EY_diff)]
  } else {
    output <- eif_diff + EY_diff
  }
  return(output)
}
