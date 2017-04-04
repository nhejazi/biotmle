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
.biotmle <- setClass(
       Class = "bioTMLE",
       slots = list(call = "call",
                    tmleOut = "data.frame",
                    modtestOut = "data.frame",
                    topTable = "data.frame"),
       contains = "SummarizedExperiment"
)
