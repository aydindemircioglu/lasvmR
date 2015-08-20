library(cluster)
library(devtools)
load_all("/home/drunkeneye/lab/frameworks/lasvmR")
load_all("/home/drunkeneye/lab/frameworks/SVMBridge")


data(iris)
dat <- iris[, -5] # without known classification 
# Kmeans clustre analysis
dat = as.matrix(dat)
clusAll = lasvmR::orthoKMeansTrain (x = dat, k = 3, 
                                    rounds = 4, verbose = FALSE)

#clus <- kmeans(dat, centers=3)
# Fig 01
for (i in 4:1) {
  
#  plotcluster(dat, clusAll$cluster[[1]])
  # More complex
  clusplot(dat, clusAll$cluster[[i]], color=TRUE, shade=TRUE, labels=2, lines=0)
  
 # with(iris, pairs(dat, col=c(1:3)[clusAll$cluster[[i]]])) 
}