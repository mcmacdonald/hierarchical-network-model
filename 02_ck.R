# ---------------------------------------------------------------------------------------

# file 02: calculate the slope that detects the level of hierarchy inside social networks

# ---------------------------------------------------------------------------------------

# calculate the slope that summarizes hierarchy --------------------------------
# i.e., regress (log) average cliquishness on (log) degree distribution
# outputs: 1) slope; 2) p-value of the slope; 3) probable range of the slope
Ck <- function(g){
  # calculate the graph-theoretic properties
  require(igraph)
  d <- igraph::degree(g, mode = "total", loops = FALSE, normalized = FALSE) # degree centrality
  c <- igraph::transitivity(g, type = "localundirected", isolates = "zero") # clustering coefficient
  x <- data.frame(d, c) # into dataframe
  
  # calculate the average clustering coefficient by degree k
  require(dplyr); require(magrittr)
  `%>%` <- magrittr::`%>%`
  x <- x %>% dplyr::group_by(d) %>% dplyr::summarise(c = mean(c)) # average the clustering coefficient by degree
  x$d <- sort(x$d)              # sort by degree
  x <- dplyr::filter(x, d != 1) # drop degree = 1 because clustering = 0 by default 
  
  # interpretation
  cat("... slopes < -0.75 indicative to hierarchy; slopes < -1.00 provide stronger evidence."); cat("\n")
  
  # estimate the slope
  m <- lm(log(c) ~ log(d), data = x)
  b <- coefficients(m)[[2]] # slope
  cat("slope: "); cat(round(b, digits = 2)); cat("\n")
  p <- summary(m)$coefficients[2,4] # p-value
  cat("p-val: "); cat(p); cat("\n")
  
  # calculate the standard error
  # I use Gabaix & Ibragimov's method: https://scholar.google.ca/citations?view_op=view_citation&hl=en&user=aCSds20AAAAJ&citation_for_view=aCSds20AAAAJ:UebtZRa9Y70C
  n <- igraph::ecount(g)    # dyads
  q <- abs(b) * sqrt(2/n)   # error
  
  # probable range of the slope
  hi <- b + (q * 1.96); hi <- round(hi, digits = 2)
  lo <- b - (q * 1.96); lo <- round(lo, digits = 2)
  cat("range: "); cat("["); cat(hi); cat(", "); cat(lo); cat("]")
  cat("\n"); cat("\n")
  
  # plot the slope
  b = coef(m)
  line  = function(x) exp(b[[1]] + b[[2]] * log(x))
  alpha = -b[[2]]
  R2    = summary(m)$r.squared
  print(paste("Alpha =", round(x = alpha, digits = 3) 
              ) 
        )
  print(paste("R2 =", round(x = R2, digits = 3)
              )
        )
  k1 <- 1 # min degree
  kn <- max(d) # max degree
  options(scipen = 999) # turn off scientific notation in Y-axis
  plot(x$c ~ x$d, 
       log = "xy",
       xlim = c(k1, kn), # x-axis scale 
       ylim = c(0.01, 1.10), # y-axis scale
       xlab = "degree k (log)", 
       ylab = "average clustering coefficient for degree k (log)", 
       main = "SCALING IN HIERARCHICAL NETWORKS",
       pch = 1, 
       cex = 2)
  curve(line, 
        col = "black", 
        lwd = 2, 
        add = TRUE, 
        n = length(d)
        )
}
Ck(caviar)
Ck(heroin)

# close .r script
