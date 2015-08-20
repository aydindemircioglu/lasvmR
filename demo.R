#!/usr/bin/Rscript

set.seed(9)

library(devtools)
load_all(".")




	# generate 2 clusters
	set.seed(101)
	qx = rnorm(100, mean = -3, sd = 1) - 1
	qy = rnorm(100, mean = -3, sd = 1) - 1
	px = rnorm(100, mean = 3, sd = 1) + 1
	py = rnorm(100, mean = 3, sd = 1) + 1
	data = rbind( cbind(px, py), cbind(qx, qy) )
# 	lasvmR::lasvmTrain (x = data, y = data, gamma = 2, cost = 3, degree = 4,
# 	coef0 = 0, optimizer = 0, kernel = 0, selection = 1, termination = 1, cachesize = 512,
# 	bias = 0, epochs = 33, epsilon = 0.2, verbose = TRUE)
	label = sign (data[,1])
	lasvmR::lasvmTrain (x = data, y = label, gamma = 1.0, cost = 1.0, epochs = 33, epsilon = 0.2, verbose = TRUE)

stop()


library(testthat)
test()
