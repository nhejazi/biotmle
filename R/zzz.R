.onAttach <- function(...) {
  packageStartupMessage(paste("biotmle: Moderated Statistics and Targeted",
                              "Learning\n for Biomarker Discovery"))
  packageStartupMessage("Version: ",
                        utils::packageDescription("biotmle")$Version)
}
