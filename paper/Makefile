TITLE = paper
.PHONY : pdf

pdf:
	Rscript -e "rmarkdown::render('$(TITLE).Rmd', output_format = c('md_document', 'pdf_document'))"
