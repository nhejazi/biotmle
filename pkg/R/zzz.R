.onAttach <- function(...) {
  packageStartupMessage("TargetedLimma: Targeted Learning with Genomic Data")
  packageStartupMessage("Version: ",
                        utils::packageDescription("TargetedLimma")$Version)
}
