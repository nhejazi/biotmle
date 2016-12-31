#' Plot utility for class \code{biotmle}
#'
#' @param biotmle object of class \code{biotmle} as produced by an appropriate
#'        call to \code{biomarkertmle}
#'
#' @importFrom ggplot2 ggplot aes geom_histogram geom_point scale_fill_gradientn
#'             scale_colour_manual guides guide_legend xlab ylab ggtitle
#' @importFrom wesanderson wes_palette
#'
#' @export plot_biotmle
#'

plot_biotmle <- function(biotmle,
                         type) {
  pal1 <- wesanderson::wes_palette("Rushmore", 100, type = "continuous")
  pal2 <- wesanderson::wes_palette("Darjeeling", type = "continuous")

  if(type == "pvals_raw") {
    ggplot(biotmle$topTable, aes(P.Value)) +
      geom_histogram(aes(y = ..count.., fill = ..count..), colour = "white",
                     na.rm = TRUE, binwidth = 0.05) +
      ggtitle(paste("Histogram of raw p-values \n (applying Limma shrinkage to",
                    "TMLE results)")) +
      xlab("magnitude of raw p-values") +
      scale_fill_gradientn("Count", colors = pal1) +
      guides(fill = guide_legend(title = NULL))
  }

  if (type == "pvals_adj") {
    ggplot(biotmle$topTable, aes(adj.P.Val)) +
      geom_histogram(aes(y = ..count.., fill = ..count..), colour = "white",
                     na.rm = TRUE, binwidth = 0.05) +
      ggtitle(paste("Histogram of FDR-corrected p-values (BH) \n (applying Limma",
                    "shrinkage to TMLE results)")) +
      xlab("magnitude of BH-corrected p-values") +
      scale_fill_gradientn("Count", colors = pal1) +
      guides(fill = guide_legend(title = NULL))
  }
}

#' Volcano plot for class \code{biotmle}
#'
#' @param biotmle object of class \code{biotmle} as produced by an appropriate
#'        call to \code{biomarkertmle}
#'
#' @importFrom magrittr "%>%"
#' @importFrom dplyr arrange mutate select filter
#' @importFrom ggplot2 ggplot aes geom_histogram geom_point scale_fill_gradientn
#'             scale_colour_manual guides guide_legend xlab ylab ggtitle
#' @importFrom wesanderson wes_palette
#'
#' @export volcplot_biotmle
#'

volcplot_biotmle <- function(biotmle) {

  pal1 <- wesanderson::wes_palette("Rushmore", 100, type = "continuous")
  pal2 <- wesanderson::wes_palette("Darjeeling", type = "continuous")

  # add volcano plot examining genes showing differential expression
  tt_volcano <- biotmle$topTable %>%
    dplyr::arrange(adj.P.Val) %>%
    dplyr::mutate(
      logFC = I(logFC),
      logPval = -log10(P.Value),
      color = ifelse((logFC > 3.0) & (adj.P.Val < 0.2), "1",
                      ifelse((logFC < -3.0) & (adj.P.Val < 0.2), "-1", "0"))
    ) %>%
    dplyr::select(which(colnames(.) %in% c("logFC", "logPval", "color"))) %>%
    dplyr::filter((logFC > quantile(logFC, probs = 0.2)) &
                   logFC < quantile(logFC, probs = 0.75))

  ggplot(tt_volcano, aes(x = logFC, y = logPval)) +
      geom_point(aes(colour = color)) +
      xlab("log2(Fold Change)") + ylab("-log10(raw p-value)") +
      ggtitle("Volcano Plot of Differential Average Tx Effect") +
      scale_colour_manual(values = pal2[1:3], guide = FALSE)
}

#' Heatmap for class \code{biotmle}
#'
#' @param biotmle object of class \code{biotmle} as produced by an appropriate
#'        call to \code{biomarkertmle}
#' @param designMat a design matrix providing the contrasts to be dispalyed in
#'        the heatmap (just as would be passed to \code{limma::lmFit})
#' @param FDRcutoff cutoff to be used in controlling the False Discovery Rate
#' @param top number of identified biomarkers to plot in the heatmap
#'
#' @importFrom magrittr "%>%"
#' @importFrom dplyr arrange filter slice
#' @importFrom NMF nmf.options aheatmap
#'
#' @export heatmap_biotmle
#'

heatmap_biotmle <- function(biotmle, designMat, FDRcutoff = 0.05, top = 25) {

  # make heatmap of genes showing differential expression
  topbiomarkersFDR <- biotmle$topTable %>%
    subset(adj.P.Val < FDRcutoff) %>%
    dplyr::arrange(adj.P.Val) %>%
    dplyr::slice(1:top)

  biomarkerTMLEout_top <- biotmle$tmleOut %>%
    dplyr::filter(rownames(biotmle$tmleOut) %in% topbiomarkersFDR$IDs)

  annot <- data.frame(Treatment = ifelse(designMat$Tx == 0,
                                         "Control", "Exposed"))
  rownames(annot) <- colnames(biomarkerTMLEout_top)
  NMF::nmf.options(grid.patch = TRUE)

  NMF::aheatmap(as.matrix(biomarkerTMLEout_top),
                scale = "row",
                Rowv = TRUE,
                Colv = NULL,
                annCol = annot,
                annColors = "Set2",
                main = paste("Heatmap of Top", top, "Biomarkers", FDRcutoff,
                             "(FDR)")
               )
}
