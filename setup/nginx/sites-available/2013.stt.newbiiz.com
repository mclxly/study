# www to non-www redirect -- duplicate content is BAD:
# https://github.com/h5bp/html5-boilerplate/blob/5370479476dceae7cc3ea105946536d6bc0ee468/.htaccess#L362
# Choose between www and non-www, listen on the *wrong* one and redirect to
# the right one -- http://wiki.nginx.org/Pitfalls#Server_Name
#server {
  # don't forget to tell on which port this server listens
  #listen 80;

  # listen on the www host
  #server_name 2013.stt.newbiiz.com;

  # and redirect to the non-www host (declared below)
  # return 301 $scheme://stt.newbiiz.com$request_uri;
#}

server {
  # listen 80 deferred; # for Linux
  # listen 80 accept_filter=httpready; # for FreeBSD
  listen 80;

  # The host name to respond to
  server_name 2013.stt.newbiiz.com;

  # Path for static files
  root /var/www/html;
  index index.php;
  access_log /var/log/nginx/2013.stt.access;
  error_log /var/log/nginx/2013.stt.error error;

  #Specify a charset
  charset utf-8;

  # Custom 404 page
  error_page 404 /404.html;

  # Include the basic h5bp config set
  include h5bp/basic.conf;

  location / {
    try_files   $uri $uri/ /index.php;
  }

  location ~* \.php$ {
     include fastcgi.conf; # I include this in http context, it's just here to show it's required for fastcgi!
     try_files $uri =404; # This is not needed if you have cgi.fix_pathinfo = 0 in php.ini (you should!)
     fastcgi_pass 127.0.0.1:9000;
  }
}
