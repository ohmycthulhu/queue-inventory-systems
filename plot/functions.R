S <- NULL
s <- NULL
lambda_1 <- NULL
lambda_2 <- NULL
mu <- NULL
alpha <- NULL
sigma <- NULL

c_r <- NULL
c_h <- NULL
c_l_1 <- NULL
c_l_2 <- NULL
c_r_1 <- NULL
c_r_2 <- NULL

# Calculate
lambda <- NULL
lambda_t <- NULL
p0 <- NULL

# Function that calculates constants
initializeConstants <- function (
  l_1,
  l_2,
  mu_,
  a,
  sigma_,
  S_,
  s_
) {
  # Assign constants
  S <<- S_
  s <<- s_
  lambda_1 <<- l_1
  lambda_2 <<- l_2
  mu <<- mu_
  alpha <<- a
  sigma <<- sigma_
  
  # Calculate the variables
  lambda <<- calculate_lambda()
  lambda_t <<- calculate_lambda_t()
  p0 <<- calculate_p_0()
}

setEconomical <- function (
  c_r_,
  c_h_,
  c_l_1_,
  c_l_2_,
  c_r_1_,
  c_r_2_
) {
  c_r <<- c_r_
  c_h <<- c_h_
  c_l_1 <<- c_l_1_
  c_l_2 <<- c_l_2_
  c_r_1 <<- c_r_1_
  c_r_2 <<- c_r_2_
}

calculate_lambda <- function () {
  lambda_1 + lambda_2
}

calculate_lambda_t <- function () {
  lambda_1 + lambda_2 * alpha
}

phi <- function (m) {
  if (m > 1) {
    1 - Reduce(function (acc, i) { acc + sigma(i)}, 1:(m-1), 0)
  } else {
    1
  }
}

calculate_p_0 <- function () {
   p1 <- Reduce(function (acc, i) { acc + phi(i)}, 1:s, 0)
   p2 <- Reduce(function (acc, i) { acc + phi(i)}, (s+1):S, 0)
   (1 + mu * (p1 / lambda_t + p2 / lambda))^-1
}

set_s <- function (s_) {
  if (s != s_) {
    initializeConstants(
      lambda_1,
      lambda_2,
      mu,
      alpha,
      sigma,
      S,
      s_
    )
  }
}

PB1 <- function () {
  p1 <- (1 - alpha)
  p3 <- p0
  p21 <- Reduce(function (acc, m) { acc + phi(m) }, 1:s, 0)
  p2 <- 1 + mu / lambda_t * p21
  p1 * p2 * p3
}

PB2 <- function () {
  p0
}

RR <- function () {
  mu * p0
}

Sav <- function () {
  p1 <- mu * p0
  p21 <- Reduce(function (acc, m) { acc + phi(m) }, 1:s, 0)
  p22 <- Reduce(function (acc, m) { acc + phi(m) }, (s+1):S, 0)
  p1 * (p21 / lambda_t + p22 / lambda)
}

RV <- function (s_) {
  set_s(s_)
  p1 <- c_r_1 * lambda_1 * (1 - PB1())
  p2 <- c_r_2 * lambda_2 * (1 - PB2())
  p1 + p2
}

TC <- function (s_) {
  set_s(s_)
  p1 <- c_r * S * RR() 
  p2 <- c_h * Sav() 
  p3 <- c_l_1 * lambda_1 * PB1()
  p4 <- c_l_2 * lambda_2 * PB2()
  p1 + p2 + p3 + p4
}

PT <- function (s_) {
  RV(s) - TC(s)
}

get_sigma_1 <- function (S) {
  function (m) {
    1 / S
  }
}

get_sigma_2 <- function (S) {
  sigma_1 <- 1 / S / 2
  epsilon <- 2 * (1 - S * sigma_1) / S / (S - 1)
  sigma <- function (m) {
    if (m > 1) {
      sigma(m - 1) + epsilon
    } else {
      sigma_1
    }
  }
  sigma
}

get_sigma_3 <- function (S) {
  sigma_1 <- 1.5 / S
  epsilon <- 2 * (S * sigma_1 - 1) / S / (S - 1)
  sigma <- function (m) {
    if (m > 1) {
      sigma(m - 1) - epsilon
    } else {
      sigma_1
    }
  }
  sigma
}
