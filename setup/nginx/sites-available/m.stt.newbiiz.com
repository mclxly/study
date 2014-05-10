server {
  set $host_path "/data/www/stt2013yii/mobile/www";

  listen 80;

  server_name m.stt.newbiiz.com;

  # Path for static files
  root /data/www/stt2013yii/mobile/www;
  index index.php;
  access_log /var/log/nginx/mobile.stt.access main;
  error_log /var/log/nginx/mobile.stt.error error; 


  #Specify a charset
  charset utf-8;

  # Custom 404 page
  #error_page 404 /404.html;
  error_page 404 /site/404;

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  location / {
        index index.php index.html;
        try_files $uri $uri/ @rewrite;
  }

  location @rewrite {
        # category
        rewrite ^/category/(.*)$ /products/category?cid=$1;
        # rss
        rewrite (?i)^/rss[/]?$ /site/rss;
        # product
        rewrite ^/product/(.*)$ /products/product?pid=$1;
        # MVC
        rewrite ^/(.*)$ /index.php?r=$1;
  }

  location ~ \.php$ {
	root $host_path;
        include fastcgi.conf; # I include this in http context, it's just here to show it's required for fastcgi!
	fastcgi_param   SCRIPT_FILENAME $host_path/$fastcgi_script_name;
        fastcgi_index	index.php;
	fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass	127.0.0.1:9000;

        try_files $uri =404; # This is not needed if you have cgi.fix_pathinfo = 0 in php.ini (you should!)
  }  

  location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
  }
}
