utils::globalVariables("gene")

#' Biomarker Evaluation with Targeted Minimum Loss-Based Estimation (TMLE)
#'
#' Computes the causal target parameter defined as the difference between the
#' biomarker expression values under treatment and those same values under no
#' treatment, using Targeted Minimum Loss-Based Estimation.
#'
#' @param se (SummarizedExperiment) - containing expression or next-generation
#'        sequencing data in the "assays" slot and a matrix of phenotype-level
#'        data in the "colData" slot.
#' @param varInt (numeric) - indicating the column of the design matrix
#'                 corresponding to the treatment or outcome of interest (in the
#'                 "colData" slot of the "se" argument above.
#' @param type (character) - choice of the type of TMLE to perform: "exposure"
#'        to identify biomarkers related to an exposure (input as A), or
#'        "outcome" to identify biomarkers related to an outcome (input as Y).
#' @param parallel (logical, numeric) - whether to use or the number of cores to
#'        be used when the TMLE-based estimation procedure is parallelized.
#' @param family (character) - specification of error family: "binomial" or
#'        "gaussian".
#' @param g_lib (char vector) - library of learning algorithms to be used in
#'        fitting the "g" step of the standard TMLE procedure.
#' @param Q_lib (char vector) - library of learning algorithms to be used in
#'        fitting the "Q" step of the standard TMLE procedure.
#'
#' @importFrom parallel detectCores
#' @importFrom doParallel registerDoParallel
#' @importFrom foreach foreach "%dopar%"
#'
#' @return S3 object of class \code{biotmle}, with the \code{tmleOut} and the
#'         \code{call} slots containing TMLE-based estimates of the relationship
#'         between a biomarker and exposure/outcome variable and the original
#'         call to this function (for user reference), respectively.
#'
#' @export biomarkertmle
#'
#' @examples
#' library(dplyr)
#' library(biotmleData)
#' data(illuminaData)
#' "%ni%" = Negate("%in%")
#'
#' colData(illuminaData) <- colData(illuminaData) %>%
#'      data.frame %>%
#'      mutate(age = quantile(age, 0.25)) %>%
#'      DataFrame
#'
#' varInt_index <- which(names(colData(illuminaData)) %in% "benzene)
#'
#' biomarkerTMLEout <- biomarkertmle(se = illuminaData,
#'                                   varInt = varInt_index,
#'                                   type = "exposure",
#'                                   parallel = 1,
#'                                   family = "gaussian",
#'                                   g_lib = c("SL.mean"),
#'                                   Q_lib = c("SL.mean")
#'                                  )
#'
biomarkertmle <- function(se,
                          varInt,
                          type,
                          parallel = TRUE,
                          family = "gaussian",
                          g_lib = c("SL.glmnet", "SL.randomForest", "SL.nnet",
                                    "SL.polymars", "SL.mean"),
                          Q_lib = c("SL.glmnet", "SL.randomForest", "SL.nnet",
                                    "SL.mean")
                          ) {

  # ============================================================================
  # catch input and return in output object for user convenience
  # ============================================================================
  call <- match.call(expand.dots = TRUE)

  # ============================================================================
  # invoke S3 class constructor for "biotmle" object
  # ============================================================================
  biotmle <- biotmle(call = call,
                     topTable = NULL,
                     limmaOut = NULL,
                     tmleOut = NULL)

  #=============================================================================
  # set up parallelization based on input
  # ============================================================================
  if (class(parallel) == "numeric") doParallel::registerDoParallel(parallel)
  if (class(parallel) == "logical") {
    nCores <- parallel::detectCores()
    if (nCores > 1) {
      doParallel::registerDoParallel(nCores)
    } else {
      warning("option 'parallel' is set to TRUE but only 1 core detected.")
    }
    if (parallel == FALSE) {
      warning("parallelization has been set to FALSE: the estimation procedure
               will likely take on the order of days to run to completion.")
    }
  }
  #=============================================================================
  # TMLE procedure to identify biomarkers based on an EXPOSURE
  # ============================================================================
  if (type == "exposure") {
    # simple sanity check of whether Y includes array values
    if(unique(lapply(Y, class)) != "numeric") {
      print("Warning - values in Y do not appear to be expression measures...")
    }

    # median normalization
    Y <- as.data.frame(limma::normalizeBetweenArrays(assay(se),
                                                     method = "scale"))

    # exposure / treatment
    A <- as.numeric(colData(se)[, varInt])

    # baseline covariates
    W <- as.data.frame(colData(se)[, -varInt])

    # perform multi-level TMLE-based estimation for genes as Y
    biomarkerTMLEout <- foreach::foreach(gene = 1:ncol(Y),
                                         .combine = cbind) %dopar% {
      print(paste("Estimating target parameter for", gene, "of", ncol(Y)))
      out <- biomarkerTMLE_exposure(Y = Y[, gene],
                                    W = W,
                                    A = A,
                                    a = 1:length(unique(A)),
                                    g_lib = g_lib,
                                    Q_lib = Q_lib,
                                    family = family
                                   )
    }
    biotmle$tmleOut <- as.data.frame(t(biomarkerTMLEout))
    return(biotmle)

  } else if (type == "outcome") {
  #=============================================================================
  # TMLE procedure to identify biomarkers based on an OUTCOME
  #=============================================================================

    # median normalization
    A <- as.data.frame(limma::normalizeBetweenArrays(assay(se),
                                                     method = "scale"))

    # exposure / treatment
    Y <- as.numeric(colData(se)[, varInt])

    # baseline covariates
    W <- as.data.frame(colData(se)[, -varInt])

    # perform multi-level TMLE-bases estimation for genes as A
    biomarkerTMLEout <- foreach::foreach(gene = 1:ncol(A),
                                         .combine = rbind) %dopar% {
      print(paste("Estimating causal effect for", gene, "of", ncol(A)))
      out <- biomarkerTMLE_outcome(Y = Y,
                                   W = W,
                                   A = A[, gene],
                                   a = 1:length(unique(A)),
                                   g_lib = g_lib,
                                   Q_lib = Q_lib,
                                   family = family
                                  )
    }
    biotmle$tmleOut <- as.data.frame(biomarkerTMLEout)
    return(biotmle)

  } else {
    warning("improper input for 'type': choices are 'exposure' and 'outcome'.")
  }
}
