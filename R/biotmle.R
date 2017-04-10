utils::globalVariables(c("new"))
#' Constructor for class biotmle
#'
#' @return class \code{biotmle} object, sub-classed from SummarizedExperiment.
#'
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#' @importClassesFrom limma EList
#'
#' @export .biotmle
#' @exportClass bioTMLE
#'
#' @examples
#' library(biotmleData)
#' data(illuminaData)
#' library(SummarizedExperiment)
#'
#' example_biotmle_class <- function(se) {
#'
#'     call <- match.call(expand.dots = TRUE)
#'     biotmle <- .biotmle(
#'           SummarizedExperiment(
#'              assays = assay(se),
#'              rowData = rowData(se),
#'              rowRanges = rowRanges(se),
#'              colData = colData(se)
#'           ),
#'           call = call,
#'           tmleOut = as.data.frame(matrix(NA, 10, 10)),
#'           modtestOut = as.data.frame(matrix(NA, 10, 10)),
#'           topTable = as.data.frame(matrix(NA, 10, 10))
#'     )
#'     return(biotmle)
#' }
#'
#' example_class <- example_biotmle_class(se = illuminaData)
#'
setClassUnion("call_char", c("call", "character"))
setClassUnion("data.frame_OR_EList", c("data.frame", "EList"))

.biotmle <- setClass(
       Class = "bioTMLE",
       slots = list(call = "call_char",
                    tmleOut = "data.frame_OR_EList",
                    modtestOut = "data.frame",
                    topTable = "data.frame"),
       contains = "SummarizedExperiment"
)
