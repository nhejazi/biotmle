library(here)
"%ni%" = Negate("%in%")

illuminaData <- illumina2007 %>%
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

save(illuminaData, file = paste0(normalizePath(here("..", "data")),
                                 "illuminaData.rda"))
