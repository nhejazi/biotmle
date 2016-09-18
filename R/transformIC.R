#' The Influence Curve (IC) transform of genomic data via TMLE
#'
#' Computes the risk difference parameter for the expression level of a gene
#' on the outcome of interest via Targeted Minimum Loss-Based Estimation
#'
#' @param W the data.frame corresponding to gene expression or similar data
#' @param A the covariate whose effect on the outcome is to be estimated
#' @param Y the outcome of interest, thought to be related to genes W
#' @param a the level of A against which comparisons performed (default = 1)
#' @param g.lib library...
#' @param Q.lib library...
#' @param family type of link function to be used given the outcome of interest
#' @param parallel whether to use foreach style parallelization procedure
#'
#' @importFrom tmle tmle
#' @importFrom foreach foreach "%dopar%"
#' @importFrom parallel detectCores
#' @importFrom doParallel registerDoParallel
#'
#' @return
#' A list of data.frames for the multi-level TMLE estimates of genomic effects.
#'
#' @export tmle.multi
#'
#' @examples
#'

tmle.multi = function(W, A, Y, a = 1, g.lib, Q.lib, family = "binomial",
                      parallel = FALSE) {
  IC = NULL
  theta = NULL
  n_a = length(a)
  n_A = length(A)  #is there a reason that we define this?

  if (parallel) {
    if (parallel::detectCores() == 1) {
      stop("argument parallel is TRUE yet failed to detect multiple cores")
    } else {
      doParallel::registerDoParallel(parallel::detectCores())
    }
  }

  if (parallel) {
    foreach::foreach (i = 1:n_a) foreach::%dopar% {
      A_star = as.numeric(A == a[i])
      tmle.0 = tmle(Y, A_star, W, g.SL.library = g.lib, Q.SL.library = Q.lib,
                    family = family, verbose = FALSE)
      g_0 = tmle.0$g$g1W
      Qst_0 = tmle.0$Qstar[, 2]
      Ey_0 = mean(Qst_0)
      IC = cbind(IC, (A_star / g_0) * (Y - Qst_0) + Qst_0 - Ey_0)
      theta = c(theta, mean(Qst_0))
    }
  } else {
    for (i in 1:n_a) {
      A_star = as.numeric(A == a[i])
      tmle.0 = tmle(Y, A_star, W, g.SL.library = g.lib, Q.SL.library = Q.lib,
                    family = family, verbose = FALSE)
      g_0 = tmle.0$g$g1W
      Qst_0 = tmle.0$Qstar[, 2]
      Ey_0 = mean(Qst_0)
      IC = cbind(IC, (A_star / g_0) * (Y - Qst_0) + Qst_0 - Ey_0)
      theta = c(theta, mean(Qst_0))
    }
  }

  ICd = IC[, 2:n_a] - IC[, 1] #last column for Limma
  psi = theta[2:n_a] - theta[1]
  psi = c(NA, psi)
  se = sqrt(apply(ICd, 2, var) / n_A)
  se = c(NA, se)
  lowr = psi - 1.96 * se
  uppr = psi + 1.96 * se
  CI95 = paste(round(lowr, 5), "-", round(uppr, 5), sep = "")
  pvalue = 2 * (1 - pnorm(abs(psi / se)))

  out = ICd[, 3]
  return(out)
}
