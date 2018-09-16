# K-Means clustering

# data cleaning, K-Means cannot run if has NA, NaN, Inf
load('master_tran.Rda') # transposed, row = tik, col = date, K-Means cluster by rows
# kmeans(master.tran, 10) # try if it can run

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
master.kmready <- master.tran
save(master.kmready, file = 'master_kmready.Rda')
# Run it once =============================================================

# load cleaned data from last time
load('master_kmready.Rda')

# K-Means loop
library(ClusterR)

start_time <- Sys.time()

num.initial <- 1 # 20
num.randruns <- 10 # 100 times, 100 results
num.cluster <- 10 # 10 num.indus

km.df <- NULL
kmlist <- c()
timelist <- c()
km.cluster.bulk <- NULL
km.center.bulk <- NULL
for (i in 1:num.randruns){
  km <- KMeans_rcpp(master.kmready, num.cluster, num_init = num.initial, seed=i, initializer = 'kmeans++')
  km.cluster.bulk <- cbind(km.cluster.bulk, km$clusters)
  km.cluster.bulk <- data.frame(km.cluster.bulk)
  km.center.bulk <- cbind(km.center.bulk, km$centroids)
  km.center.bulk <- data.frame(km.center.bulk)
  
  func.name <- paste('km.result', i, sep='.')
  assign(func.name, km)
  kmlist <- c(kmlist, func.name)
  end_time <- Sys.time()
  timelist <- c(timelist, (end_time - start_time)[[1]]) # timing in seconds
}
# save all result summaries into one Rda file
save(timelist,list = kmlist, file = paste('kmean_results_',num.randruns,'runs_fullsummary.Rda',sep=''))

# only save cluster results and centers
save(timelist, km.cluster.bulk, km.center.bulk, file = paste('kmean_results_',num.randruns,'runs.Rda',sep=''))

# reloading
# load('kmean_results_2runs.Rda')
# load(paste('kmean_results_',num.randruns,'runs.Rda',sep=''))




