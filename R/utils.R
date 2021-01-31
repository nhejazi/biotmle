#' S4 class union data.frame_OR_EList
#'
#' @description Virtual class union containing members of \code{data.frame} and
#'  \code{limma::Elist}, used internally to handle situations when a returned
#'  object has a type that cannot be guessed from the function call.
#'
#' @return fusion of classes \code{data.frame} and \code{EList}, used within
#'  \code{.biotmle} by class \code{bioTMLE} to handle uncertainty in the object
#'  passed to slot "tmleOut".
#'
#' @importFrom methods setClassUnion new
#' @importClassesFrom methods data.frame
#' @importClassesFrom limma EList
#' @importClassesFrom S4Vectors Vector Annotated
#'
#' @export
setClassUnion(
  name = "data.frame_OR_EList",
  members = c("data.frame", "EList")
)

###############################################################################

#' Constructor for class bioTMLE
#'
#' @return class \code{biotmle} object, sub-classed from SummarizedExperiment.
#'
#' @import BiocGenerics
#' @importClassesFrom SummarizedExperiment SummarizedExperiment
#' @importFrom methods setClass
#'
#' @export .biotmle
#' @exportClass bioTMLE
#'
#' @rdname bioTMLE-class
#'
#' @examples
#' library(SummarizedExperiment)
#' library(biotmleData)
#' data(illuminaData)
#'
#' example_biotmle_class <- function(se) {
#'   call <- match.call(expand.dots = TRUE)
#'   biotmle <- .biotmle(
#'     SummarizedExperiment(
#'       assays = assay(se),
#'       rowData = rowData(se),
#'       colData = colData(se)
#'     ),
#'     call = call,
#'     ateOut = as.numeric(rep(NA, 10)),
#'     tmleOut = as.data.frame(matrix(NA, 10, 10)),
#'     topTable = as.data.frame(matrix(NA, 10, 10))
#'   )
#'   return(biotmle)
#' }
#'
#' example_class <- example_biotmle_class(se = illuminaData)
.biotmle <- methods::setClass(
  Class = "bioTMLE",
  slots = list(
    call = "call",
    ateOut = "vector",
    tmleOut = "data.frame_OR_EList",
    topTable = "data.frame"
  ),
  contains = "SummarizedExperiment"
)

###############################################################################

#' Accessor for Table of Raw Efficient Influence Function Values
#'
#' @param object S4 object of class \code{bioTMLE}.
#'
#' @importFrom methods is
#' @importFrom assertthat assert_that
#'
#' @return contents of \code{tmleOut} slot of object of class \code{biotmle}.
#'
#' @export
eif <- function(object) {
  assertthat::assert_that(is(object, "bioTMLE"))
  object@tmleOut
}

###############################################################################

#' Accessor for Results of Moderated Influence Function Hypothesis Testing
#'
#' @param object S4 object of class \code{bioTMLE}.
#'
#' @importFrom methods is
#' @importFrom assertthat assert_that
#'
#' @return contents of \code{topTable} slot of object of class \code{biotmle}.
#'
#' @export
toptable <- function(object) {
  assertthat::assert_that(is(object, "bioTMLE"))
  object@topTable
}
