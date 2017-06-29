utils::globalVariables(c("new"))

#' Constructor for class union data.frame_OR_EList
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
methods::setClassUnion("data.frame_OR_EList", c("data.frame", "EList"))

################################################################################

#' Constructor for class bioTMLE
#'
#' @return class \code{biotmle} object, sub-classed from SummarizedExperiment.
#'
#' @importFrom methods setClass
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#'
#' @export
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
       slots = list(call = "call",
                    tmleOut = "data.frame_OR_EList",
                    topTable = "data.frame"),
       contains = "SummarizedExperiment"
)
