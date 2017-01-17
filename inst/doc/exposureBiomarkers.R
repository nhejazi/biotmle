## ----setup_data----------------------------------------------------------
library(dplyr)
library(biotmle)
data(illuminaData)
"%ni%" = Negate("%in%")
subjIDs <- illuminaData$id

## ----clean_data----------------------------------------------------------
# W - age, sex, smoking
W <- illuminaData %>%
  dplyr::select(which(colnames(.) %in% c("age", "sex", "smoking"))) %>%
  dplyr::mutate(
    age = as.numeric((age > quantile(age, 0.25))),
    sex = I(sex),
    smoking = I(smoking)
  )


# A - benzene exposure (discretized)
A <- illuminaData %>%
  dplyr::select(which(colnames(.) %in% c("benzene")))
A <- A[, 1]


# Y - genes
Y <- illuminaData %>%
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

## ----limmaTMLE_eval------------------------------------------------------
design <- as.data.frame(cbind(rep(1, nrow(Y)),
                              as.numeric(A == max(unique(A)))))
colnames(design) <- c("intercept", "Tx")

limmaTMLEout <- limmatmle(biotmle = biomarkerTMLEout, IDs = NULL,
                          designMat = design)

## ----pval_hist_limma_adjp------------------------------------------------
plot(x = limmaTMLEout, type = "pvals_adj")

## ----pval_hist_limma_rawp------------------------------------------------
plot(x = limmaTMLEout, type = "pvals_raw")

## ----heatmap_limma_results-----------------------------------------------
heatmap_biotmle(x = limmaTMLEout, designMat = design, FDRcutoff = 0.05,
                top = 25)

## ----volcano_plot_limma_results------------------------------------------
volcano_biotmle(biotmle = limmaTMLEout)

