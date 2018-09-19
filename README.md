# MSDS-ML
## ML HW Projects
Scraping 10 industries x 50 stocks, ranked by Market Cap from the top:
- Industry & ticker lists are scraped from [Finviz.com](https://www.finviz.com) 
- Stock data is from [Yahoo Finance](https://finance.yahoo.com/) 
### Follow the code file indexes: (*Note: always date the files, stock list may change daily*)
- 0_ind_g_gener.py:
  - scraps industry names by URLs (or hand pick them), then generates **"ind_g.csv"** (*"G1, G2..."* assigned to each industry names).
- 1_tik_scraper_ind.py:
  - automatically scraps stock tickers page by page, then generates **"tik500.csv"** (500 tickers saved in one column).
- data preparation:
  - **"master.Rda"** (2266 x 4000) file is created by combining stock data of each CSV files (standardized close price, (1 + 3) shifts for each, with inversed data (500 x 4 x 2 = 4000 columns, *"AIG, AIG.s1, AIG.s5, AIG.s30..."*, and 2266 rows for all dates from 2009 to 2017).
- 4_ind_g_centerer.R:
  - reorders *shift* columns of *"master"* data by groups, transpose it (we want rows => tickers, since *K-Means* in R clusters by row), and generates **"master_tran.Rda"** and **"ind_center.Rda"** (10 *industry* x 4 *shift* x 2 *inverse* centers by taking the means of grouped *master.tran*, dim = 80 x 2266).
