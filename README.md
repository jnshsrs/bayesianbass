
-   [Bayesian Bass Model](#bayesian-bass-model)
    -   [Bayesian Approach](#bayesian-approach)
    -   [Model Coefficients](#model-coefficients)
-   [Installation](#installation)
-   [Create a Bayesian Bass model](#create-a-bayesian-bass-model)
-   [Outlook](#outlook)
-   [Resources](#resources)

Bayesian Bass Model
===================

*bayesianbass* is a package to create Bass Diffusion Models with a Bayesian Approach.

The Bass model describes mathematically the uptake of innovations, products and behaviors. It is based on the Diffusion of innovation theory by Rogers. The model was first published in 1963 by Professor Frank M. Bass followed by a paper published in 1969 providing empricial evidence, that was missing up to this point.

Bayesian Approach
-----------------

The Bayesian approach offers advantages such as estimating a complete bivariate probability distribution of the model coefficients, which are described below, and additionally, the Bayesian model is able to incorporate prior knowledge about the coefficients.

Model Coefficients
------------------

The Bass model describes the uptake of a diffusion with two parameters, p and q, which are interpreted as coefficient of innovation and coefficient of imitation respectively. Together, both coefficients describe the diffusion dynamics. You can find further information in Bass' publications and in [my blog post](https://sciphy-stats.netlify.com/post/estimating-the-bass-model/) which unfortunately is only available in German. Another good resource is Mannemeyer et al. (2005) which describes the basic Bass Model in the methods section.

This package provides functions to create Bayesian Bass Diffusion models with additional functions to plot the diffusion course and predict the uptake of an innovation.

Installation
============

Before you download the package, please make sure that you have `rjags` installed. The `bayesianbass` package uses `rjags` which offer implementations of Monte Carlo Markov Chains which simulate the posterior distribution of the Bayesian Bass Diffusion model.

Note that `rjags` requires a separate installation of `JAGS` (just another gibbs sampler). [You can find information about the installation of jags](http://mcmc-jags.sourceforge.net/). After the installation of `JAGS` install `rjags` via `install.packages(rjags)`.

Next install `bayesianbass` using `devtools`

``` r
devtools::install_github("jnshsrs/bayesianbass")
```

Main Functions
============

The main functions of the package are:

1. `bayesian_bass()`
2. `plot.bayesian_bass()`
3. `predict.bayesian_bass()`
4. `predict_adoption()` with a `plot` generic
5. `predict_diffusion()` with a `plot` generic

These functions are introduced in the following sections

Create a Bayesian Bass model
============================

``` r
library(bayesianbass)
```

First, we need to specifiy our model, that is then simulated via rjags. Do do so, we create a character string describing the model. It also contains the prior distributions which are modeled as normal distributions for both model parameters, p and q. The default prior distribution is uncommital, which means that prior to the analysis no specific knowledge about model coefficients are incorporated. To get the default prior distributions, just run the `bayesian_bass_model` function without any arguments.

``` r
# We create the model description with uncommital prior
# Function returns a character string which is used by rjags to create the model
model <- bayesianbass::bayesian_bass_model()
```

In this example, we use a sample dataset containing two columns, first, the time index and second, the adoption status, indicating wether or not an entity is an adopter. This column may only contain 0 or 1, where the 0 represents a non-adopter and 1 represents an adopter. Please note, that the time index column is named `time_index`, the column containing the adoption status can be specified as string in the function call.

We use the model description as function argument to the `bayesian_bass` function.

``` r
# load sample adoption data
data(adoption_data)

# create model
fit <- bayesian_bass(data = adoption_data,
                     model = model,
                     var = "adoption",
                     plot_diagnostics = T,
                     n_iter = 1e4)
```

    ## Compiling model graph
    ##    Resolving undeclared variables
    ##    Allocating nodes
    ## Graph information:
    ##    Observed stochastic nodes: 50
    ##    Unobserved stochastic nodes: 2
    ##    Total graph size: 139
    ## 
    ## Initializing model

![](README_files/figure-markdown_github/unnamed-chunk-4-1.png)

``` r
# display model coefficients
print(fit)
```

    ## # A tibble: 1 x 2
    ##        p     q
    ##    <dbl> <dbl>
    ## 1 0.0718 0.300

Next we plot the adoption for each point in time with the fitted bass model superimposed as adoption curve.

``` r
plot(fit, se = FALSE)
```

![](README_files/figure-markdown_github/unnamed-chunk-5-1.png)

Furthermore, we can predict the expected uptake.

The function accepts integers as input to the interval parameter. This may be a single integer or a sequence of integers.

``` r
predicted_uptake <- predict(fit, interval = 2:4)
head(predicted_uptake)
```

    ## # A tibble: 3 x 2
    ##       t predicted
    ##   <int>     <dbl>
    ## 1     2     0.176
    ## 2     3     0.284
    ## 3     4     0.398

However, we did not use the advantages of the bayesian approach to Bass models, which will provide a complete distribution over parameters or predictions.

The following code will provide a complete probability distribution of the predicted uptake on time point t=3. We will see that the uptake will be most likely be around 20%.

``` r
pred_adoption <- bayesianbass::predict_adoption(fit, time = 3)
plot(pred_adoption)
```

    ## Warning: Removed 1 rows containing non-finite values (stat_density).

![](README_files/figure-markdown_github/unnamed-chunk-7-1.png)

Since the plot function returns a ggplot object, we can simply edit the plot.

``` r
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 3.5.2

``` r
plot(pred_adoption) + theme_minimal()
```

    ## Warning: Removed 1 rows containing non-finite values (stat_density).

![](README_files/figure-markdown_github/unnamed-chunk-8-1.png)

We can also plot the complete diffusion course with the corresponding HDIs (Highes Density Intervals).

``` r
pred_diffusion <- predict_diffusion(fit)
plot(pred_diffusion)
```

![](README_files/figure-markdown_github/unnamed-chunk-9-1.png)

The `bayesianbass::predict_diffussion` function contains additinal information. However no getter function exist, so you may use `purrr`'s `pluck` function to access its elements.

``` r
str(pred_diffusion)
```

    ## List of 3
    ##  $ diffusion_predicted:List of 10
    ##   ..$ : num [1:800] 0.08204 0.01902 0.00713 0.05947 0.01473 ...
    ##   ..$ : num [1:800] 0.1675 0.0535 0.0242 0.1381 0.0425 ...
    ##   ..$ : num [1:800] 0.2544 0.1131 0.0635 0.2362 0.093 ...
    ##   ..$ : num [1:800] 0.341 0.208 0.147 0.35 0.178 ...
    ##   ..$ : num [1:800] 0.424 0.344 0.301 0.471 0.307 ...
    ##   ..$ : num [1:800] 0.503 0.505 0.515 0.588 0.47 ...
    ##   ..$ : num [1:800] 0.575 0.664 0.722 0.693 0.638 ...
    ##   ..$ : num [1:800] 0.641 0.791 0.864 0.779 0.778 ...
    ##   ..$ : num [1:800] 0.699 0.879 0.94 0.846 0.874 ...
    ##   ..$ : num [1:800] 0.75 0.933 0.974 0.894 0.932 ...
    ##  $ diffusion_data     :Classes 'tbl_df', 'tbl' and 'data.frame': 10 obs. of  4 variables:
    ##   ..$ avg_adoption : num [1:10] 0.0712 0.1479 0.2343 0.3314 0.4364 ...
    ##   ..$ sdev_adoption: num [1:10] 0.0504 0.0773 0.0915 0.0947 0.09 ...
    ##   ..$ hdi_lower    : num [1:10] 0.00441 0.02214 0.07387 0.15718 0.26203 ...
    ##   ..$ hdi_upper    : num [1:10] 0.16 0.291 0.411 0.525 0.605 ...
    ##  $ diffusion_actual   :Classes 'tbl_df', 'tbl' and 'data.frame': 5 obs. of  5 variables:
    ##   ..$ t    : num [1:5] 2 4 6 8 10
    ##   ..$ n    : int [1:5] 10 10 10 10 10
    ##   ..$ Lower: num [1:5] 0 0 0.3 0.4 0.7
    ##   ..$ avg  : num [1:5] 0.1 0.2 0.6 0.7 0.9
    ##   ..$ Upper: num [1:5] 0.3 0.5 0.9 1 1
    ##  - attr(*, "class")= chr "bayesian_bass_diffusion"

``` r
purrr::pluck(pred_diffusion, "diffusion_data")
```

    ## # A tibble: 10 x 4
    ##    avg_adoption sdev_adoption hdi_lower hdi_upper
    ##           <dbl>         <dbl>     <dbl>     <dbl>
    ##  1       0.0712        0.0504   0.00441     0.160
    ##  2       0.148         0.0773   0.0221      0.291
    ##  3       0.234         0.0915   0.0739      0.411
    ##  4       0.331         0.0947   0.157       0.525
    ##  5       0.436         0.0900   0.262       0.605
    ##  6       0.542         0.0843   0.365       0.699
    ##  7       0.640         0.0843   0.487       0.803
    ##  8       0.723         0.0881   0.563       0.880
    ##  9       0.789         0.0908   0.623       0.942
    ## 10       0.838         0.0907   0.664       0.970

Outlook
=======

This packages contains the main functions to fit and plot a Bayesian Bass Model and predict future uptake of innovations. However, some functions such as getter functions are still missing. I do not plan to develop this package further in the near future, but maybe people in innovation science may find it useful. Feel free to clone and add new features to this package.

Resources
=========

E.M. Rogers, Diffusion of innovations, 5th ed, Free Press, New York, 2003.

F.M. Bass, A New Product Growth for Model Consumer Durables, Manag. Sci. 15 (1969) 215–227. <doi:10.1287/mnsc.15.5.215>.

V. Mahajan, E. Muller, and F.M. Bass, New Product Diffusion Models in Marketing: A Review and Directions for Research, in: N. Nakićenović, and A. Grübler (Eds.), Diffus. Technol. Soc. Behav., Springer Berlin Heidelberg, Berlin, Heidelberg, 1991: pp. 125–177. <doi:10.1007/978-3-662-02700-4_6>.

S.T. Mennemeyer, N. Menachemi, S. Rahurkar, and E.W. Ford, Impact of the HITECH Act on physicians’ adoption of electronic health records, J. Am. Med. Inform. Assoc. 23 (2016) 375–379. <doi:10.1093/jamia/ocv103>.
