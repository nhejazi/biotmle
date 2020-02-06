.onAttach <- function(...) {
  packageStartupMessage(paste0(
    "biotmle v", utils::packageDescription("biotmle")$Version,
    ": ", utils::packageDescription("biotmle")$Title
  ))
}
