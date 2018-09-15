# K-Means clustering

# data cleaning

# replace NA with mean
for(i in 1:ncol(master.tran)){
  master.tran[is.na(master.tran[,i]), i] <- mean(master.tran[,i], na.rm = TRUE)
}

# replace NAN with mean
for(i in 1:ncol(master.tran)){
  master.tran[is.nan(master.tran[,i]), i] <- mean(master.tran[,i], na.rm = TRUE)
}

# replace Inf with mean
for(i in 1:ncol(master.tran)){
  master.tran[is.infinite(master.tran[,i]), i] <- mean(master.tran[,i], na.rm = TRUE)
}

# save cleaned data
master.tran1 <- master.tran
save(master.tran1, file = 'master_tran1.Rda')
# Run it once =============================================================

# load cleaned data from last time
load('master_tran1.Rda')
ds1 <- master.tran1

# K-Means loop
library(ClusterR)
num.initial <- 1 # 20
num.randruns <- 2 # 100 times
num.cluster <- 10 # 10 num.indus

sink(paste('kmean_results_',num.randruns,'.txt',sep='')) # **need a better way to save it
km.df <- NULL
for (i in 1:num.randruns){
  km <- KMeans_rcpp(ds1, num.cluster, num_init = num.initial, seed=i, initializer = 'kmeans++')
  print(km)
}
sink()







