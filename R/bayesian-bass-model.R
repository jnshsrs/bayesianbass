#' Specification of Bayesian Bass Model
#'
#' Function returns a string with model specifications that can be processed by rjags
#'
#' @return A character string containing the Bayesian Bass Diffusion Model specifications
#'
#' @export
#'
bayesian_bass_model <- function() {
    model <- "model {
    # likelihood
    for(i in 1:N) {
      mu[i] <- (1 - exp(-(p + q) * time[i])) / (1 + (q / p) * exp(-(p + q) * time[i]))
      y[i] ~ dbern(mu[i])
    }

    # priors of model coefficients
    p ~ dnorm(.04, .06)
    q ~ dnorm(.4, .6)
    }
  "
    return(model)
}


#' Function to fit Bayesian Model
#'
#' @param data A data.frame with two columns, the first must be named jahr and contains time index, the second colum is named var and is a binary variable, representing
#' @param introduction Integer, if provided, the time column of data is rescaled to the date of market introduction
#' @param var Column name of variable containing the dichotomous data of product adoption
#' @param n_iter Integer, number of iterations
#' @param model Text string containing the Bayesian Model Specification
#' @param plot_diagnostics Wether to show diagnostic MCMC plots
#'
#' @return An object of class \code{bayesian_bass}
#' @export
#'
#' @import dplyr
#' @import tibble
#' @import tidyr
#' @import purrr
#' @import readr
#'
#'
#' @examples \dontrun{bayesian_bass(data = data, var = 'adoption', model = bayesian_bass_model())}
bayesian_bass <- function(data,
                          var,
                          model,
                          n_iter = 5000,
                          n_thin = 50,
                          plot_diagnostics = FALSE) {

  # data preprocessing
  data <- data %>% dplyr::select(time_index, var) %>% dplyr::filter(complete.cases(.))

  # summary, compute adoption rates
  adoption_rates <- data %>% dplyr::group_by(time_index) %>%
    summarise(n = n(), st_err = list(Hmisc::smean.cl.boot(!!rlang::sym(var)))) %>%
    mutate(st_err = st_err %>%
             map(enframe)) %>%
    unnest(st_err) %>%
    spread(key = name, value = value) %>%
    rename(t = time_index, avg = Mean)

  # outcome variable
  y <- data %>% pull(var)

  # extract time
  time <- data %>% pull(time_index)

  # Number of data points
  N <- nrow(data)

  # Creating list for data interface of rjags bayesian models
  data <- list(y = y, time = time, N = N)

  # Create rjags model
  rjags_model <- rjags::jags.model(textConnection(model), data = data, n.chains = 4)

  # Simulate MCMC
  rjags_sample <- rjags::coda.samples(rjags_model, variable.names = c("p", "q"), n.iter = n_iter, thin = n_thin)

  if (plot_diagnostics) {
    # MCMC Diagnostics
    plot(rjags_sample)
  }

  # Extracting Chains
  rjags_chains <- rjags_sample[[1]] %>% as_tibble()

  # Computing Mean values of p and q
  coefs <- rjags_chains %>% as_tibble() %>% summarise_all(mean)

  # Create return value (List)
  lst_results <- list(adoption_rates = adoption_rates,
                      coefs = coefs,
                      rjags_chains = rjags_chains,
                      rjags_sample = rjags_sample,
                      data = data)

  class(lst_results) <- "bayesian_bass"
  lst_results
}
