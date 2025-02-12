% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sim_items.R
\name{sim.items}
\alias{sim.items}
\title{generate item parameters}
\usage{
sim.items(design.load, K, nb, load.range, int.range)
}
\arguments{
\item{design.load}{design matrix of questionnaire, rows=items, columns=traits, 1=positively keyed, -1=negatively keyed}

\item{K}{scalar, number of blocks}

\item{nb}{scalar, block size}

\item{load.range}{vector, giving the range for factor loadings}

\item{int.range}{vector, giving the range for item intercepts}
}
\value{

}
\description{
generate item parameters
}
