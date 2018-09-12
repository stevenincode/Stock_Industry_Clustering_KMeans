# Generating industry list 'ind_g.csv' with assigned group numbers, 9-11-2018

import os
os.chdir(r'C:\')
os.getcwd()

import pandas as pd
'''
from urllib.request import urlopen as uReq # it grabs the page
from bs4 import BeautifulSoup as soup # it parses the HTML text

# top 20 Industry list by marketcap

num_indus = 20
induslist = []

my_url = 'https://finviz.com/groups.ashx?g=industry&v=110&o=-marketcap'
                    
uClient = uReq(my_url)
page_html = uClient.read()
uClient.close()
    
page_soup = soup(page_html, 'html.parser')
for j in range(0, num_indus):
    induslist.append(page_soup.findAll('a', class_="tab-link")[j].text.strip())
'''

# hand pick industry list

induslist = ['Property & Casualty Insurance', 'Biotechnology', 'Diversified Machinery', 'Independent Oil & Gas', 'Communication Equipment', 'Asset Management', 'Business Services', 'Medical Instruments & Supplies', 'Regional - Mid-Atlantic Banks', 'Regional - Northeast Banks']
num_indus = len(induslist)

g_num = []
for i in range(1, num_indus + 1):
    g_num.append('G' + str(i))

ind_g = pd.DataFrame(induslist)
ind_g.index = g_num
ind_g.columns = ['ind_ls']

ind_g.to_csv('ind_g.csv', index=True)
















