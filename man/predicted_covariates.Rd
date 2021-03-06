% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predictionErrorGMM.R
\name{predicted_covariates}
\alias{predicted_covariates}
\title{GMM estimator for models with (imperfectly) predicted covariates}
\usage{
predicted_covariates(y, Xu, Xo, Zu, v, t, p, ER_test_signif_level = 0.05,
  confint_signif_level = 0.05, ER_test = TRUE,
  include_intercept = TRUE, min_iter = 2, max_iter = 25,
  tol = 0.01, verbose = TRUE)
}
\arguments{
\item{y}{vector of n outcome values}

\item{Xu}{matrix/vector of n possibly unobserved (i.e., NA) covariate values; must be observed when v or t == 1}

\item{Xo}{matrix/vector of n fully observed covariate values; may be set to NULL, but should never contain a constant term --- control the inclusion of a constant term via \code{include_intercept} option}

\item{Zu}{matrix/vector of n fully observed predicted Xu values; must be observed when v or p == 1}

\item{v}{vector of n 1/0 where v[i] == 1 if unit i is validation sample, == 0 otherwise; sum(v) > 0 is required}

\item{t}{vector of n 1/0 where v[i] == 1 if unit i is training sample, == 0 otherwise; sum(t) == 0 is allowed}

\item{p}{vector of n 1/0 where v[i] == 1 if unit i is primary sample, == 0 otherwise; sum(p) == 0 is allowed, but then it wouldn't make sense to use this package}

\item{ER_test_signif_level}{default is 0.05; significance level for the ER test warning message, but note that the pvalue itself is not suppreseed}

\item{confint_signif_level}{default is 0.05; 1 - confint_signif_level determines the confidence level for the provided GMM estimator confidence intervals}

\item{ER_test}{default is TRUE; if TRUE, uses the validation sample to test the required exclusion restriction: `E(epsilon z_u) = 0' via Sargan's J-test results from the \code{gmm} package; see our paper for construction of the test}

\item{include_intercept}{default is TRUE; if TRUE, will append a columns of ones to Xo, inducing an intercept term in the model y ~ X}

\item{min_iter}{default is 2; min_iter - 1 determines how many iterations the GMM weighting matrix is based on both unlabeled and labeled data}

\item{max_iter}{default is 25; determines how many iterations the GMM estimator will take before quitting}

\item{tol}{default is 0.01; the algorithm uses [min_iter, max_iter] iterations, stopping if percent changes in beta are < tol for each element of beta}

\item{verbose}{default is TRUE; tells the function whether to print convergence and other warnings}
}
\value{
A list of
\itemize{
\item{GMM estimated coefficients \code{beta}}
\item{estimated standard errors \code{se}}
\item{estimated confidence intervals \code{confint} at the confidence level 1 - \code{confint_signif_level}}
\item{variance-covariance matrix estimate \code{vcov}}
\item{exclusion restriction test p-value \code{pval}}
\item{labeled-only estimator of beta \code{lab_only}}
}
}
\description{
Optimally combines OLS and 2SLS on labeled and unlabeled data,
given an exclusion restriction. See associated paper for details.
}
\examples{
set.seed(1234)
n <- 2e3
n_v <- 150
n_t <- 100
n_p <- n - n_v - n_t
lab <- sample(n, n_v + n_t)
val <- sample(lab, n_v)
v <- 1 * (1:n \%in\% val)
p <- 1 * (! 1:n \%in\% lab)
t <- 1 - v - p

beta_true <- c(0.2, 0.4, 0.3)
sigma <- 1.0

Xu <- rnorm(n)
Xo <- rnorm(n)
epsilon <- sigma * rnorm(n)
y <- cbind(Xu, Xo, 1) \%*\% beta_true + epsilon
Zu <- Xu + rnorm(n) # Zu predicts Xu without being correlated with epsilon

Zu[t == 1] <- NA
Xu[p == 1] <- NA

predicted_covariates(y, Xu, Xo, Zu, v, t, p)
}
