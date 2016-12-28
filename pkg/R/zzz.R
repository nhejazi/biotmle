.onAttach <- function(...) {
  packageStartupMessage("tmlelimma: Targeted Learning with the moderated t-statistic")
  packageStartupMessage("Version: ",
                        utils::packageDescription("tmlelimma")$Version)
}
