# network-hierarchy

An .r script to calculate the slope that describes the level of hierarchy in social networks. 

For adjacency graphs, Ravasz & Barabási (2003) propose to measure the level of hierarchy by:

c(k) ~ k^y

where c(k) is the average clustering coefficient by degree k, k represents the elements throughout the degree distribution, and the exponent y is the slope that describes the level of hierarchy throughout the degree distribution. A negative slope indicates that the high degrees in the upper-tail of the degree distribution have less cohesive social circles in comparison to small degrees. A slope = -1 provides strong evidence of hierarchy. The steeper the slope, the greater the level of hierarcy. The original paper by Ravasz & Barabási (2003) describes the procedures in more detail.

This script imports different drug trafficking networks and symmetrizes them: 

  - Morselli's  (2009) "caviar" drug trafficking organization 
  - Morselli's  (2009) "cielnet" drug trafficking organization
  - Natarajan's (2000) cocaine trafficking
  - Nararajan's (2006) heroing trafficking

The original data is published by The Mitchell Centre for Social Network Analysis, University of Manchester (https://sites.google.com/site/ucinetsoftware/datasets/covert-networks)

CITATIONS: 

Morselli, C., 2009. Inside criminal networks. New York, NY: Springer.

Natarajan, M. 2000. Understanding the structure of a drug trafficking organization: a conversational analysis. Crime Prevention Studies, 11, 273-298.

Natarajan, M. 2006. Understanding the Structure of a Large Heroin Distribution Network: A Quantitative Analysis of Qualitative Data. Quantitative Journal of Criminology, 22(2), 171-192.

Ravasz, E., & Barabási, A. L. 2003. Hierarchical organization in complex networks. Physical review E, 67(2), 026112.
