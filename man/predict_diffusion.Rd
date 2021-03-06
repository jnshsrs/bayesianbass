% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict-bass-model.R
\name{predict_diffusion}
\alias{predict_diffusion}
\title{Predict the diffusion based on a bayesian bass model}
\usage{
predict_diffusion(obj, time_index = NULL)
}
\arguments{
\item{obj}{An object of class \code{bayesian_bass}}

\item{time_index}{An integer vector conaining a sequence of time intervals}
}
\value{

}
\description{
Predict the diffusion based on a bayesian bass model
}
\examples{
data(adoption_data)
model <- bayesian_bass_model()
fit <- bayesian_bass(data = adoption_data, var = "adoption", model = model)
predict_diffusion(fit)
}
