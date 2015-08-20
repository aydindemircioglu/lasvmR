#!/usr/bin/Rscript

set.seed(42)

library(devtools)
load_all(".")

library(SVMBridge)
	
	# take 0815 iris set
	d = iris[sample(nrow(iris)),]
	x = as.matrix(d[,1:4])
	y = as.matrix(as.numeric(d[,5]))
	y[y==3] = 1
	y[y==2] = -1

	for (i in 1:128) {
		cat (".")
		s = sample(nrow(iris))
		p = round(runif(1)*(nrow(iris)-10))+5
		trIdx = s[1:p]
		testIdx = s[p+1:nrow(iris)]

#		writeSparseData (paste("DATA", i, ".sp", sep = ""), X = as.matrix(x[trIdx,]), Y = as.matrix(y[trIdx]))
		model = lasvmTrain (x[trIdx,], y[trIdx,], degree = runif(1)*10000, coef0 = runif(1)*10000, gamma = runif(1)*10000, cost = runif(1)*10000, epochs = round(runif(1)*100), optimizer = round(runif(1)), kernel = round(runif(1)*3), selection = round(runif(1)*2), verbose = FALSE)
		predictions = lasvmPredict (x[testIdx,], model, verbose = FALSE)
	}
stop("R")		
	# test the same for polynomial kernel
	model = lasvmTrain (x[1:100,], y[1:100], degree = 4, coef0 = 3, cost = 2, epochs = 1, optimizer = 1, kernel = 3, selection = 1, verbose = FALSE)
	predictions = lasvmPredict (x[101:150,], model, verbose = FALSE)

	model = lasvmTrain (x[1:100,], y[1:100], degree = 4, coef0 = 3, cost = 2, epochs = 1, optimizer = 1, kernel = 3, selection = 1, verbose = FALSE)
	predictions = lasvmPredict (x[101:150,], model, verbose = FALSE)

	

	

library(testthat)
test()
stop()

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
	


