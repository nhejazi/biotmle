#' Plot p-values from moderated statistical tests for class biotmle
#'
#' Histogram of raw or FDR-adjusted p-values from the moderated t-test.
#'
#' @param x object of class \code{biotmle} as produced by an appropriate call
#'  to \code{biomarkertmle}
#' @param type character describing whether to provide a plot of unadjusted or
#'  adjusted p-values (adjustment performed via Benjamini-Hochberg)
#' @param ... additional arguments passed \code{plot} as necessary
#'
#' @importFrom ggplot2 ggplot aes geom_histogram guides guide_legend xlab ylab
#'  ggtitle theme_bw
#'
#' @return object of class \code{ggplot} containing a histogram of the raw or
#'  Benjamini-Hochberg corrected p-values (depending on user input).
#'
#' @export
#'
#' @method plot bioTMLE
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(biotmleData)
#' library(SuperLearner)
#' library(SummarizedExperiment)
#' data(illuminaData)
#'
#' colData(illuminaData) <- colData(illuminaData) %>%
#'   data.frame() %>%
#'   mutate(age = as.numeric(age > median(age))) %>%
#'   DataFrame()
#' benz_idx <- which(names(colData(illuminaData)) %in% "benzene")
#'
#' biomarkerTMLEout <- biomarkertmle(
#'   se = illuminaData,
#'   varInt = benz_idx,
#'   bppar_type = BiocParallel::SerialParam(),
#'   g_lib = c("SL.mean", "SL.glm"),
#'   Q_lib = c("SL.mean", "SL.glm")
#' )
#'
#' limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)
#'
#' plot(x = limmaTMLEout, type = "pvals_adj")
#' }
plot.bioTMLE <- function(x, ..., type = "pvals_adj") {
  if (type == "pvals_raw") {
    p <- ggplot2::ggplot(x@topTable, ggplot2::aes(P.Value)) +
      ggplot2::geom_histogram(ggplot2::aes(
        y = ..count..,
      ), colour = "white", na.rm = TRUE, binwidth = 0.025) +
      ggplot2::ggtitle("Histogram of raw p-values") +
      ggplot2::xlab("magnitude of raw p-values")
  } else if (type == "pvals_adj") {
    p <- ggplot2::ggplot(
      as.data.frame(x@topTable),
      ggplot2::aes(adj.P.Val)
    ) +
      ggplot2::geom_histogram(ggplot2::aes(
        y = ..count..,
      ), colour = "white", na.rm = TRUE, binwidth = 0.025) +
      ggplot2::ggtitle("Histogram of BH-corrected FDR p-values") +
      ggplot2::xlab("magnitude of BH-corrected p-values")
  }
  p <- p +
    ggplot2::guides(fill = ggplot2::guide_legend(title = NULL)) +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = NULL)
  return(p)
}

################################################################################

#' Volcano plot for class biotmle
#'
#' Volcano plot of the log-changes in the target causal paramter against the
#' log raw p-values from the moderated t-test.
#'
#' @param biotmle object of class \code{biotmle} as produced by an appropriate
#'  call to \code{biomarkertmle}
#' @param ate_bound A \code{numeric} indicating the highest magnitude of the
#'  average treatment effect to be colored on the x-axis of the volcano plot;
#'  this limits the observations to be considered differentially expressed to
#'  those in a user-specified interval.
#' @param pval_bound A \code{numeric} indicating the largest corrected p-value
#'  to be colored on the y-axis of the volcano plot; this limits observations
#'  considered as differentially expressed to those in a user-specified
#'  interval.
#'
#' @importFrom dplyr "%>%" arrange mutate select filter
#' @importFrom ggplot2 ggplot aes geom_point guides guide_legend xlab ylab
#'  ggtitle theme_bw
#' @importFrom ggsci scale_fill_gsea
#' @importFrom stats quantile
#' @importFrom assertthat assert_that
#' @importFrom methods is
#'
#' @return object of class \code{ggplot} containing a standard volcano plot of
#'  the log-fold change in the causal target parameter against the raw log
#'  p-value computed from the moderated tests in \code{modtest_ic}.
#'
#' @export volcano_ic
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(biotmleData)
#' library(SuperLearner)
#' library(SummarizedExperiment)
#' data(illuminaData)
#'
#' colData(illuminaData) <- colData(illuminaData) %>%
#'   data.frame() %>%
#'   mutate(age = as.numeric(age > median(age))) %>%
#'   DataFrame()
#' benz_idx <- which(names(colData(illuminaData)) %in% "benzene")
#'
#' biomarkerTMLEout <- biomarkertmle(
#'   se = illuminaData,
#'   varInt = benz_idx,
#'   bppar_type = BiocParallel::SerialParam(),
#'   g_lib = c("SL.mean", "SL.glm"),
#'   Q_lib = c("SL.mean", "SL.glm")
#' )
#'
#' limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)
#'
#' volcano_ic(biotmle = limmaTMLEout)
#' }
volcano_ic <- function(biotmle, ate_bound = 1.0, pval_bound = 0.2) {
  # check class since not a generic method
  assertthat::assert_that(is(biotmle, "bioTMLE"))

  tt_volcano <- biotmle@topTable %>%
    dplyr::arrange(adj.P.Val) %>%
    dplyr::mutate(
      AveExpr = I(AveExpr),
      logPval = -log10(P.Value),
      color = ifelse((AveExpr > ate_bound) & (adj.P.Val < pval_bound), "1",
        ifelse((AveExpr < -ate_bound) & (adj.P.Val < pval_bound),
          "-1", "0"
        )
      )
    ) %>%
    dplyr::select(which(colnames(.) %in% c("AveExpr", "logPval", "color"))) %>%
    dplyr::filter((AveExpr > stats::quantile(AveExpr, probs = 0.05)) &
      AveExpr < stats::quantile(AveExpr, probs = 0.95))

  p <- ggplot2::ggplot(tt_volcano, ggplot2::aes(x = AveExpr, y = logPval)) +
    ggplot2::geom_point(aes(colour = color)) +
    ggplot2::xlab("Average Treatment Effect") +
    ggplot2::ylab("-log10(raw p-value)") +
    ggplot2::ggtitle("Volcano Plot: Average Treatment Effect") +
    ggsci::scale_fill_gsea() +
    ggplot2::guides(color = ggplot2::guide_legend(title = NULL)) +
    ggplot2::theme_bw()
  return(p)
}

