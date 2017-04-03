.onAttach <- function(...) {
  packageStartupMessage("biotmle: Moderated Statistics and Targeted Learning for Biomarker Discovery")
  packageStartupMessage("Version: ",
                        utils::packageDescription("biotmle")$Version)
}
