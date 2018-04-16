utils::globalVariables(c("new"))

#' S4 class union data.frame_OR_EList
#'
#' @description Class union contaning \code{data.frame} and \code{limma::Elist},
#'              used internally to handle situations when a returned object has
#'              a type that cannot be guessed from the function call.
#'
#' @return fusion of classes \code{data.frame} and \code{EList}, used within
#'         \code{.biotmle} by class \code{bioTMLE} to handle uncertainty in the
#'         object passed to slot "tmleOut".
#'
#' @importFrom methods setClassUnion
#' @importClassesFrom limma EList
#'
#' @export
#'
setClassUnion(
  name = "data.frame_OR_EList",
  members = c("data.frame", "EList")
)

################################################################################

#' Constructor for class bioTMLE
#'
#' @return class \code{biotmle} object, sub-classed from SummarizedExperiment.
#'
#' @importFrom methods setClass
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#'
#' @export .biotmle
#' @exportClass bioTMLE
#'
#' @examples
#' library(SummarizedExperiment)
#' library(biotmleData)
#' data(illuminaData)
#'
#' example_biotmle_class <- function(se) {
#'
#'     call <- match.call(expand.dots = TRUE)
#'     biotmle <- .biotmle(
#'           SummarizedExperiment(
#'              assays = assay(se),
#'              rowData = rowData(se),
#'              colData = colData(se)
#'           ),
#'           call = call,
#'           tmleOut = as.data.frame(matrix(NA, 10, 10)),
#'           topTable = as.data.frame(matrix(NA, 10, 10))
#'     )
#'     return(biotmle)
#' }
#'
#' example_class <- example_biotmle_class(se = illuminaData)
#'
.biotmle <- methods::setClass(
  Class = "bioTMLE",
  slots = list(
    call = "call",
    tmleOut = "data.frame_OR_EList",
    topTable = "data.frame"
  ),
  contains = "SummarizedExperiment"
)
