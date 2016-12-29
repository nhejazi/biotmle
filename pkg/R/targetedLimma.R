#' Moderated T-Statistic Test for Asymptotically Linear Target Parameters
#'
#' Performs variance shrinkage via empirical Bayes procedures on influence
#' curve transforms of the Average Treatment Effect of gene expression
#' changes on the outcome of interest
#'
#' @param biomarkerTMLEout a generic object generated as output from the TMLE
#'        procedure implemented in \code{biomarkerTMLE}
#' @param designMat a design matrix providing the contrasts to be used in the
#'        linear model fitting procedure of \code{limma::lmFit}
#' @param ... additional arguments to be passed to functions from \code{limma}
#'
#' @importFrom limma lmFit eBayes topTable
#'
#' @return
#' A list containing two objects: (1) model fit returned by \code{limma::lmFit}
#'                                (2) results table from \code{limma::topTable}
#'
#' @export limmaTMLE
#'

limmaTMLE <- function(biomarkerTMLEout, designMat, ...) {

  limmaTMLEout <- vector("list", 2)
  fit <- limma::lmFit(as.data.frame(biomarkerTMLEout), designMat)
  fit <- limma::eBayes(fit)
  tt <- limma::topTable(fit, coef = 2, adjust.method = "BH", sort.by = "none",
                        number = Inf)
  tt$IDs <- rownames(biomarkerTMLEout)
  limmaTMLEout[[1]] <- fit
  limmaTMLEout[[2]] <- tt
  return(limmaTMLEout)
}
