# Finding centers of each industry (after "master.Rda" is created)
working.directory <- "C:/"
setwd(working.directory)
getwd()

load('master.Rda')
#load('./Testing/2018-09-14/master.Rda')
#('./Testing/TRUEmaster.Rda')

#shifts = c(1,3,5,10,20,30,90)
shifts = c(1,5,30) # from before...

num.shifts <- length(shifts)
num.indus <- 10
num.tik <- 50 # tik per indus
ndate.master <- dim(master)[1] # 2266 days
ntik.master <- dim(master)[2] # 4000 = 50tik x 10ind x 4shift x 2inverse
#dim(master)[2] / tik.ncols

# regroup shift cols of master
# generate index for ordering
index <- c()
b <- 1
for (k in 1:(num.indus*2)){ # 1:20
  for (j in b:(b+num.shifts)){ # b + 7
    a <- j
    for (i in 1:num.tik){ # 50
      index <- c(index, a)
      a <- a + num.shifts + 1 # a + 8
    }
  }
  b <- b + (num.shifts+1)*num.tik # 400
}

master.reord <- master[,index]

master.reord[1,1:101]
tail(colnames(master.reord), 101)

# Take Transpose of reordered master
master.tran <- data.frame(t(master.reord))

master.tran[1:51, 1:2]

# calculating centers of industries
# index for mean calculation
index.r <- c()
a <- 1
# or use seq()
for (i in 1:(ntik.master / num.tik)){ # 80
  index.r <- c(index.r, a)
  a <- a + num.tik # 50
}

ind.center <- NULL
b <- 1
for (i in index.r){
  ind.center <- rbind(ind.center, apply(master.tran[i:(i+num.tik-1),], 2, mean, na.rm=T))
  ind.center <- data.frame(ind.center)
  # assign group names
  sub <- c(strsplit(rownames(master.tran)[i],'[.]')[[1]][2],
           strsplit(rownames(master.tran)[i],'[.]')[[1]][3])
  sub <- sub[!is.na(sub)]
  if (length(sub)==2){
    sub <- paste(sub[1], sub[2], sep = '.')
  }
  ind.center.name <- paste('G',toString(rep(rep(1:num.indus, each=num.shifts+1),2)[b]),sub,sep='.')
  if (rownames(ind.center)[b] != ind.center.name){
    rownames(ind.center)[b] <- ind.center.name
  }
  b <- b + 1
}
#ind.center[1:12,1:12]
#ind.center[59:80,1:2]
dim(ind.center) # 80 x 2266 days

save(ind.center, file = 'ind_center.Rda')













