#' Plot utility for class biotmle
#'
#' Histogram of raw or FDR-adjusted p-values from the moderated t-test.
#'
#' @param x object of class \code{biotmle} as produced by an appropriate call to
#'        \code{biomarkertmle}
#' @param type character describing whether to provide a plot of unadjusted or
#'        adjusted p-values (adjustment performed via Benjamini-Hochberg)
#' @param ... additional arguments passed \code{plot} as necessary
#'
#' @importFrom ggplot2 ggplot aes geom_histogram geom_point scale_fill_gradientn
#'             scale_colour_manual guides guide_legend xlab ylab ggtitle
#' @importFrom wesanderson wes_palette
#'
#' @return object of class \code{ggplot} containing a histogram of the raw or
#'         Benjamini-Hochberg corrected p-values (depending on user input).
#'
#' @export
#'
#' @examples
#' library(dplyr)
#' data(illuminaData)
#' data(biomarkertmleOut)
#' "%ni%" = Negate("%in%")
#'
#' W <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %in% c("age", "sex", "smoking"))) %>%
#'  dplyr::mutate(
#'    age = as.numeric((age > quantile(age, 0.25))),
#'    sex = I(sex),
#'    smoking = I(smoking)
#'  )
#'
#' A <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %in% c("benzene")))
#' A <- A[, 1]
#'
#' Y <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %ni% c("age", "sex", "smoking", "benzene",
#'                                         "id")))
#' geneIDs <- colnames(Y)
#'
#' design <- as.data.frame(cbind(rep(1, nrow(Y)),
#'                              as.numeric(A == max(unique(A)))))
#' colnames(design) <- c("intercept", "Tx")
#' limmaTMLEout <- limmatmle(biotmle = biomarkerTMLEout, IDs = NULL,
#'                           designMat = design)
#' plot(x = limmaTMLEout, type = "pvals_adj")
#'
plot.biotmle <- function(x, ..., type = "pvals_adj") {

  stopifnot(class(x) == "biotmle")

  pal1 <- wesanderson::wes_palette("Rushmore", 100, type = "continuous")
  pal2 <- wesanderson::wes_palette("Darjeeling", type = "continuous")

  if(type == "pvals_raw") {
    p <- ggplot2::ggplot(x$topTable, ggplot2::aes(P.Value))
    p <- p + ggplot2::geom_histogram(ggplot2::aes(y = ..count..,
      fill = ..count..), colour = "white", na.rm = TRUE, binwidth = 0.025)
    p <- p + ggplot2::ggtitle("Histogram of raw p-values")
    p <- p + ggplot2::xlab("magnitude of raw p-values")
    p <- p + ggplot2::scale_fill_gradientn("Count", colors = pal1)
    p <- p + ggplot2::guides(fill = ggplot2::guide_legend(title = NULL))
  }

  if (type == "pvals_adj") {
    p <- ggplot2::ggplot(x$topTable, ggplot2::aes(adj.P.Val))
    p <- p + ggplot2::geom_histogram(ggplot2::aes(y = ..count..,
      fill = ..count..), colour = "white", na.rm = TRUE, binwidth = 0.025)
    p <- p + ggplot2::ggtitle("Histogram of BH-corrected FDR p-values")
    p <- p + ggplot2::xlab("magnitude of BH-corrected p-values")
    p <- p + ggplot2::scale_fill_gradientn("Count", colors = pal1)
    p <- p + ggplot2::guides(fill = ggplot2::guide_legend(title = NULL))
  }
  return(p)
}

#==============================================================================#
## NEXT FUNCTION ===============================================================
#==============================================================================#

#' Volcano plot for class biotmle
#'
#' Volcano plot of the log-changes in the target causal paramter against the
#' log raw p-values from the moderated t-test.
#'
#' @param biotmle object of class \code{biotmle} as produced by an appropriate
#'        call to \code{biomarkertmle}
#'
#' @importFrom magrittr "%>%"
#' @importFrom dplyr arrange mutate select filter
#' @importFrom ggplot2 ggplot aes geom_histogram geom_point scale_fill_gradientn
#'             scale_colour_manual guides guide_legend xlab ylab ggtitle
#' @importFrom wesanderson wes_palette
#' @importFrom stats quantile
#'
#' @return object of class \code{ggplot} containing a standard volcano plot of
#'         the log-fold change in the causal target parameter against the raw
#'         log p-value computed from the moderated t-test in \code{limmatmle}.
#'
#' @export volcano_biotmle
#'
#' @examples
#' library(dplyr)
#' data(illuminaData)
#' data(biomarkertmleOut)
#' "%ni%" = Negate("%in%")
#'
#' W <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %in% c("age", "sex", "smoking"))) %>%
#'  dplyr::mutate(
#'    age = as.numeric((age > quantile(age, 0.25))),
#'    sex = I(sex),
#'    smoking = I(smoking)
#'  )
#'
#' A <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %in% c("benzene")))
#' A <- A[, 1]
#'
#' Y <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %ni% c("age", "sex", "smoking", "benzene",
#'                                         "id")))
#' geneIDs <- colnames(Y)
#' design <- as.data.frame(cbind(rep(1, nrow(Y)),
#'                              as.numeric(A == max(unique(A)))))
#' colnames(design) <- c("intercept", "Tx")
#' limmaTMLEout <- limmatmle(biotmle = biomarkerTMLEout, IDs = NULL,
#'                           designMat = design)
#' volcano_biotmle(biotmle = limmaTMLEout)
#'
volcano_biotmle <- function(biotmle) {

  pal1 <- wesanderson::wes_palette("Rushmore", 100, type = "continuous")
  pal2 <- wesanderson::wes_palette("Darjeeling", type = "continuous")

  tt_volcano <- biotmle$topTable %>%
    dplyr::arrange(adj.P.Val) %>%
    dplyr::mutate(
      logFC = I(logFC),
      logPval = -log10(P.Value),
      color = ifelse((logFC > 3.0) & (adj.P.Val < 0.2), "1",
                      ifelse((logFC < -3.0) & (adj.P.Val < 0.2), "-1", "0"))
    ) %>%
    dplyr::select(which(colnames(.) %in% c("logFC", "logPval", "color"))) %>%
    dplyr::filter((logFC > stats::quantile(logFC, probs = 0.1)) &
                   logFC < stats::quantile(logFC, probs = 0.9))

  p <- ggplot2::ggplot(tt_volcano, ggplot2::aes(x = logFC, y = logPval))
  p <- p + ggplot2::geom_point(aes(colour = color))
  p <- p + ggplot2::xlab("log2(Fold Change in Average Treatment Effect)")
  p <- p + ggplot2::ylab("-log10(raw p-value)")
  p <- p + ggplot2::ggtitle("Volcano Plot: Average Treatment Effect")
  p <- p + ggplot2::scale_colour_manual(values = pal2[1:3], guide = FALSE)

  return(p)
}

