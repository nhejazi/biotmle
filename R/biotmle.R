utils::globalVariables(c("new"))
#' Constructor for class biotmle
#'
#' @return class \code{biotmle} object, sub-classed from SummarizedExperiment.
#'
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
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
.biotmle <- setClass(
       Class = "bioTMLE",
       slots = list(call = "call",
                    tmleOut = c("data.frame", "EList"),
                    modtestOut = "data.frame",
                    topTable = "data.frame"),
       contains = "SummarizedExperiment"
)
