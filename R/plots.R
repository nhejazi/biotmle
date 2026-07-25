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
#' @importFrom ggplot2 ggplot aes geom_histogram guides guide_legend xlab
#' @importFrom ggplot2 ylab ggtitle theme_bw
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
#' @importFrom ggplot2 ggplot aes geom_point guides guide_legend xlab
#' @importFrom ggplot2 ylab ggtitle theme_bw
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
  "AveExpr", "logPval", "subject", "biomarker", "group", "eif_contrib",
  "ID", "B", "var_bayes"
))

#' Cluster the rows of a matrix hierarchically
#'
#' @param mat A \code{matrix} whose rows are to be clustered.
#'
#' @importFrom stats dist hclust
#'
#' @return An object of class \code{hclust}, or \code{NULL} when there are too
#'  few rows to cluster or when the distance matrix is degenerate.
#'
#' @noRd
cluster_fit <- function(mat) {
  if (nrow(mat) < 3) {
    return(NULL)
  }
  row_dist <- stats::dist(mat)
  if (anyNA(row_dist)) {
    return(NULL)
  }
  stats::hclust(row_dist, method = "average")
}

#' Order the rows of a matrix by hierarchical clustering
#'
#' @param mat A \code{matrix} whose rows are to be ordered.
#'
#' @return An \code{integer} vector giving the clustered row ordering of
#'  \code{mat}, falling back on the original ordering when \code{mat} cannot be
#'  clustered.
#'
#' @noRd
cluster_order <- function(mat) {
  row_clust <- cluster_fit(mat)
  if (is.null(row_clust)) {
    return(seq_len(nrow(mat)))
  }
  row_clust$order
}

