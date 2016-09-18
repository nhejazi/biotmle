#' Targeted Minimum Loss-Based Estimation to estimate the Average Treatment
#' Effect parameter based on changes in gene expression levels
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
#'               default = binomial
#' @param parallel whether to use foreach style parallelization procedure
#'                 default = TRUE
#'
#' @importFrom tmle tmle
#' @importFrom foreach foreach "%dopar%"
#' @importFrom parallel detectCores
#' @importFrom doParallel registerDoParallel
#'
#' @return
#' A list of data.frames for the multi-level TMLE estimates of genomic effects.
#'
#' @export tmle.multiATE
#'
#' @examples
#'

tmle.multiATE <- function(W, A, Y, a = 1, g.lib, Q.lib, family = "binomial",
                          parallel = TRUE) {
  if (parallel) {
    n_Cores <- detectCores()
    registerDoParallel(n_Cores)
  } else {
    warning("parallelization has been set to FALSE: the ATE estimation procedure
             will likely take on the order of days/weeks to run to completion.")
  }

  ATE <- foreach::foreach(gene = 1:ncol(A), .combine = rbind) foreach::%dopar% {
    print(paste("estimating casual effect", gene, "of", ncol(A), ". Gene ID:",
                 colnames(A)[gene]))
    out <- tmle.multi(W = W, A = A[, gene], Y = Y$Y, a = a, g.lib, Q.lib,
                      family = "binomial", parallel = FALSE)
  }
  ATE <- as.data.frame(ATE)
  return(ATE)
}
