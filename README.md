# MSDS-ML
## ML HW Projects
Scraping 10 industries x 50 stocks, ranked by Market Cap from the top:
- Industry & ticker list from [Finviz.com](https://www.finviz.com) 
- Stock data from [Yahoo Finance](https://finance.yahoo.com/) 
### Follow the code file indexes: (Note: always date the files, stock list may change daily)
- 0_ind_g_gener.py:
  - generates **'ind_g.csv'**
- 1_tik_scraper_ind.py:
  - scraps & generates **'tik500.csv'**
- 4_ind_g_centerer.R:
  - generates **'ind_center.Rda'**, which is the industry centers using 9 years master.Rda, dim = 80 x 2266
