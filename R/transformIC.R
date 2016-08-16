#' The Influence Curve (IC) transform of a genomic data via TMLE estimation
#'
#' Computes the causal point estimate of the expression effect of a gene on the
#' outcome of interest via Targeted Minimum Loss-Based Estimation
#'
#' @param W the data.frame corresponding to gene expression or similar data
#' @param A the covariate whose effect on the outcome is to be estimated
#' @param Y the outcome of interest, thought to be causally related to genes W
#'
#' @details
#' Calls function \code{multilevelTMLE} and gathers only the output for...
#'
#' @export
#'
#' @return
#' A list of data.frames for the multi-level TMLE estimates of genomic effects.
#'
#' @examples
#'

set.seed(0) #filler
