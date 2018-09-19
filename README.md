# MSDS-ML
## Stock ML Projects
Prepare 10 industries x 50 stocks with 10 years of stock data (check IPOs), which both are ranked by the Market Cap from high to low:
- Industry & ticker lists are scraped from [Finviz.com](https://www.finviz.com) 
- Daily stock data is from [Yahoo Finance](https://finance.yahoo.com/) 

### Follow the code file indexes (*\*note: always date the files since stock list may change daily*):
- 0_ind_g_gener.py:
  - scraps industry names by URLs (or hand pick), then generates **"ind_g.csv"** (*"G1, G2..."* assigned to each industry names).

- 1_tik_scraper_ind.py:
  - automatically scraps stock tickers page by page, then generates **"tik500.csv"** (500 tickers saved in one column).

- data preparation:
  - **"master.Rda"** (2266 x 4000) file is created by combining stock data from each CSV files (standardized close price, (1 + 3) shifts for each, with inversed data (500 x 4 x 2 = 4000 columns, *"AIG, AIG.s1, AIG.s5, AIG.s30..."*, and 2266 rows for all dates from 2009 to 2017).

- 4_ind_g_centerer.R:
  - reorders *shift* columns of *"master"* data by groups, transpose rows & columns (we want rows => tickers, since *K-Means* in R clusters by row), and generates **"master_tran.Rda"** and **"ind_center.Rda"** (10 *industries* x 4 *shifts* x 2 *inverses* = 80 centers by taking means of the groups in *master.tran*, dim = 80 x 2266).

- 5_kmeans_cluster.R:
  - cleans NAs, NaNs and Infs by 0 in *master.tran* (zero mean of standardized data, and K-Means cannot run if data has NA, NaN or Inf), and generates **"master_kmready.Rda"** & **"master_tik4000_g.csv"** (a list of 4000 tickers with assigned group numbers).
  - loops multiple runs of K-Means (package [*"ClusterR"*](https://cran.r-project.org/web/packages/ClusterR/ClusterR.pdf) has *"K-Means++"* initializer) and records computing time for each run. 100 result summaries are saved in **"kmean_results_100runs_fullsummary.Rda"**, and 100 cluster results & center results are saved in **"kmean_results_100runs.Rda"**.
  
  

