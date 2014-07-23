# 监视指定网页关键字
# Dependence: 
# pip/pip3 install requests
# pip/pip3 install beautifulsoup4
# yum install MySQL-python # Python ver 2.*
# CREATE TABLE `url_set` (
#   `id` INT(11) NOT NULL AUTO_INCREMENT,
#   `url` VARCHAR(32) NULL DEFAULT '' COLLATE 'utf8_bin',
#   `title` VARCHAR(64) NULL DEFAULT '' COLLATE 'utf8_bin',
#   `date_added` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
#   PRIMARY KEY (`id`)
# )
# COLLATE='utf8_bin'
# ENGINE=MyISAM;


import requests
from bs4 import BeautifulSoup
import mysql.connector

def sendemail(from_addr, to_addr_list, cc_addr_list,
              subject, message,              
              smtpserver='localhost'):
  import smtplib
  from email.mime.text import MIMEText
  from email.mime.multipart import MIMEMultipart
  from email.header import Header
  
  msg = MIMEMultipart('alternative')
  msg.set_charset('utf8')
  msg['FROM'] = from_addr
  
  #This solved the problem with the encode on the subject.
  msg['Subject'] = Header(
      subject.encode('utf-8'),
      'UTF-8'
  ).encode()

  msg['To'] = ','.join(to_addr_list)
  # msg['CC'] = cc_addr_list

  # And this on the body
  _attach = MIMEText(message.encode('utf-8'), 'html', 'UTF-8')        

  msg.attach(_attach)

  # toaddrs = [toaddr] + cc + bcc
  server = smtplib.SMTP('10.1.3.86')  
  server.sendmail(from_addr, to_addr_list, msg.as_string())

  server.quit()


def debug_var(var):
  print('debug')
  print(var)
  print(type(var))
  # print(vars(var))  

def get_v2ex(url, keywords = []):
  # url = 'http://v2ex.com/?tab=' + tab
  print('Reading...' + url)

  results = []

  try :
    r = requests.get(url)
    if (400 <= r.status_code) :
      raise Warning('request failed. status_code: ' + str(r.status_code))
    
    soup = BeautifulSoup(r.text)
    print(soup.title)

    # items = soup.find_all('span', 'item_title', recursive=True, text=['f', 'F'])
    items = soup.find_all('span', 'item_title')    

    for itm in items:
      # keywords = ["F码","f码","F 码","f 码","388","赠送"]
      link = itm.find('a')
      # print(vars(link.attrs))
      # print(link.attrs['href'])

      if len(keywords) == 0 :
        results.append({'url': link.attrs['href'], 'title': itm.text})
      # if "F码" in itm.text or "f码" in itm.text or "F 码" in itm.text or "f 码" in itm.text :      
      elif True in (word in itm.text for word in keywords) :        
        # print(vars(link.attrs))
        # print(link.attrs['href'])
        print(itm.text + 'ok............')
        results.append({'url': link.attrs['href'], 'title': itm.text})
  except Exception as exception :
    print("Error:", str(exception))  

  return results

# def get_macx():
#   url = 'http://www.macx.cn/forum-10001-1.html'
#   print('Reading...' + url)
#   results = []

#   try :
#     r = requests.get(url)
#     if (400 <= r.status_code) :
#       raise Warning('request failed. status_code: ' + str(r.status_code))
    
#     soup = BeautifulSoup(r.text)
#     print(soup.title)

#     # items = soup.find_all('span', 'item_title', recursive=True, text=['f', 'F'])
#     items = soup.find_all('ul', 'v2-fpic')    

#     for itm in items:
#       print(itm.text)
#       if "388" in itm.text or "5s" in itm.text or "5S" in itm.text :
#         link = itm.find('a')
#         # print(vars(link.attrs))
#         # print(link.attrs['href'])
#         print(itm.text + 'ok............')
#         results.append({'url': link.attrs['href'], 'title': itm.text})
#   except Exception as exception :
#     print("Error:", str(exception))  

#   return results

# vars list
new_results = []

try :
  # r = requests.get(url)
  # if (400 <= r.status_code) :
  #   raise Warning('request failed. status_code: ' + str(r.status_code))
  # # print(r.text)

  # soup = BeautifulSoup(r.text)
  # print(soup.title)

  # # items = soup.find_all('span', 'item_title', recursive=True, text=['f', 'F'])
  # items = soup.find_all('span', 'item_title')
  # results = []

  # for itm in items:
  #   if "F码" in itm.text or "f码" in itm.text or "F 码" in itm.text or "f 码" in itm.text :
  #     link = itm.find('a')
  #     # print(vars(link.attrs))
  #     # print(link.attrs['href'])
  #     print(itm.text + 'ok............')
  #     results.append({'url': link.attrs['href'], 'title': itm.text})
  #   # else:
  #   #   print(type(itm))
  #   #   print(type(itm.string))
  #   #   print(type(itm.text))
  #     # print(vars(str(itm)))
  #     # raise Warning
  results1 = get_v2ex("http://www.v2ex.com/?tab=deals", ["F码","f码","F 码","f 码","388","赠送"])
  results2 = get_v2ex("http://www.v2ex.com/go/free")  
  # results = list(set(results1) | set(results2))
  results = results1 + results2
  print('Finish parsing...')

  #######################################
  # remove exist url
  conn = mysql.connector.connect(user='root', password='123456',
                                host='192.168.21.90',
                                database='web_monitor')
  
  for itm in results:
    # print(type(itm['url']))

    cursor = conn.cursor()
    query = ("SELECT count(id) FROM url_set WHERE url = %(url)s")
    data = {'url': itm['url']}

    cursor.execute(query, data)    
    # print(cursor.statement)
     
    dataset = cursor.fetchone()
    number_of_rows = dataset[0]
    # debug_var(number_of_rows)

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

message = '<ul>'
print('New title list: ')
for itm in new_results:
  print('http://v2ex.com' + itm['url'])
  message += '<li><a href="http://v2ex.com' + itm['url'] + '">' + itm['title'] + '</a></li>'

message += '</ul>'

if message != '<ul></ul>':
  sendemail("colin.lin@newbiiz.com", ["legoo8@qq.com","colin.lin@newbiiz.com"], "", "哈哈，有好消息", message, '10.1.3.86')
  # sendemail("wsw@newbiiz.com", "legoo8@qq.com", "", "哈哈，有好消息", message, '10.1.3.86')

print('done')
raise SystemExit