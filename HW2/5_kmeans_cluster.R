# K-Means clustering

# data cleaning, K-Means cannot run if has NA, NaN, Inf
load('master_tran.Rda') # transposed, row = tik, col = date, K-Means cluster by rows
# kmeans(master.tran, 10) # try if it can run
load('ind_center.Rda')

# checking NA in data
which(is.na(master.tran[,1]))
# or
a <- 0
for (j in 1:ncol(master.tran)){
  if (sum(is.na(master.tran[,j]))>0){
    print(a)
    a=a+1
  }
}

# create a list of 4000 tiks with group nums
master.tik.g <- NULL
master.tik.g$tik <- rownames(master.tran)
master.tik.g$g.num <- rep(rownames(ind.center), each=50)
master.tik.g <- data.frame(master.tik.g)
write.csv(master.tik.g, file='master_tik4000_g.csv', row.names = F)
# run it once ===========================================================
master.tik.g <- read.csv('master_tik4000_g.csv')

# replace NA with mean in its group, 1 day
"for (j in 1:ncol(master.tran)){
  if (sum(is.na(master.tran[,j]))>0){
    for (i in 1:nrow(master.tran)){ # 3600:4000 rows
    #for (i in 3600:4000){
      if (is.na(master.tran[i,j])==T){
        g.num <- master.tik.g$g.num[master.tik.g$tik==rownames(master.tran)[i]]
        master.tran[i,j] <- ind.center[g.num,j]
      }
    }
  }
}"

# replace NA with mean of the whole col (all tik)
for(i in 1:ncol(master.tran)){
  master.tran[is.na(master.tran[,i]), i] <- 0 # mean of standardized data is all 0
}

# replace NA with mean # **Need Fix, should be by row, by tik
#for(i in 1:ncol(master.tran)){
#  master.tran[is.na(master.tran[,i]), i] <- mean(master.tran[,i], na.rm = TRUE) # mean of standardized data is all 0
#}

# replace NAN with mean 
#for(i in 1:ncol(master.tran)){
#  master.tran[is.nan(master.tran[,i]), i] <- mean(master.tran[,i], na.rm = TRUE)
#}

# replace Inf with mean
#for(i in 1:ncol(master.tran)){
#  master.tran[is.infinite(master.tran[,i]), i] <- mean(master.tran[,i], na.rm = TRUE)
#}

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
num.randruns <- 30 # 100 times, 100 results
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

# renaming row & col names
for (i in 1:dim(km.cluster.bulk)[2]){
  colnames(km.cluster.bulk)[i] <- paste('km.clusters.', i, sep='')
}

for (i in 1:dim(km.cluster.bulk)[1]){
  rownames(km.cluster.bulk)[i] <- rownames(master.kmready)[i]
}

for (i in 1:num.cluster){
  rownames(km.center.bulk)[i] <- paste('H', i, sep='')
}

#km.center.bulk[,1:2]
#km.cluster.bulk[1:5,1:5]
#km.cluster.bulk[3990:4000,1:5]

# save all result summaries into one Rda file
save(timelist,list = kmlist, file = paste('kmean_results_',num.randruns,'runs_fullsummary.Rda',sep=''))

# only save cluster results and centers
save(timelist, km.cluster.bulk, km.center.bulk, file = paste('kmean_results_',num.randruns,'runs.Rda',sep=''))

# reloading
# load('kmean_results_2runs.Rda')
# load(paste('kmean_results_',num.randruns,'runs.Rda',sep=''))




