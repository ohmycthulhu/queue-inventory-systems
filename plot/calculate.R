source('functions.R')

getRow <- function (
  lambda_1,
  lambda_2,
  mu,
  alpha,
  S,
  s,
  sigma,
  c_l_1,
  c_l_2,
  c_r_1,
  c_r_2,
  c_r,
  c_h,
  si
) {
  setEconomical(
    c_r_ = c_r,
    c_h_ = c_h,
    c_l_1_ = c_l_1,
    c_l_2_ = c_l_2,
    c_r_1_ = c_r_1,
    c_r_2_ = c_r_2
  )
  
  initializeConstants(
    l_1 = lambda_1,
    l_2 = lambda_2,
    mu_ = mu,
    a = alpha,
    S_ = S,
    s_ = s,
    sigma_ = sigma
  )
  
  data.frame(
    si = si,
    lambda_1 = lambda_1,
    lambda_2 = lambda_2,
    mu = mu,
    alpha = alpha,
    c_l_1 = c_l_1,
    c_l_2 = c_l_2,
    c_r_1 = c_r_1,
    c_r_2 = c_r_2,
    c_r = c_r,
    c_h = c_h,
    S = S,
    s = s,
    PB1 = PB1(),
    PB2 = PB2(),
    Sav = Sav(),
    RR = RR(),
    RV = RV(s),
    TC = TC(s),
    PT = PT(s)
  )
}

result = data.frame()

Smax = 120
ss = c(1:(Smax- 1))

sigmas = c(
  get_sigma_1(Smax),
  get_sigma_2(Smax),
  get_sigma_3(Smax)
)

for (s_ in ss) {
  si = 1
  for (sigma in sigmas) {
    result <- rbind(result, getRow(
      lambda_1 = 50,
      lambda_2 = 200,
      mu = 20,
      alpha = 0.3,
      S = 120,
      s = s_,
      si = si,
      sigma = sigma,
      c_l_1 = 2,
      c_l_2 = 6,
      c_r_1 = 5,
      c_r_2 = 10,
      c_r = 0.01,
      c_h = 0.2
    ))
    si = si + 1
  }
}

write.csv(result, file='result.csv')


