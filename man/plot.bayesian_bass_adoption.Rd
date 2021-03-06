% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-bayesian-bass-model.R
\name{plot.bayesian_bass_adoption}
\alias{plot.bayesian_bass_adoption}
\title{Plot distribution of adoption rate}
\usage{
\method{plot}{bayesian_bass_adoption}(obj, ...)
}
\arguments{
\item{obj}{An object of class \code{bayesian_bass_adoption}}
}
\value{

}
\description{
Plot distribution of adoption rate
}
\examples{
data(adoption_data)
model <- bayesian_bass_model()
fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
fit_adoption <- predict_adoption(fit, time = 1)
plot(fit_adoption)

}
