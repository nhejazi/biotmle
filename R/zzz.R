.onAttach <- function(...) {
  packageStartupMessage(paste0(
    "biotmle v",
    utils::packageDescription("biotmle")$Version,
    ": Moderated Targeted Learning for Biomarker Discovery"
  ))
}
