#  --------------------------------------------------------------------------

# import and manipulate data used to calculate the hierarchical network model
# note: you must run this file before you run file named '02_Ck.R'

# ---------------------------------------------------------------------------

# function to import data ------------------------------------------------------
import = function(file){

  #  required packages
  require("utils"); require("readr")
  
  # read.csv
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
caviar = import(file = "https://raw.githubusercontent.com/mcmacdonald/criminal-networks/master/data/CAVIAR_FULL.csv") # caviar drug trafficking network - Morselli
heroin = import(file = "https://raw.githubusercontent.com/mcmacdonald/criminal-networks/master/data/HEROIN_DEALING.csv") # NY heroin trafficking network - Natarajan



# symmetrize the network data --------------------------------------------------

# function has three steps:
# 1. transform matrices into adjacency matrix
# 2. transform into binary adjacency matrix, or adj matrix with no edge weights
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
  mat = igraph::simplify( # into binary adj mat
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
}

# symmetrize
caviar   = symmetrize(caviar)
heroin   = symmetrize(heroin)

# ... close .R script
