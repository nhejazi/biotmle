#' Plot p-values from moderated statistical tests for class biotmle
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
#' @method plot bioTMLE
#'
#' @examples
#' library(dplyr)
#' library(biotmleData)
#' library(SummarizedExperiment)
#' data(biomarkertmleOut)
#'
#' limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)
#'
#' plot(x = limmaTMLEout, type = "pvals_adj")
#'
plot.bioTMLE <- function(x, ..., type = "pvals_adj") {

  pal1 <- wesanderson::wes_palette("GrandBudapest", 100, type = "continuous")
  pal2 <- wesanderson::wes_palette("Darjeeling", type = "continuous")

  if(type == "pvals_raw") {
    p <- ggplot2::ggplot(as.data.frame(x@topTable), ggplot2::aes(P.Value))
    p <- p + ggplot2::geom_histogram(ggplot2::aes(y = ..count..,
      fill = ..count..), colour = "white", na.rm = TRUE, binwidth = 0.025)
    p <- p + ggplot2::ggtitle("Histogram of raw p-values")
    p <- p + ggplot2::xlab("magnitude of raw p-values")
    p <- p + ggplot2::scale_fill_gradientn("Count", colors = pal1)
    p <- p + ggplot2::guides(fill = ggplot2::guide_legend(title = NULL))
  }

  if (type == "pvals_adj") {
    p <- ggplot2::ggplot(as.data.frame(x@topTable),
                         ggplot2::aes(adj.P.Val))
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
#' @param fc_bound (numeric) - indicates the highest magnitude of the fold
#'        to be colored along the x-axis of the volcano plot; this limits the
#'        observations to be considered differentially expressed to those in a
#'        user-specified interval.
#' @param pval_bound (numeric) - indicates the largest corrected p-value to be
#'        colored along the y-axis of the volcano plot; this limits observations
#'        considered as differentially expressed to those in a user-specified
#'        interval.
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
#'         log p-value computed from the moderated tests in \code{modtest_ic}.
#'
#' @export volcano_ic
#'
#' @examples
#' library(dplyr)
#' library(biotmleData)
#' library(SummarizedExperiment)
#' data(biomarkertmleOut)
#'
#' limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)
#'
#' volcano_ic(biotmle = limmaTMLEout)
#'
volcano_ic <- function(biotmle, fc_bound = 3.0, pval_bound = 0.2) {

  stopifnot(class(biotmle) == "bioTMLE")

  pal1 <- wesanderson::wes_palette("GrandBudapest", 100, type = "continuous")
  pal2 <- wesanderson::wes_palette("Darjeeling", type = "continuous")

  tt_volcano <- as.data.frame(biotmle@topTable) %>%
    dplyr::arrange(adj.P.Val) %>%
    dplyr::mutate(
      logFC = I(logFC),
      logPval = -log10(P.Value),
      color = ifelse((logFC > fc_bound) & (adj.P.Val < pval_bound), "1",
                      ifelse((logFC < -fc_bound) & (adj.P.Val < pval_bound),
                             "-1", "0"))
    ) %>%
    dplyr::select(which(colnames(.) %in% c("logFC", "logPval", "color"))) %>%
    dplyr::filter((logFC > stats::quantile(logFC, probs = 0.05)) &
                   logFC < stats::quantile(logFC, probs = 0.95))

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
#' @param design a vector providing the contrast to be displayed in the heatmap.
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
#' @export heatmap_ic
#'
#' @examples
#' library(dplyr)
#' library(biotmleData)
#' library(SummarizedExperiment)
#' data(illuminaData)
#' data(biomarkertmleOut)
#'
#' colData(illuminaData) <- colData(illuminaData) %>%
#'      data.frame %>%
#'      dplyr::mutate(age = as.numeric(age > median(age))) %>%
#'      DataFrame
#'
#' varInt_index <- which(names(colData(illuminaData)) %in% "benzene")
#' designVar <- as.data.frame(colData(illuminaData))[, varInt_index]
#' design <- as.numeric(designVar == max(designVar))
#'
#' limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)
#'
#' heatmap_ic(x = limmaTMLEout, design = design, FDRcutoff = 0.05, top = 15)
#'

heatmap_ic <- function(x, ..., design, FDRcutoff = 0.05, top = 25) {

  stopifnot(class(x) == "bioTMLE")

  topbiomarkersFDR <- x@topTable %>%
    subset(adj.P.Val < FDRcutoff) %>%
    dplyr::arrange(adj.P.Val) %>%
    dplyr::slice(1:top)

  if (nrow(topbiomarkersFDR) < top) {
    stop(paste(top, "biomarkers not found below the specified FDR cutoff."))
  }

  if (class(x@tmleOut) == "EList") {
    biomarkerTMLEout_top <- x@tmleOut$E %>%
      data.frame %>%
      dplyr::filter(rownames(x@tmleOut) %in% topbiomarkersFDR$IDs)
  } else {
    biomarkerTMLEout_top <- x@tmleOut %>%
      dplyr::filter(rownames(x@tmleOut) %in% topbiomarkersFDR$IDs)
  }

  annot <- ifelse(design == 0, "Control", "Treated")

  pal <- wes_palette("Zissou", 100, type = "continuous")

  superheat::superheat(as.matrix(biomarkerTMLEout_top), row.dendrogram = TRUE,
                       grid.hline.col = "white", force.grid.hline = TRUE,
                       grid.vline.col = "white", force.grid.vline = TRUE,
                       membership.cols = annot, heat.pal = pal,
                       title = paste("Heatmap of Top", top, "Biomarkers"),
                       ...
                      )
}
