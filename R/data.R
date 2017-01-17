#' Baseline covariates and Illumina microarray data from 2007 study
#'
#' A dataset containing various baseline covariates and microarray expression
#' measures from Illumina arrays used in a 2007 study.
#'
#' @format A \code{data.frame} with 144 rows and 22196 variables:
#' \describe{
#'   This is example data to be used in testing the \code{biomarkertmle}
#'   procedure. Consult the vignettes for how to use this data.
#' }
#' @return A \code{data.frame} containing biomarkers and baseline covariates.
#'
"illuminaData"

#' Results obtained from running the biomarkertmle on illumina2007 data
#'
#' Example results obtained from running the TMLE-based estimation procedure on
#' the example data included with this package (\code{illuminaData}).
#'
#' @format A \code{biotmle} object containing the results of running
#'         \code{biomarkertmle}.
#' \describe{
#'   These results are included here for the sake of making the vignettes build
#'   more quickly. The user will likely not benefit from using this data set.
#' }
#' @return A \code{biotmle} object containing results from \code{biomarkertmle}.
#'
"biomarkerTMLEout"
