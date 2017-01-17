.onAttach <- function(...) {
  packageStartupMessage("biotmle: Targeted Learning for Biomarker Discovery")
  packageStartupMessage("Version: ",
                        utils::packageDescription("biotmle")$Version)
}
