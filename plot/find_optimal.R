source('calculate.R')


TC <- function (c_jp, c_lh, c_ll, c_wh, c_wl) {
  (
    c_jp * RJ() +
      lambda_h * c_lh * PB_h() +
      lambda_l * c_ll * PB_l() +
      c_wh * W_h() +
      c_wl * W_l()
  )
}

calculate_rows <- function (l_h, l_l, mu_f, mu_s, alpha, K_h, K_l) {
  r_hs = 1:K_h
  r_ls = 1:K_l
  
  result <- data.frame()
  for (r_h in r_hs) {
    for (r_l in r_ls) {
      initializeConstants(
        l_h = l_h,
        l_l = l_l,
        mu_f_ = mu_f,
        mu_s_ = mu_s,
        a = alpha,
        r_l_ = r_l,
        r_h_ = r_h,
        K_l_ = K_l,
        K_h_ = K_h
      )
      
      result <- rbind(result, data.frame(
        lambda_h = l_h,
        lambda_l = l_l,
        mu_f,
        mu_s,
        K_l,
        K_h,
        alpha = alpha,
        r_h,
        r_l,
        PB_l = PB_l(),
        PB_h = PB_h(),
        RJ = RJ(),
        N_h = N_h(),
        N_l = N_l(),
        W_l = W_l(),
        W_h = W_h(),
        TC = TC(
          c_jp = 0.5,
          c_lh = 3,
          c_ll = 2,
          c_wh = 0.7,
          c_wl = 0.2
        ))
      )
    }
  }
  result
}

K_hs = c(10, 15, 20)
K_ls = c(10, 15, 20)

all_data <- data.frame()
optimized_data <- data.frame()

for (k_h in K_hs) {
  for (k_l in K_ls) {
    tempData <- calculate_rows(
      l_h = 25,
      l_l = 35,
      mu_f = 30,
      mu_s = 20,
      alpha = 0.7,
      K_h = k_h,
      K_l = k_l
      )
    minRow <- tempData[tempData$TC == min(tempData$TC), ]
    all_data <- rbind(all_data, tempData)
    optimized_data <- rbind(optimized_data, minRow)
  }
}

write.csv(all_data, 'optimization_all.csv')
write.csv(optimized_data, 'optimization.csv')
