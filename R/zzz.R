.onAttach <- function(...) {
  packageStartupMessage(paste0(
    "biotmle v",
    utils::packageDescription("biotmle")$Version,
    ": Targeted Learning with Moderated Statistics for Biomarker Discovery"
  ))
}
