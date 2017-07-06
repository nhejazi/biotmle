md:
	r -e "rmarkdown::render('README.Rmd')"

check:
	r -e "devtools::check()"

test:
	r -e "devtools::test()"

doc:
	r -e "devtools::document()"

cov:
	r -e "covr::package_coverage(type = 'all', combine_types = FALSE, line_exclusions = list('R/plots.R'))"
