% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rnaseq.R
\name{rnaseq_ic}
\alias{rnaseq_ic}
\title{Utility for using voom transformation with TMLE for biomarker discovery}
\usage{
rnaseq_ic(biotmle, weights = TRUE, ...)
}
\arguments{
\item{biotmle}{A \code{bioTMLE} object containing next-generation sequencing
count data in its "assays" slot.}

\item{weights}{A \code{logical} indicating whether to return quality weights
of samples in the output object.}

\item{...}{Other arguments to be passed to \code{\link[limma]{voom}} or
\code{\link[limma]{voomWithQualityWeights}} as appropriate.}
}
\value{
\code{EList} object containing voom-transformed expression measures
 of count data (actually, the mean-variance trend) in the "E" slot, to be
 passed into the biomarker TMLE procedure.
}
\description{
This function prepares next-generation sequencing data (counts) for use with
the biomarker TMLE procedure by invoking the voom transform of \code{limma}.
}
