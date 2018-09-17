# Result Evaluation for K-Means Runs

load('master_kmready.Rda')
load('kmean_results_100runs.Rda')
load('kmean_results_100runs_fullsummary.Rda')
num.randruns <- 100 # 100 times, 100 results

# if "kmlist" (list of "km.result.#") is not saved in Rda file, create it by this code:
kmlist <- c()
for (i in 1:num.randruns){
  kmlist <- c(kmlist, paste('km.result.', i, sep=''))
}
# run it once ==============================================

# Between.SS / Total.SS and COST values
cost.f.kmruns <- c()
ssdiv.total <- c() # $between.SS_DIV_total.SS
# The attribute between.SS_DIV_total.SS is equal to (total_SSE - sum(WCSS_per_cluster)) / total_SSE. 
# If there is no pattern of clustering then the between sum of squares will be a very small fraction 
# of the total sum of squares, whereas if the between.SS_DIV_total.SS attribute is close to 1.0 then 
# the observations cluster pretty well.

for (i in 1:num.randruns){
  result <- get(kmlist[i])
  cost.f.kmruns <- c(cost.f.kmruns, sum(result$WCSS_per_cluster / result$obs_per_cluster)) # wrong: na.rm = T
  ssdiv.total <- c(ssdiv.total, result$between.SS_DIV_total.SS)
}
# check NA, NaN
which(is.na(cost.f.kmruns))

# find which $between.SS_DIV_total.SS is closest to 1 (best clustering)
which.min((ssdiv.total-1)^2) # km run No.79 is the best
ssdiv.df <- data.frame(ssdiv.total)
rownames(ssdiv.df)[order((ssdiv.total-1)^2)] # ranking by closest to 1
rownames(ssdiv.df)[order(ssdiv.df$ssdiv.total, decreasing = T)] # or by ranking from high since all < 1.

# find which km run has the min COST value (best clustering)
which(cost.f.kmruns == min(cost.f.kmruns, na.rm=T)) # km run No.14 is the best
cost.df <- data.frame(cost.f.kmruns)
rownames(cost.df)[order(cost.f.kmruns)] # ranking from min COST

# combined ranking by sum the orders
rankavg <- (order(order((ssdiv.total-1)^2)) + order(order(cost.f.kmruns)))/2
rownames(ssdiv.df)[order(rankavg)] # ranking from best, km run No.98 is the best

# visualize ranking
plot(cost.f.kmruns, xlab = 'K-Means Run No.', ylab = 'COST Value', main = 'COST = sum(result$WCSS_per_cluster / result$obs_per_cluster)')

