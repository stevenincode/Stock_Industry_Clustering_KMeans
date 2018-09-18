# More data visualization 
# Heat Map

load('master_kmready.Rda')
load('kmean_results_100runs.Rda')
load('kmean_results_100runs_fullsummary.Rda')
load('km_cost_rank_plot.Rda')
master.tik.g <- read.csv('master_tik4000_g.csv')
tiknames <- as.character(master.tik.g$tik)

num.randruns <- 5 # 100 times, 100 results
num.cluster <- 10 # 10 num.indus

cluster.mat <- NULL # "cluster.mat" is all km cluster results in one matrix

for (i in 1:num.randruns){
  cluster.mat <- cbind(cluster.mat, as.numeric(get(kmlist[i])$clusters))
}
rownames(cluster.mat) <- tiknames
colnames(cluster.mat) <- c(1:num.randruns)

# total distinct pairs of comparsion between two cluster results, n choose 2, n = 100 runs
choose(100,2)
choose(num.randruns,2)

hmap.list <- c()
h <- 0

for (k in 1:(num.randruns-1)){
  
  for (g in (k+1):num.randruns){ # 1 vs 2, 1 vs 3, 1 vs 4...
    
    join1 <- NULL 
    
    for (j in 1:num.cluster){
      row1 <- c()
      a1 <- NULL
      a1 <- cbind(a1, rownames(cluster.mat)[cluster.mat[,k]==j])
      
      for (i in 1:num.cluster){
        b1 <- NULL
        b1 <- cbind(b1, rownames(cluster.mat)[cluster.mat[,g]==i])
        row1 <- c(row1, length(merge(a1, b1)[,1])) # inner join by the only col (tiks)
      }
      join1 <- rbind(join1, row1)
    }
    h <- h + 1
    rownames(join1) <- c(1:num.cluster)
    join1 <- data.frame(join1)
    varname <- paste('hmap.join.', h, sep='')
    assign(varname, join1)
    hmap.list <- c(hmap.list, varname)
  }
}

# heat maps
heatmap(as.matrix(get(hmap.list[1])))

# saving graphs as .png, can change to .jpg
for (i in 1:length(hmap.list)){
  #jpeg(paste('heatmap', i, '.png', sep=''))
  heatmap(as.matrix(get(hmap.list[i])), main = i)
  #dev.off()
} 
# [X1, X2...] are the next km run result




# need to reorder and group the heat map to each km runs, each has n run - 1 heat maps.


# huge heat map for 4000 tiks
cc <- rainbow(10) # ncol(cluster.mat)
# plot head map for 100 runs
# image(cluster.mat, xlab = 'Matrix rows', ylab = 'Matrix columns', axes = F, col = cc)












