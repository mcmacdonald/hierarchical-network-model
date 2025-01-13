#  -----------------------------------------------------------------------------------

# file 01: import and manipulate data used to calculate the hierarchical network model
# note: you must run this file before you run file named '02_ck.R'

# ------------------------------------------------------------------------------------

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
siren    = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/dataCAVIAR_FULL.csv") # siren auto theft
togo     = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/TOGO.csv") # togo auto theft
caviar   = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/CAVIAR_FULL.csv") # caviar drug trafficking network - Morselli
cocaine  = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/COCAINE_DEALING.csv") # NY cocaine trafficking network - Natarajan
heroin   = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/HEROIN_DEALING.csv") # NY heroin trafficking network - Natarajan
cielnet  = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/CIELNET.csv") # CielNet (Montreal drug runner) network - Morselli
italian  = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/ITALIAN_GANGS.csv") # Italian gangs
london   = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/LONDON_GANG.csv") # London gangs
montreal = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/MONTREALGANG.csv") # Montreal gangs
infinito = import(file = "https://github.com/mcmacdonald/criminal-networks/tree/master/data/NDRANGHETAMAFIA_2M.csv") # Ndrangheta meeting participation i.e., Operation Infinito

# transpose the infinto meeting network from bipartite into unipartite graph
infinito = igraph::graph.incidence(
  incidence = infinito, # groups i.e., meeting attendance
  directed = FALSE,
  mode = "total",
  weighted = NULL
  )

# bipariate projection of the incidence/event two-mode network
infinito = igraph::bipartite.projection(graph = infinito)
infinito = m_infinito$proj1 # keep the unipartite projection
infinito = igraph::get.adjacency( # convert graph to adj matrix
  graph = infinito,
  type = "both"
  ) 
infinito = as.matrix(infinito)     # into matrix format
infinito = as.data.frame(infinito) # into data frame format



# symmetrize the network data --------------------------------------------------

# function has three steps:
# 1. transform matrices into adjacency matrix
# 2. transform into binary adjacency matrix, or adj matrix with no edge weights
# 3. transform into symmetric edgelist
symmetrize = function(mat){

  # required packages
  require("igraph")
  
  # matrix manipulation
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
siren    = symmetrize(siren)
togo     = symmetrize(togo)
caviar   = symmetrize(caviar)
cocaine  = symmetrize(cocaine)
heroin   = symmetrize(heroin)
cielnet  = symmetrize(cielnet)
italian  = symmetrize(italian)
london   = symmetrize(london)
montreal = symmetrize(montreal)
infinito = symmetrize(infinito)

# ... close .R script
