library(covr)
cov <- package_coverage(type = "all", combine_types = FALSE,
                        line_exclusions = list("R/plots.R"),
                        function_exclusions = "\\.onLoad")
cov