################################################################################

utils::globalVariables(c(
  "adj.P.Val", ".", "..count..", "P.Value", "color",
  "AveExpr", "logPval"
))

#' Heatmap for class biotmle
#'
#' Heatmap of contributions of a select subset of biomarkers to the variable
#' importance measure changes as assessed by influence curve-based estimation,
#' across all subjects. The heatmap produced performs supervised clustering, as
#' per Pollard & van der Laan (2008) <doi:10.2202/1544-6115.1404>.
#'
#' @param x Object of class \code{biotmle} as produced by an appropriate call
#'  to \code{biomarkertmle}.
#' @param design A vector giving the contrast to be displayed in the heatmap.
#' @param FDRcutoff Cutoff to be used in controlling the False Discovery Rate.
#' @param type A \code{character} describing whether to plot only a top number
#'  (as defined by FDR-corrected p-value) of biomarkers or all biomarkers.
#' @param top Number of identified biomarkers to plot in the heatmap.
#' @param ... additional arguments passed to \code{superheat::superheat} as
#'  necessary
#'
#' @importFrom dplyr "%>%" arrange filter slice
#' @importFrom superheat superheat
#' @importFrom assertthat assert_that
#' @importFrom methods is
#'
#' @return heatmap (from \pkg{superheat}) using hierarchical clustering to plot
#'  the changes in the variable importance measure for all subjects across a
#'  specified top number of biomarkers.
#'
#' @export heatmap_ic
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(biotmleData)
#' library(SummarizedExperiment)
#' data(illuminaData)
#'
#' colData(illuminaData) <- colData(illuminaData) %>%
#'   data.frame() %>%
#'   mutate(age = as.numeric(age > median(age))) %>%
#'   DataFrame()
#' benz_idx <- which(names(colData(illuminaData)) %in% "benzene")
#'
#' biomarkerTMLEout <- biomarkertmle(
#'   se = illuminaData,
#'   varInt = benz_idx,
#'   bppar_type = BiocParallel::SerialParam(),
#'   g_lib = c("SL.mean", "SL.glm"),
#'   Q_lib = c("SL.mean", "SL.glm")
#' )
#'
#' limmaTMLEout <- modtest_ic(biotmle = biomarkerTMLEout)
#'
#' heatmap_ic(x = limmaTMLEout, design = design, FDRcutoff = 0.05, top = 10)
#' }
heatmap_ic <- function(x, ..., design, FDRcutoff = 0.25,
                       type = c("top", "all"), top = 25) {
  # check class since not a generic method
  assertthat::assert_that(is(x, "bioTMLE"))
  type <- match.arg(type)

  if (type == "top") {
    topbiomarkersFDR <- x@topTable %>%
      subset(adj.P.Val < FDRcutoff) %>%
      dplyr::arrange(adj.P.Val) %>%
      dplyr::slice(seq_len(top))

    if (nrow(topbiomarkersFDR) < top) {
      message(paste(top, "biomarkers not found below specified FDR cutoff."))
    }

    if (any(class(x@tmleOut) %in% "EList")) {
      biomarkerTMLEout_top <- x@tmleOut$E %>%
        data.frame() %>%
        dplyr::filter(rownames(x@tmleOut) %in% topbiomarkersFDR$ID)
    } else {
      biomarkerTMLEout_top <- x@tmleOut %>%
        dplyr::filter(rownames(x@tmleOut) %in% topbiomarkersFDR$ID)
    }
    plot_title <- paste("Supervised Heatmap of Top", top, "Biomarkers")
  } else {
    if (any(class(x@tmleOut) %in% "EList")) {
      biomarkerTMLEout_top <- x@tmleOut$E %>%
        as.data.frame()
    } else {
      biomarkerTMLEout_top <- x@tmleOut
    }
    plot_title <- "Heatmap of Biomarkers with Supervised Clustering"
  }

  # group labels
  annot <- ifelse(design == 0, "Control", "Treated")

  # build supervised heatmap
  superheat::superheat(as.matrix(biomarkerTMLEout_top),
    grid.hline.col = "white", force.grid.hline = TRUE,
    grid.vline.col = "white", force.grid.vline = TRUE,
    membership.cols = annot,
    title = plot_title,
    ...
  )
}
