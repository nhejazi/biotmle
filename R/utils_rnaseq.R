#' Transformation utility for using "voom" with biomarker TMLE procedure
#'
#' This function prepares next-generation sequencing data (counts) for use with
#' the biomarker TMLE procedure by invoking the voom transform of \code{limma}.
#'
#' @param biotmle (bioTMLE) - subclass of \code{SummarizedExperiment} containing
#'  next-generation sequencing (NGS) count data in the "assays" slot.
#' @param weights (logical) - whether to return quality weights of samples in
#'  the output object.
#' @param ... - other arguments to be passed to functions \code{limma::voom} or
#'  \code{limma::voomWithQualityWeights} as appropriate.
#'
#' @importFrom tibble as_tibble
#' @importFrom limma voom voomWithQualityWeights
#' @importFrom SummarizedExperiment assay
#'
#' @export rnaseq_ic
#'
#' @return \code{EList} object containing voom-transformed "expression" measures
#'  of count data (actually, the mean-variance trend) in the "E" slot, to be
#'  passed into the biomarker TMLE procedure.
#
rnaseq_ic <- function(biotmle, weights = TRUE, ...) {

  # check arguments
  stopifnot(class(biotmle) == "bioTMLE")
  stopifnot(class(weights) == "logical")

  # extract count data from appropriate slot of SummarizedExperiment object
  ngs_data <- tibble::as_tibble(assay(biotmle))

  # invoke the "voom" transform from LIMMA
  if (weights) {
    voom_data <- limma::voomWithQualityWeights(ngs_data,
      normalize.method = "scale",
      ...
    )
  } else {
    voom_data <- limma::voom(ngs_data,
                             normalize.method = "scale",
                             ...)
  }
  return(voom_data)
}
