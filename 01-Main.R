# Wrapping: main wrapper script
# QDT 2015 April 09
# Tim Szewczyk

# This script sets the parameters and runs the simulation function.

##########
## set up workspace
##########

	setwd("~/Desktop/QDT_wrap/")
	source("02-FnSim.R")
	source("03-FnAux.R")
	set.seed(172)  # for maximum reproducibility


##########
## storage switches
##########

	storeSims <- TRUE	# write abundances, lambdas, parameters to files

##########
## set parameters
##########

	###--- main parameters
	parList <- list(N0=100,		# initial population size
                  K=100,		# carrying capacity
                  r=0.75,		# average log(proportional growth rate)
                  s2=0.5,		# variance in log(proportional growth rate)
                  Ne=0.5,		# quasi-extinction threshold
                  sims=1000,	# number of simulations
                  maxt=100)	# maximum time
					
	
	###--- meta-parameters
	param <- "r"	# parameter to vary
	low <- 0.01		# low value for parameter range
	high <- 2		# high value for parameter range
	parLen <- 6		# number of values for varied parameter
	logSeq <- FALSE	# make parameter values distributed along a log scale
	
	
##########
## run simulation
##########
	
	# make a parameter sequence to vary across simulation sets
	parSeq <- makeParSeq(param=param, low=low, high=high,
                       len=parLen, logSeq=logSeq)

	# simulation loop
	for(p in 1:parLen) {
		
		# update varied parameter
		parList[names(parList)==param] <- parSeq[p]
		
		# simulate
		sim.out <- popSim(parList)
		
		# write data to files
		if(storeSims) {
			writeOutputAndPars(sim.out=sim.out,
                         param=param,
                         parList=parList,
                         dirNum=p)
		} 
    
    # progress
		cat("Finished parameter set", p, "of", parLen, "\n")
	}
	