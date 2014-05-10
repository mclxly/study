server {
  listen 80;
  server_name forum.stt.newbiiz.com;

  index index.php;
  root	/data/www/stt2013yii/forum;

  location / {
        try_files   $uri $uri/ /index.php;
  }

  location ~* \.php$ {
      include fastcgi.conf; # I include this in http context, it's just here to show it's required for fastcgi!
      try_files $uri =404; # This is not needed if you have cgi.fix_pathinfo = 0 in php.ini (you should!)
      fastcgi_pass 127.0.0.1:9000;
  } 
}
