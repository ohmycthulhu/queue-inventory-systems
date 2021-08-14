source('./plot_functions.R')
plots = read.csv('./plots.csv', stringsAsFactors = FALSE)

cols_labels = function (label) {
  result = label
  if (label == 'PB_p') {
    result = expression(PB[p]) 
  } else if (label == 'PB_r') {
    result = expression(PB[r]) 
  } else if (label == 'NCO_av') {
    result = expression(NCO[av])
  } else if (label == 'NFS_av') {
    result = expression(NFS[av])
  } else if (label == 'NBS_av') {
    result = expression(NBS[av])
  } else if (label == 'P_sys') {
    result = expression(P[sys])
  } else if (label == 'P_ser') {
    result = expression(P[ser])
  } else if (label == 'P_p') {
    result = expression(P[p])
  } else if (label == 'P_f') {
    result = expression(P[f])
  } else if (label == 'BC_av') {
    result = expression(BC[av])
  } else if (label == 'L_f') {
    result = expression(L[f])
  } else if (label == 'L_o') {
    result = expression(L[o])
  }
  result
}

for (pI in 1:dim(plots)[1]) {
  p = plots[pI,]
  print(p$file)
  data = read.csv(p$file)
  cols = unlist(strsplit(p$cols, ','))
  
  plot_data(
    folder=p$folder,
    colsVar=p$colVar,
    colsCon=p$colCon,
    cols=cols,
    data=data,
    labels_dict=cols_labels
  )
}