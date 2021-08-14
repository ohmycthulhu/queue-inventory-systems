source('functions.R')

K_h <- 25;
K_l <- 35;
r_l <- 25;
r_h <- 15;
lambda_h <- 25;
lambda_l <- 35;
mu_f <- 30;
mu_s <- 30;
alpha <- 0.7;

initializeConstants(lambda_h, mu_f, lambda_l, mu_s, K_l, K_h, alpha, r_l, r_h)

Reduce(function (acc, i) { acc + rho_0(i)}, 0:K_h, 0)
Reduce(function (acc, i) { acc + rho_1(i)}, 0:K_h, 0)
Reduce(function (acc, l) { acc + pi(l) }, 0:K_l, 0)

W_h()
