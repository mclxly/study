# 监视指定网页关键字
# Dependence: 
# pip/pip3 install requests
# pip/pip3 install beautifulsoup4
# yum install mysql-python
# CREATE TABLE `url_set` (
#   `id` INT(11) NOT NULL AUTO_INCREMENT,
#   `url` VARCHAR(32) NULL DEFAULT '' COLLATE 'utf8_bin',
#   `title` VARCHAR(64) NULL DEFAULT '' COLLATE 'utf8_bin',
#   PRIMARY KEY (`id`)
# )
# COLLATE='utf8_bin'
# ENGINE=MyISAM;


import requests
from bs4 import BeautifulSoup
import mysql.connector


# vars list
url = 'http://v2ex.com/?tab=deals'

print('Reading...' + url)

try :
  r = requests.get(url)
  if (400 <= r.status_code) :
    raise Warning('request failed. status_code: ' + str(r.status_code))
  # print(r.text)

  soup = BeautifulSoup(r.text)
  print(soup.title)

  # items = soup.find_all('span', 'item_title', recursive=True, text=['f', 'F'])
  items = soup.find_all('span', 'item_title')
  results = []

  for itm in items:
    if "F码" in itm.text or "f码" in itm.text or "F 码" in itm.text or "f 码" in itm.text :
      link = itm.find('a')
      # print(vars(link.attrs))
      # print(link.attrs['href'])
      print(itm.text + 'ok............')
      results.append({'url': link.attrs['href'], 'title': itm.text})
    # else:
    #   print(type(itm))
    #   print(type(itm.string))
    #   print(type(itm.text))
      # print(vars(str(itm)))
      # raise Warning
  
  #######################################
  # remove exist url
  conn = mysql.connector.connect(user='root', password='123456',
                                host='192.168.21.90',
                                database='web_monitor')

  new_results = []
  for itm in results:
    # print(type(itm['url']))

    cursor = conn.cursor()
    query = ("SELECT count(id) FROM url_set where url = %s")
    cursor.execute(query, (itm['url']))
    print(cursor.statement)
    dataset = cursor.fetchone()
    number_of_rows = dataset[0]

    if 0 == number_of_rows:
      print('new url: ' + itm['url'])
      new_results.append(itm)
           
      # insert new item
      insert_stmt = ("INSERT INTO url_set (url, title) VALUES (%s, %s)")
      data = (itm['url'], itm['title'])
      cursor.execute(insert_stmt, data)
    
    cursor.close()

  conn.close()

  # print(items)
except Exception as exception :
  print("Error:", str(exception))

for itm in new_results:
  print(itm['url'])

print('done')
raise SystemExit