#==============================================================================#
## NEXT FUNCTION ===============================================================
#==============================================================================#
utils::globalVariables(c("adj.P.Val", ".", "..count..", "P.Value", "color",
                         "logFC", "logPval"))

#' Heatmap for class biotmle
#'
#' Heatmap of the contributions of a select subset of biomarkers to the variable
#' importance measure changes as assessed by influence curve-based estimation,
#' across all subjects.
#'
#' @param x object of class \code{biotmle} as produced by an appropriate call to
#'        \code{biomarkertmle}
#' @param designMat a design matrix providing the contrasts to be dispalyed in
#'        the heatmap (as would be passed to \code{limma::lmFit}).
#' @param tx numeric value indicating the column of the design matrix that
#'        corresponds to the expression covariate of interest.
#' @param FDRcutoff cutoff to be used in controlling the False Discovery Rate
#' @param top number of identified biomarkers to plot in the heatmap
#' @param ... additional arguments passed to \code{superheat::superheat} as
#'        necessary
#'
#' @importFrom magrittr "%>%"
#' @importFrom dplyr arrange filter slice
#' @importFrom wesanderson wes_palette
#' @importFrom superheat superheat
#'
#' @return heatmap (from the superheat package) using hierarchical clustering to
#'         plot the changes in the variable importance measure for all subjects
#'         across a specified top number of biomarkers.
#'
#' @export heatmap_biotmle
#'
#' @examples
#' library(dplyr)
#' data(illuminaData)
#' data(biomarkertmleOut)
#' "%ni%" = Negate("%in%")
#'
#' W <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %in% c("age", "sex", "smoking"))) %>%
#'  dplyr::mutate(
#'    age = as.numeric((age > quantile(age, 0.25))),
#'    sex = I(sex),
#'    smoking = I(smoking)
#'  )
#'
#' A <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %in% c("benzene")))
#' A <- A[, 1]
#'
#' Y <- illuminaData %>%
#'  dplyr::select(which(colnames(.) %ni% c("age", "sex", "smoking", "benzene",
#'                                         "id")))
#' geneIDs <- colnames(Y)
#' design <- as.data.frame(cbind(rep(1, nrow(Y)),
#'                              as.numeric(A == max(unique(A)))))
#' colnames(design) <- c("intercept", "Tx")
#' limmaTMLEout <- limmatmle(biotmle = biomarkerTMLEout, IDs = NULL,
#'                           designMat = design)
#' heatmap_biotmle(x = limmaTMLEout, designMat = design, FDRcutoff = 0.05,
#'                 top = 25)
#'

heatmap_biotmle <- function(x, ..., designMat, tx = 2,
                            FDRcutoff = 0.05, top = 25) {

  stopifnot(class(x) == "biotmle")

  topbiomarkersFDR <- x$topTable %>%
    subset(adj.P.Val < FDRcutoff) %>%
    dplyr::arrange(adj.P.Val) %>%
    dplyr::slice(1:top)

  biomarkerTMLEout_top <- x$tmleOut %>%
    dplyr::filter(rownames(x$tmleOut) %in% topbiomarkersFDR$IDs)

  annot <- ifelse(designMat[, tx] == 0, "Control", "Treated")

  pal <- wes_palette("Zissou", 100, type = "continuous")

  superheat::superheat(as.matrix(biomarkerTMLEout_top), row.dendrogram = TRUE,
                       grid.hline.col = "white", force.grid.hline = TRUE,
                       grid.vline.col = "white", force.grid.vline = TRUE,
                       membership.cols = annot, heat.pal = pal,
                       title = paste("Heatmap of Top", top, "Biomarkers")
                      )
}
