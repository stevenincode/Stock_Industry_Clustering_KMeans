# Stock Ticker Scraping by 'ind_g.csv', 9-11-2018
import os
os.chdir(r'C:\')
os.getcwd()

import pandas as pd
from urllib.request import urlopen as uReq # it grabs the page
from bs4 import BeautifulSoup as soup # it parses the HTML text
import time

ind_g = pd.read_csv('ind_g.csv', index_col=0)
#ind_g['ind_ls']['G1']
num_indus = len(ind_g)

filedate = '_' + time.strftime("%m_%d_%Y", time.localtime())

aloop = False
bloop = False

while True:
    ans = input('Q1. Number of INDUSTRIES to scrap (' + str(num_indus) + ' available, a for all, q to quit): ' )
    if ans == 'q':
        break
    elif ans == 'a':
        aloop = True
        break
    else:
        try:
            type(int(ans))=='int'
            if num_indus >= int(ans):
                num_indus = int(ans)
                aloop = True
                break
            else:
                print('***Invalid Input***')
                continue
        except:
            print('***Invalid Input***')
            continue

while aloop == True:
    ans = input('Q2. Number of TICKERS to scrap per industry (q to quit): ' )
    if ans == 'q':
        break
    else:
        try:
            type(int(ans))=='int'
            num_tik = int(ans)
            print('[Scraping total of ' + str(num_indus * num_tik) + ' stock tickers]')
            bloop = True
            break
        except:
            print('***Invalid Input***')
            continue
#num_indus = 2 # input by hand
#num_tik = 50 # assign num of tik per industry
filename = 'tik' + str(num_indus * num_tik) + filedate + '.csv'

while bloop == True:
    ans = input('Q3. Start scraping now? (y/n, q to quit): ' )
    if ans == 'q' or ans == 'n':
        break
    elif ans == 'y':
        tik500={}
        tik500dict={}
        #tik500str={}
        
        for i in range(0, num_indus): # 0-10 for G1-10, we need 10 indus x 50 tiks = 500 tiks
            ind_g_lower = ind_g['ind_ls'][i].lower().replace(" ", "").replace("-", "").replace("/", "").replace("&", "").replace(",", "")
            tiklist=[]
            tikstr=''
           
            pagerun20 = num_tik // 20
            numleft = num_tik - 20 * pagerun20
            webindex = 1
                
            for k in range(0, pagerun20):
                my_url = 'https://finviz.com/screener.ashx?v=111&f=ind_' + ind_g_lower + ',ipodate_more10&o=-marketcap&r=' + str(webindex)
                      
                uClient = uReq(my_url)
                page_html = uClient.read()
                uClient.close()
            
                page_soup = soup(page_html, 'html.parser')
                
                #tikstr = tikstr + page_soup.findAll('a', class_="screener-link-primary")[j].text.strip() + ', '
                for j in range(0, 20): # (0, 20) is 1-20
                    tiklist.append(page_soup.findAll('a', class_="screener-link-primary")[j].text.strip())
                    
                webindex = webindex + 20
                
            my_url = 'https://finviz.com/screener.ashx?v=111&f=ind_' + ind_g_lower + ',ipodate_more10&o=-marketcap&r=' + str(webindex)
                    
            uClient = uReq(my_url)
            page_html = uClient.read()
            uClient.close()
                    
            page_soup = soup(page_html, 'html.parser')   
            for j in range(0, numleft):
                tiklist.append(page_soup.findAll('a', class_="screener-link-primary")[j].text.strip())
                #tikstr = tikstr + page_soup.findAll('a', class_="screener-link-primary")[j].text.strip() + ', '
            print(ind_g.index[i], len(tiklist))
            tik500[i] = tiklist
            tik500dict[ind_g.index[i]] = tiklist
            #tik500str[sec_g.index[i]] = tikstr
                     
        tik500df = pd.DataFrame(tik500) # df grouped by index
        tik500dict_df = pd.DataFrame(tik500dict) # df grouped by group num
        #tik500df.to_csv('tik500index.csv', index=False)
        #tik500dict_df.to_csv('tik500dict.csv', index=False)
        
        # combine into one col.
        all_tik500=[]
        for i in tik500df.keys():
            all_tik500 = all_tik500 + tik500[i]
        all_tik500df = pd.DataFrame(all_tik500)
        all_tik500df.to_csv(filename, index=False, header=False)
        print('*Work Done*')
        break
    else:
        print('***Invalid Input***')
        continue





