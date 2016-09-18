#' Variance Shrinkage of Linear Models for Microarrays on ATE parameter
#' estimated via Targeted Minimum Loss-Based Estimation
#'
#' Performs variance shrinkage via empirical Bayes procedures on influence
#' curve transforms of the Average Treatment Effect of gene expression
#' changes on the outcome of interest
#'
#' @param ATE the average treatment effect of gene expression change on an
#'            outcome of interest, as computed by \code{tmle.multiATE}
#' @param Y the vector corresponding to the outcome of interest
#'
#' @importFrom limma limma
#'
#' @return
#' A list containing two objects: (1) model fit returned by \code{limma::lmFit}
#'                                (2) results table from \code{limma::topTable}
#'
#' @export tmle.limma
#'
#' @examples
#'

tmle.limma <- function(ATE, Y) {
  out <- vector("list", 2)
  design <- as.data.frame(cbind(rep(1, nrow(Y)), Y$Y))
  colnames(design) <- c("intercept", "Tx")
  fit <- limma::lmFit(as.data.frame(ATE), design)
  fit <- limma::eBayes(fit)
  tt <- limma::topTable(fit, coef = 2, adjust.method = "BH", sorty.by = "none",
                        number = Inf)
  out[[1]] <- fit
  out[[2]] <- tt
  return(out)
}
