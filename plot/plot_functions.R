plot_data <- function  (folder, colsVar, colsCon, cols, data, labels_dict) {
  filteredData = 
    data[lapply(names(data), function (i) { i == colsCon || i == colsVar || i %in% cols}) > 0]
  
  r_hs = unique(data[,colsCon])
  
  colors = c('black', 'black', 'black')
  pchs = c(4, 5, 1)
  
  for (col in cols) {
      xLim = c(min(data[colsVar]), max(data[colsVar]))
      yLim = c(min(data[col]), max(data[col]))
      
      plot(
        c(),
        c(),
        ylab=labels_dict(col),
        xlab=colsVar,
        xlim=xLim,
        ylim=yLim
      )
      
      i = 1
      vals = unlist(unique(data[colsCon]))
      
      for (val in vals) {
        d = data[data[colsCon] == val,]
          
        xVar = d[,colsVar]
        yVar = d[,col]
        
        print(val)
        
        lines(
          xVar,
          yVar,
          type='o',
          pch=pchs[i],
          col=colors[i]
        )
        
        i = i %% length(pchs) + 1
      }
      
      legend(x = xLim[2] - 2.5, # Position
             y = get_legend_position(data[, colsVar], data[, col], yLim[1], yLim[2]),
             legend = get_legends_text(vals, colsCon),  # Legend texts
             pch = pchs,           # Line types
             lwd = 2)                 # Line width
    
    dev.copy(png, paste("images/",folder,'/', col, ".png", sep=''))
    dev.off()
  }
}

get_legend_position <- function (xs, ys, yMin, yMax) {
  diff = (yMax - yMin)
  points = (ys[xs >= (min(xs) + (max(xs) - min(xs)) * 0.7)] - yMin) / diff
  if (length(points[points >= 0.7]) == 0) yMax
  else if (length(points[points <= 0.3]) == 0) yMin + diff * 0.45
  else (yMax + yMin) / 2 + diff * 0.25
}

greek_letters <- c(c('alpha', 'α'), c('beta', 'β'), c('gamma', 'γ'), c('sigma', 'σ'))

get_dict_value <- function (dict, key, default) {
  result = default
  for (i in ((1:(length(dict) / 2)) * 2 - 1)) {
    print(key)
    print(dict[i])
    if (key == dict[i]) {
      result = dict[i + 1]
      break;
    }
  }
  result
}

get_legends_text <- function (values, label) {
  l = get_dict_value(greek_letters, label, label)
  
  lapply(values, function (val) {
    paste(l, '=', val, sep=' ')
  })
}

get_label <- function (dict_labels, label) {
  get_dict_value(dict_labels, label, label)
}

