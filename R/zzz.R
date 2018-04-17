.onAttach <- function(...) {
  packageStartupMessage(paste0(
    "biotmle v:",
    utils::packageDescription("biotmle")$Version,
    ": Moderated and Targeted Statistical Learning ",
    "for Biomarker Discovery"
  ))
}
