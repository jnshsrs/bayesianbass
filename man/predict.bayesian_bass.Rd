% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict-bass-model.R
\name{predict.bayesian_bass}
\alias{predict.bayesian_bass}
\title{Bass Model Predictions}
\usage{
\method{predict}{bayesian_bass}(obj, intervals = NULL)
}
\arguments{
\item{object}{An \code{bayesian_bass} object}

\item{interval}{An integer vector containing the time points of data collection}
}
\value{
A tibble with two columns, time and prediction
}
\description{
Bass Model Predictions
}
\examples{
data(adoption_data)
model <- bayesian_bass_model()
fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
predict(fit)

}
