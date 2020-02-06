#' Utility for using voom transformation with TMLE for biomarker discovery
#'
#' This function prepares next-generation sequencing data (counts) for use with
#' the biomarker TMLE procedure by invoking the voom transform of \code{limma}.
#'
#' @param biotmle A \code{bioTMLE} object containing next-generation sequencing
#'  count data in its "assays" slot.
#' @param weights A \code{logical} indicating whether to return quality weights
#'  of samples in the output object.
#' @param ... Other arguments to be passed to \code{\link[limma]{voom}} or
#'  \code{\link[limma]{voomWithQualityWeights}} as appropriate.
#'
#' @importFrom tibble as_tibble
#' @importFrom limma voom voomWithQualityWeights
#' @importFrom SummarizedExperiment assay
#' @importFrom assertthat assert_that
#' @importFrom methods is
#'
#' @export rnaseq_ic
#'
#' @return \code{EList} object containing voom-transformed "expression" measures
#'  of count data (actually, the mean-variance trend) in the "E" slot, to be
#'  passed into the biomarker TMLE procedure.
#
rnaseq_ic <- function(biotmle, weights = TRUE, ...) {
  # check arguments
  assertthat::assert_that(is(biotmle, "bioTMLE"))
  assertthat::assert_that(is.logical(weights))

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
      ...
    )
  }
  return(voom_data)
}
