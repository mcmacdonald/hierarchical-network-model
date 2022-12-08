


# calculate the slope that detects the level of hierarchy inside social networks



# function to import data ------------------------------------------------------
import = function(file){
  data = utils::read.csv(
    file   = file, 
    header = FALSE, 
    stringsAsFactors = FALSE, 
    fileEncoding = "UTF-8-BOM"
  ); 
  data = data[-1, -1] # drop first row, column (i.e, vertex labels)
  return(data)
}
# import drug trafficking networks
d_caviar   = import(file = "https://raw.githubusercontent.com/mcmacdonald/criminal-networks/master/data/CAVIAR_FULL.csv") # caviar drug trafficking network - Morselli
d_cocaine  = import(file = "https://raw.githubusercontent.com/mcmacdonald/criminal-networks/master/data/COCAINE_DEALING.csv") # NY cocaine trafficking network - Natarajan
d_heroin   = import(file = "https://raw.githubusercontent.com/mcmacdonald/criminal-networks/master/data/HEROIN_DEALING.csv") # NY heroin trafficking network - Natarajan
d_cielnet  = import(file = "https://raw.githubusercontent.com/mcmacdonald/criminal-networks/master/data/CIELNET.csv") # CielNet (Montreal drug runner) network - Morselli



# symmetrize the network data --------------------------------------------------

# Function has three steps:
# 1. transform matrices into graphs
# 2. get binary graphs, or graphs with no edge weights
# 3. transform into symmetric edgelist
symmetrize = function(mat){
  mat[is.na(mat)] <- 0 # set missing cells = 0 i.e., no tie (in case of missings)
  mat = as.matrix(mat) # coerce to matrix
  mat = igraph::graph_from_adjacency_matrix( # adj matrix
    adjmatrix = mat,
    mode = "undirected", 
    weighted = NULL, 
    diag = FALSE
    )
  mat = igraph::simplify( # into binary network
    graph = mat, 
    remove.loops = TRUE, 
    remove.multiple = TRUE
    )
  mat = igraph::as_edgelist( # into edgelist
    graph = mat, 
    names = TRUE
    )
  mat = as.data.frame( # back to dataframe
    x = mat, 
    stringsAsFactors = FALSE
    ) 
  mat = dplyr::rename( # rename columns
    mat, 
    i = V1, 
    j = V2
    )
  mat = igraph::graph_from_data_frame( # return graph object
    d = mat, 
    directed = FALSE
    )
  # close function
}
# symmetrize graphs 
d_caviar   = symmetrize(mat = d_caviar)
d_cocaine  = symmetrize(mat = d_cocaine)
d_heroin   = symmetrize(mat = d_heroin)
d_cielnet  = symmetrize(mat = d_cielnet)



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
  b <- lm(log(c) ~ log(d), data = x)
  m <- coefficients(b)[[2]] # slope
  m <- round(m, digits = 2) # round
  cat("slope: "); cat(m); cat("\n")
  p <- summary(b)$coefficients[2,4] # p-value
  cat("p-val: "); cat(p); cat("\n")
  
  # calculate the standard error
  # I use Gabaix & Ibragimov's method: https://scholar.google.ca/citations?view_op=view_citation&hl=en&user=aCSds20AAAAJ&citation_for_view=aCSds20AAAAJ:UebtZRa9Y70C
  b <- coefficients(b)[[2]] # slope
  n <- igraph::ecount(g)    # dyads
  q <- abs(b) * sqrt(2/n)   # error
  
  # probable range of the slope
  hi <- b + (q * 1.96); hi <- round(hi, digits = 2)
  lo <- b - (q * 1.96); lo <- round(lo, digits = 2)
  cat("range: "); cat("["); cat(hi); cat(", "); cat(lo); cat("]")
  cat("\n"); cat("\n")
}
Ck(d_caviar)
Ck(d_cielnet)
Ck(d_cocaine)
Ck(d_heroin)





