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
	traindata = rbind( cbind(px, py), cbind(qx, qy) )
	trainlabel = sign (traindata[,1])
	
	set.seed(102)
	n = 333
	qx = rnorm(n, mean = -3, sd = 1) - 1
	qy = rnorm(n, mean = -3, sd = 1) - 1
	px = rnorm(n, mean = 3, sd = 1) + 1
	py = rnorm(n, mean = 3, sd = 1) + 1
	testdata = rbind( cbind(px, py), cbind(qx, qy) )
	testlabel = sign (testdata[,1])

	
	model = lasvmTrain (x = traindata, y = trainlabel, gamma = 1.0, cost = 1.0, epochs = 33, epsilon = 0.2, verbose = TRUE)
	predictions = lasvmPredict (testdata, model, verbose = TRUE)
	print (predictions)
	
stop()


library(testthat)
test()
