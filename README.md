# network-hierarchy

An .r script to calculate the slope that describes the level of hierarchy in social networks. 

For adjacency graphs, Ravasz & Barabási (2003) propose to measure the level of hierarchy throughout the degree distribution by the equation:

c(k) ~ k<sup>Y</sup>

where c(*k*) is the average clustering coefficient by degree *k*, *k* represents the elements throughout the degree distribution, and the exponent Y is the slope that describes the level of hierarchy throughout the degree distribution. The ck() command in this .r script calculates the gradient of the slope and standard errors that provide the probable range of the slope. I use the procedures in Gabaix & Ibragimov (2011) to calculate the standard error of the slope [Clauset et al. (2009) explain why ordinary least squares does not accurately calculate the standard error of the power-law slope].

The script uses ordinary least squares to regress the logged average clustering coefficient by degree *k* on the logged degree distribution. The log-log regression implies that the gradient of the slope scales by *k*<sup>Y</sup> orders of magnitude. A negative slope indicates that the high degrees in the upper-tail of the degree distribution have less cohesive social circles in comparison to small degrees. The steeper the slope, the greater the level of hierarcy. A slope = -1 provides strong evidence of hierarchy.

I illustrate the procedures on different drug trafficking networks:

  - Morselli's  (2009) "caviar" drug trafficking organization 
  - Morselli's  (2009) "cielnet" drug trafficking organization
  - Natarajan's (2000) cocaine trafficking
  - Nararajan's (2006) heroing trafficking

The original data is published by The Mitchell Centre for Social Network Analysis, University of Manchester [https://sites.google.com/site/ucinetsoftware/datasets/covert-networks].

This script imports the numerous data sources and symmetrizes them prior to the calculation of slopes and standard error.



CITATIONS:

Clauset, A., Shalizi, C. R., & Newman, M. E. 2009. Power-law distributions in empirical data. SIAM review, 51(4), 661-703.

Gabaix, X., & Ibragimov, R. 2011. Rank− 1/2: a simple way to improve the OLS estimation of tail exponents. Journal of Business & Economic Statistics, 29(1), 24-39.

Morselli, C., 2009. Inside criminal networks. New York, NY: Springer.

Natarajan, M. 2000. Understanding the structure of a drug trafficking organization: A conversational analysis. Crime Prevention Studies, 11, 273-298.

Natarajan, M. 2006. Understanding the Structure of a Large Heroin Distribution Network: A Quantitative Analysis of Qualitative Data. Quantitative Journal of Criminology, 22(2), 171-192.

Ravasz, E., & Barabási, A. L. 2003. Hierarchical organization in complex networks. Physical review E, 67(2), 026112.