#' Build a row dendrogram panel aligned to a heatmap's discrete y-axis
#'
#' @param row_clust An object of class \code{hclust} for the heatmap rows.
#' @param n_rows A \code{numeric} giving the number of heatmap rows, used to
#'  match the panel's extent to the heatmap's discrete y-axis.
#'
#' @importFrom ggplot2 ggplot aes geom_segment scale_x_reverse
#' @importFrom ggplot2 scale_y_continuous theme_void .data
#' @importFrom ggdendro dendro_data segment
#' @importFrom stats as.dendrogram
#'
#' @return An object of class \code{ggplot} containing the dendrogram, drawn
#'  sideways so that its leaves align with the rows of the heatmap.
#'
#' @noRd
dendrogram_panel <- function(row_clust, n_rows) {
  dendro_segs <- ggdendro::segment(
    ggdendro::dendro_data(stats::as.dendrogram(row_clust), type = "rectangle")
  )
  # the dendrogram is drawn transposed (x and y swapped) so that its leaves run
  # vertically, and reversed so that it grows leftward away from the heatmap
  ggplot2::ggplot(dendro_segs) +
    ggplot2::geom_segment(ggplot2::aes(
      x = .data$y, y = .data$x, xend = .data$yend, yend = .data$xend
    )) +
    ggplot2::scale_x_reverse(expand = c(0, 0)) +
    ggplot2::scale_y_continuous(
      limits = c(0.5, n_rows + 0.5), expand = c(0, 0)
    ) +
    ggplot2::theme_void()
}

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
#' @param scale A \code{logical} indicating whether each biomarker's
#'  contributions should be standardized (centered and scaled to unit variance)
#'  across subjects before plotting. Standardizing makes biomarkers measured on
#'  different scales visually comparable; biomarkers with no variation across
#'  subjects are centered but not rescaled, so that they remain plottable.
#' @param row_dendrogram A \code{logical} indicating whether the hierarchical
#'  clustering of the biomarkers should additionally be drawn as a dendrogram
#'  alongside the heatmap. Biomarkers are ordered by this clustering whether or
#'  not the dendrogram itself is drawn. When there are too few biomarkers to
#'  cluster, the dendrogram is silently omitted.
#' @param ... additional arguments passed to \code{ggplot2::geom_tile} as
#'  necessary
#'
#' @importFrom dplyr "%>%" arrange filter slice
#' @importFrom ggplot2 ggplot aes geom_tile facet_grid vars ggtitle xlab
#' @importFrom ggplot2 ylab scale_fill_gradient2 theme_bw theme element_blank
#' @importFrom ggplot2 scale_y_discrete
#' @importFrom patchwork wrap_plots plot_annotation
#' @importFrom assertthat assert_that
#' @importFrom methods is
#'
#' @return object of class \code{ggplot} containing a heatmap that uses
#'  hierarchical clustering to plot the changes in the variable importance
#'  measure for all subjects across a specified top number of biomarkers. When
#'  \code{row_dendrogram} is \code{TRUE}, the returned object is a
#'  \pkg{patchwork} composition of the dendrogram and the heatmap, which still
#'  inherits from \code{ggplot}.
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
                       type = c("top", "all"), top = 25, scale = TRUE,
                       row_dendrogram = FALSE) {
  # check class since not a generic method
  assertthat::assert_that(is(x, "bioTMLE"))
  type <- match.arg(type)

  # the EIF contributions: biomarkers along rows, subjects along columns
  eif_mat <- if (any(class(x@tmleOut) %in% "EList")) {
    as.matrix(x@tmleOut$E)
  } else {
    as.matrix(x@tmleOut)
  }
  rownames(eif_mat) <- rownames(x)

  if (type == "top") {
    topbiomarkersFDR <- x@topTable %>%
      dplyr::filter(adj.P.Val < FDRcutoff) %>%
      dplyr::arrange(adj.P.Val) %>%
      dplyr::slice(seq_len(top))

    if (nrow(topbiomarkersFDR) < top) {
      message(paste(top, "biomarkers not found below specified FDR cutoff."))
    }

    eif_mat <- eif_mat[rownames(eif_mat) %in% topbiomarkersFDR$ID, ,
      drop = FALSE
    ]
    plot_title <- paste("Supervised Heatmap of Top", top, "Biomarkers")
  } else {
    plot_title <- "Heatmap of Biomarkers with Supervised Clustering"
  }

  assertthat::assert_that(nrow(eif_mat) > 0)
  assertthat::assert_that(length(design) == ncol(eif_mat))

  if (is.null(colnames(eif_mat))) {
    colnames(eif_mat) <- paste0("obs", seq_len(ncol(eif_mat)))
  }

  # standardize each biomarker across subjects for visual comparability,
  # leaving biomarkers with no variation untouched to avoid dividing by zero
  if (scale) {
    eif_mat <- t(apply(eif_mat, 1, function(bmark) {
      bmark_sd <- stats::sd(bmark)
      if (is.na(bmark_sd) || bmark_sd == 0) {
        return(bmark - mean(bmark))
      }
      (bmark - mean(bmark)) / bmark_sd
    }))
  }

  # group labels
  annot <- ifelse(design == 0, "Control", "Treated")

  # supervised clustering: cluster biomarkers across all subjects, then order
  # subjects by clustering within each exposure group
  row_clust <- cluster_fit(eif_mat)
  row_order <- if (is.null(row_clust)) {
    seq_len(nrow(eif_mat))
  } else {
    row_clust$order
  }
  row_levels <- rownames(eif_mat)[row_order]
  col_levels <- unlist(lapply(c("Control", "Treated"), function(grp) {
    grp_mat <- eif_mat[, annot == grp, drop = FALSE]
    colnames(grp_mat)[cluster_order(t(grp_mat))]
  }))

  # as.vector() unrolls the matrix column-wise, so biomarkers vary fastest
  eif_long <- data.frame(
    biomarker = factor(rownames(eif_mat), levels = row_levels),
    subject = factor(rep(colnames(eif_mat), each = nrow(eif_mat)),
      levels = col_levels
    ),
    group = factor(rep(annot, each = nrow(eif_mat)),
      levels = c("Control", "Treated")
    ),
    eif_contrib = as.vector(eif_mat)
  )

  p <- ggplot2::ggplot(
    eif_long,
    ggplot2::aes(x = subject, y = biomarker, fill = eif_contrib)
  ) +
    ggplot2::geom_tile(colour = "white", ...) +
    ggplot2::facet_grid(
      cols = ggplot2::vars(group), scales = "free_x", space = "free_x"
    ) +
    ggplot2::scale_fill_gradient2(
      name = if (scale) "Scaled EIF\ncontribution" else "EIF\ncontribution",
      midpoint = 0
    ) +
    # tiles are flush with the panel edge so that a dendrogram drawn alongside
    # lines up with the rows exactly
    ggplot2::scale_y_discrete(expand = c(0, 0)) +
    ggplot2::ggtitle(plot_title) +
    ggplot2::xlab("Observation") +
    ggplot2::ylab("Biomarker") +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_blank(),
      axis.ticks.x = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank()
    )

  if (!row_dendrogram || is.null(row_clust)) {
    return(p)
  }

  # the title is promoted to the composition so that it spans both panels
  # rather than sitting over the narrow dendrogram alone
  p_dendro <- dendrogram_panel(row_clust, nrow(eif_mat))
  patchwork::wrap_plots(p_dendro, p + ggplot2::ggtitle(NULL),
    widths = c(1, 4)
  ) +
    patchwork::plot_annotation(title = plot_title)
}
