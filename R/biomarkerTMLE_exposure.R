#' TMLE procedure for Biomarker Identication from Exposure
#'
#' This function performs influence curve-based estimation of the effect of an
#' exposure on biological expression values associated with a given biomarker,
#' controlling for a user-specified set of baseline covariates
#'
#' @param Y (numeric vector) - a vector of expression values for a single
#'        biomarker.
#' @param W (numeric matrix) - a matrix of baseline covariates to be controlled
#'        in the estimation process.
#' @param A (numeric vector) - a discretized exposure vector (e.g., from a
#'        design matrix whose effect on expression values is of interest.
#' @param a (numeric vector) - the levels of A against which comparisons are to
#'        be made.
#' @param subj_ids (numeric vector) - subject IDs to be passed directly to
#         \code{tmle::tmle} when there are repeated measures; measurements on
#'        the same subject should have the exact same numerical identifier.
#'        coerced to numeric if not provided in the appropriate form.
#' @param g_lib (char vector) - library of learning algorithms to be used in
#'        fitting the "g" step of the standard TMLE procedure.
#' @param Q_lib (char vector) - library of learning algorithms to be used in
#'        fitting the "Q" step of the standard TMLE procedure.
#' @param family (character) - specification of error family: "binomial" or
#'        "gaussian"
#'
#' @importFrom tmle tmle
#'
#' @return TMLE-based estimate of the relationship between biomarker expression
#'         and changes in an exposure variable, computed iteratively and saved
#'         in the \code{tmleOut} slot in a \code{biotmle} object.
#'

biomarkerTMLE_exposure <- function(Y,
                                   W,
                                   A,
                                   a,
                                   subj_ids = NULL,
                                   family = "gaussian",
                                   g_lib,
                                   Q_lib) {

  # check the case that Y is passed in as a column of a data.frame
  if (class(Y) == "data.frame") Y <- as.numeric(Y[, 1])
  if (class(A) == "data.frame") A <- as.numeric(A[, 1])
  if (length(a) == 1) {
    warning("Comparisons should be made against a particular level of A.")
  }

  n_a = length(a)
  IC = NULL
  EY = NULL

  if(!is.null(subj_ids)) {
    subj_ids <- as.numeric(subj_ids)
  }

  for(i in 1:n_a) {
    A_star = as.numeric(A == a[i])
    fit_tmle = tmle::tmle(Y = Y,
                          A = A_star,
                          W = W,
                          g.SL.library = g_lib,
                          Q.SL.library = Q_lib,
                          family = family,
                          id = subj_ids,
                          verbose = FALSE
                         )
    g_0 = fit_tmle$g$g1W
    Qst_0 = fit_tmle$Qstar[, 2]
    EY_0 = mean(Qst_0)
    EY = c(EY, EY_0)
    IC = cbind(IC, (A_star / g_0) * (Y - Qst_0) + Qst_0 - EY_0)
  }

  EY_diff = EY[2:n_a] - EY[1]
  IC_diff = IC[, 2:n_a] - IC[, 1]

  if(class(IC_diff) != "numeric") {
    output = IC_diff[, ncol(IC_diff)] + EY_diff[length(EY_diff)]
  } else {
    output = IC_diff + EY_diff
  }
  return(output)
}
