# Stock Sector ML, 9-6-2018
#import os
#os.chdir(r'C:\...')
#os.getcwd()

import pandas as pd
from urllib.request import urlopen as uReq # it grabs the page
from bs4 import BeautifulSoup as soup # it parses the HTML text

# top 20 Industry list by marketcap
induslist=[]

my_url = 'https://finviz.com/groups.ashx?g=industry&v=110&o=-marketcap'
                    
uClient = uReq(my_url)
page_html = uClient.read()
uClient.close()
    
page_soup = soup(page_html, 'html.parser')
for j in range(0, 20):
    induslist.append(page_soup.findAll('a', class_="tab-link")[j].text.strip())

g_num = []
for i in range(1, 21):
    g_num.append('G' + str(i))
    
ind_g = pd.DataFrame(induslist)
ind_g.index = g_num
ind_g.columns = ['ind_ls']

ind_g.to_csv('ind_g.csv', index=True)
'''Only Need to Write ind_g.csv Once =============================================================='''

ind_g = pd.read_csv('ind_g.csv', index_col=0)
#ind_g['ind_ls']['G1']

tik240={}
tik240dict={}
#tik500str={}
for i in range(0, 20): # 0-20 for G1-20, we need 20 indus x 12 tiks = 240 tiks
    ind_g_lower = ind_g['ind_ls'][i].lower().replace(" ", "").replace("-", "").replace("/", "").replace("&", "").replace(",", "")
    tiklist=[]
    tikstr=''
    my_url = 'https://finviz.com/screener.ashx?v=111&f=ind_' + ind_g_lower + '&o=-marketcap'
              
    uClient = uReq(my_url)
    page_html = uClient.read()
    uClient.close()
    
    page_soup = soup(page_html, 'html.parser')
    for j in range(0, 12): # (0, 12) is 1-12
        tiklist.append(page_soup.findAll('a', class_="screener-link-primary")[j].text.strip())
        #tikstr = tikstr + page_soup.findAll('a', class_="screener-link-primary")[j].text.strip() + ', '
    ''' # for next pages
    my_url = 'https://finviz.com/screener.ashx?v=111&f=ind_' + ind_g_lower + '&o=-marketcap&r=21'
    
    uClient = uReq(my_url)
    page_html = uClient.read()
    uClient.close()
    
    page_soup = soup(page_html, 'html.parser')
    for j in range(0, 20):
        tiklist.append(page_soup.findAll('a', class_="screener-link-primary")[j].text.strip())
        #tikstr = tikstr + page_soup.findAll('a', class_="screener-link-primary")[j].text.strip() + ', '
    my_url = 'https://finviz.com/screener.ashx?v=111&f=ind_' + ind_g_lower + '&o=-marketcap&r=41'
    
    uClient = uReq(my_url)
    page_html = uClient.read()
    uClient.close()
    
    page_soup = soup(page_html, 'html.parser')
    for j in range(0, 10):
        tiklist.append(page_soup.findAll('a', class_="screener-link-primary")[j].text.strip())
        #tikstr = tikstr + page_soup.findAll('a', class_="screener-link-primary")[j].text.strip() + ', '
    '''
    print(ind_g.index[i], len(tiklist))
    tik240[i] = tiklist
    tik240dict[ind_g.index[i]] = tiklist
    #tik500str[sec_g.index[i]] = tikstr
             
tik240df = pd.DataFrame(tik240) # df grouped by index
tik240dict_df = pd.DataFrame(tik240dict) # df grouped by group num
#tik240df.to_csv('tik240index.csv', index=False)
#tik240dict_df.to_csv('tik240dict.csv', index=False)

# combine into one col.
all_tik240=[]
for i in tik240df.keys():
    all_tik240 = all_tik240 + tik240[i]
all_tik240df = pd.DataFrame(all_tik240)
all_tik240df.to_csv('tik240.csv', index=False, header=False)

'''
import csv

g_num = sec_g.index
tik500str2 = tik500str

for i in g_num:
    tik500str2[i]=tik500str[i].replace(',', '\n')

with open('tik500.csv', 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=tik500str.keys())
    w.writeheader()
    w.writerow(tik500str2)

with open('tik500.csv', 'w', newline='') as myfile:
     wr = csv.writer(myfile)
     wr.writerows(tik500.items())
'''







