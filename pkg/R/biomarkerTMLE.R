utils::globalVariables("gene")

#' Biomarker Discovery via Targeted Minimum Loss-Based Estimation (TMLE)
#'
#' computes the (rather complicated) parameter defined as the difference in the
#' blips in Tx effects (difference between counterfactual max, min Tx effects)
#'
#' @param Y (numeric vector) - a vector of array expression values for a single
#'        gene
#' @param W (numeric matrix) - a matrix of covariates to be controlled in
#'        estimation
#' @param A (numeric vector) - a discretized exposure vector whose effect on
#'        expression gene expression values is of interest
#' @param type (character) - choice of the type of TMLE to perform: "exposure"
#'        to identify biomarkers related to an exposure (input as A), or
#'        "outcome" to identify biomarkers related to an outcome (input as Y).
#' @param parallel (logical, numeric) - whether to use or number of cores to be
#'        used when the TMLE-based estimation procedure is parallelized
#' @param family (character) - specification of error family: "binomial" or
#'        "gaussian"
#' @param g_lib (char vector) - library of learning algorithms to be used in ...
#' @param Q_lib (char vector) - library of learning algorithms to be used in ...
#'
#' @importFrom parallel detectCores
#' @importFrom doParallel registerDoParallel
#' @importFrom foreach foreach "%dopar%"
#'
#' @export biomarkertmle
#'

biomarkertmle <- function(Y,
                          W,
                          A,
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
    # median normalization
    Y <- as.data.frame(limma::normalizeBetweenArrays(Y, method = "scale"))

    # simple sanity check of whether Y includes array values
    if(unique(lapply(Y, class)) != "numeric") {
      print("Warning - values in Y do not appear to be expression measures...")
    }

    # perform multi-level TMLE estimation (for all columns/genes)
    foreach::foreach(gene = 1:ncol(Y), .combine = cbind) %dopar% {
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
    biomarkerTMLEout <- as.data.frame(t(out))
    biotmle$tmleOut <- biomarkerTMLEout
    return(biotmle)

  } else if (type == "outcome") {
  #=============================================================================
  # TMLE procedure to identify biomarkers based on an OUTCOME
  #=============================================================================
    warning("TMLE for biomarker discovery from outcomes is not yet implemented")

  } else {
    warning("improper input for 'type': choices are 'exposure' and 'outcome'")
  }
}