plot(ssdiv.total, xlab = 'K-Means Run No.', ylab = 'Between.SS / Total.SS', main = 'Between Sum Sq / Total Sum Sq =\n 
     (total_SSE - sum(WCSS_per_cluster)) / total_SSE')

ssdiv.df$rank <- order(order((ssdiv.total-1)^2))
cost.df$rank <- order(order(cost.f.kmruns))
eval.avg <- ssdiv.df
colnames(eval.avg)[2] <- 'rank.ssdiv'
eval.avg$rank.cost <- cost.df$rank
eval.avg$rank <- order(order(rankavg))
eval.avg$ssdiv.total <- rankavg
colnames(eval.avg)[1] <- 'rankavg'

library(ggplot2)
library(tidyquant)

p <- ggplot(ssdiv.df, aes(ssdiv.df$rank, ssdiv.df$ssdiv.total, label = rownames(ssdiv.df)))
plot.ssdiv <- p + geom_point() + geom_text(size =2,  nudge_y = 0.0005) + 
  labs(x = 'Ranking from the Best K-Means Run', y = 'Between.SS / Total.SS', 
       title = 'Between Sum Sq / Total Sum Sq = (total_SSE - sum(WCSS_per_cluster)) / total_SSE')

plot.ssdiv

# replace NaNs with mean(na.rm = T), but ranking stays the same
cost.f.kmruns2 <- c()
for (i in 1:num.randruns){
  result <- get(kmlist[i])
  cost.f.kmruns2 <- c(cost.f.kmruns2, sum(result$WCSS_per_cluster / result$obs_per_cluster, na.rm = T)) 
}
cost.df$cost.f.kmruns <- cost.f.kmruns2

p2 <- ggplot(cost.df, aes(cost.df$rank, cost.df$cost.f.kmruns, label = rownames(cost.df)))
plot.cost <- p2 + geom_point() + geom_text(size =2,  nudge_y = 50) + 
  labs(x = 'Ranking from the Best K-Means Run', y = 'COST Value', title = 
         'COST = sum(result$WCSS_per_cluster / result$obs_per_cluster)') # check_overlap = TRUE

plot.cost

# plot rankavg
p3 <- ggplot(eval.avg, aes(eval.avg$rank, eval.avg$rankavg, label = rownames(eval.avg)))
p3.1 <- p3 + labs(x = 'Ranking from the Best K-Means Run', y = 'Ranks Average', 
                 title = 'High: Between.SS / Total.SS        Low: COST Value') + geom_point()


plot.rankavg <- p3.1 + geom_text(size =2,  nudge_y = 5)

plot.rankavg

# candlestick chart
plot.rankavg.candle <- p3.1 + geom_text(size =2,  nudge_y = 50) + 
  geom_candlestick(aes(open = eval.avg$rank.ssdiv, high = eval.avg$rank.ssdiv, 
                       low = eval.avg$rank.cost, close = eval.avg$rank.cost), 
                   fill_up = "darkgreen", fill_down = "red") +
  geom_line(aes(eval.avg$rank, eval.avg$rankavg), eval.avg)

plot.rankavg.candle

 

# saving data
save(eval.avg, ssdiv.df, cost.df, plot.ssdiv, plot.cost, 
     plot.rankavg, plot.rankavg.candle,file = 'km_cost_rank_plot.Rda')

# End...




" # Very slow way of calculating COST values
runit <- F
if (runit == T){
  num.randruns <- 100 # 100 times, 100 results
  num.cluster <- 10 # == 10 num.indus
  num.indus <- 10
  num.tik <- 50 # tik per indus
  
  timing.a <- Sys.time()
  
  colshift <- 1
  cost.f.kmruns <- NULL
  disper2.g.alldate <- 0
  
  for (km.run in 1:num.randruns){ # 100
    cost.f.alldate <- 0
    
    for (d.1 in colshift:(colshift+dim(master.kmready)[2]-1)){ # 2266 - 1, timed 11 sec x 2266 x 100
      disper2.sum <- 0
      
      for (g.num in 1:num.indus){ # 10
        dist2.sum <- 0
        g.tiks <- rownames(km.cluster.bulk)[km.cluster.bulk[ ,km.run] == g.num]
        
        for (tik.i in 1:length(g.tiks)){
          dprice <- master.kmready[, d.1][rownames(master.kmready)==g.tiks[tik.i]]
          dist2.sum <- dist2.sum + (dprice - km.center.bulk[g.num, d.1])^2 # g1, day1
        }
        disper2.sum <- disper2.sum + dist2.sum/length(g.tiks) # COST value of 1 day, 10 groups
      }
      cost.f.alldate <- cost.f.alldate + disper2.sum # 1 COST value for 1 km run
      print(Sys.time()-timing.a)
    }
    colshift <- colshift + dim(master.kmready)[2]
    cost.f.kmruns <- c(cost.f.kmruns, cost.f.alldate)
  }
  
  # try smaller number ============================================
  aa=Sys.time()
  
  colshift <- 1
  cost.f.kmruns <- NULL
  disper2.g.alldate <- 0
  
  for (km.run in 1:1){ # 100
    cost.f.alldate <- 0
    
    for (d.1 in 1:5){ # 2266 - 1
      disper2.sum <- 0
      
      for (g.num in 1:num.indus){ # 10
        dist2.sum <- 0
        g.tiks <- rownames(km.cluster.bulk)[km.cluster.bulk[ ,km.run] == g.num]
        
        for (tik.i in 1:length(g.tiks)){
          dprice <- master.kmready[, d.1][rownames(master.kmready)==g.tiks[tik.i]]
          dist2.sum <- dist2.sum + (dprice - km.center.bulk[g.num, d.1])^2 # g1, day1
        }
        disper2.sum <- disper2.sum + dist2.sum/length(g.tiks) # COST value of 1 day, 10 groups
      }
      cost.f.alldate <- cost.f.alldate + disper2.sum # 1 COST value for 1 km run
      print(Sys.time()-aa)
    }
    colshift <- colshift + dim(master.kmready)[2]
    cost.f.kmruns <- c(cost.f.kmruns, cost.f.alldate)
  }
  #==========================================================
}
"






