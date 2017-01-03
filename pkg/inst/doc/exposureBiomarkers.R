## ----setup_data----------------------------------------------------------
library(dplyr)
library(biotmle)
data(illumina2007)
"%ni%" = Negate("%in%")

data <- illumina2007 %>%
  dplyr::select(which(colnames(.) %ni% c("box", "riboaveugml", "ng", "exclude",
                                         "hyb", "totalrnaug", "chip", "Chip.Id",
                                         "Chip.Section", "label.c", "benzene",
                                         "illumID", "berkeley_vial_label",
                                         "cRNA"))) %>%
  dplyr::filter(!duplicated(.$id)) %>%
  dplyr::mutate(
    benzene = I(newbenz),
    smoking = I(current_smoking)
  ) %>%
  dplyr::select(which(colnames(.) %ni% c("newbenz", "current_smoking")))

subjIDs <- data$id

## ----clean_data----------------------------------------------------------
# W - age, sex, smoking
W <- data %>%
  dplyr::select(which(colnames(.) %in% c("age", "sex", "smoking"))) %>%
  dplyr::mutate(
    age = as.numeric((age > quantile(age, 0.25))),
    sex = I(sex),
    smoking = I(smoking)
  )


# A - benzene exposure (discretized)
A <- data %>%
  dplyr::select(which(colnames(.) %in% c("benzene")))
A <- A[, 1]


# Y - genes
Y <- data %>%
  dplyr::select(which(colnames(.) %ni% c("age", "sex", "smoking", "benzene",
                                         "id")))

geneIDs <- colnames(Y)

## ----biomarkerTMLE_eval, eval=FALSE--------------------------------------
#  biomarkerTMLEout <- biomarkertmle(Y = Y,
#                                    W = W,
#                                    A = A,
#                                    type = "exposure",
#                                    parallel = TRUE,
#                                    family = "gaussian",
#                                    g_lib = c("SL.glmnet", "SL.randomForest",
#                                              "SL.polymars", "SL.mean"),
#                                    Q_lib = c("SL.glmnet", "SL.randomForest",
#                                              "SL.nnet", "SL.mean")
#                                   )

## ----load_biomarkerTMLE_result, echo=FALSE-------------------------------
data(biomarkertmleOut)

## ----limmaTMLE_eval, eval=FALSE------------------------------------------
#  design <- as.data.frame(cbind(rep(1, nrow(Y)),
#                                as.numeric(A == max(unique(A)))))
#  colnames(design) <- c("intercept", "Tx")
#  
#  limmaTMLEout <- limmatmle(biotmle, IDs = NULL, designMat = design)

## ----heatmap_limma_results, eval=FALSE-----------------------------------
#  heatmap_biotmle(biotmle, designMat = design, FDRcutoff = 0.05, top = 25)

## ----pval_hist_limma_results, eval=FALSE---------------------------------
#  plot_biotmle(biotmle, type = "pvals_raw")
#  
#  plot_biotmle(biotmle, type = "pvals_adj")

## ----volcano_plot_limma_results, eval=FALSE------------------------------
#  volcplot_biotmle(biotmle)

