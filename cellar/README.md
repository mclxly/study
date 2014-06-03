Cellar Web App
=====

Inspired by [backbone-cellar]:https://github.com/ccoenraets/backbone-cellar.
Use Sinatra to Implement a REST API.

New Solution
=====

## Client (Backbone.js & Angular.js)
* Yeoman, Compass, generator-backbone, Bootstrap

## Server
* Ruby, [sinatra]:https://github.com/sinatra/sinatra/
* Nginx, [nginx-boilerplate]:https://github.com/Umkus/nginx-boilerplate.git

## RoR on Nginx
http://wiki.nginx.org/SimpleRubyFCGI
http://www.modrails.com/documentation/Users%20guide%20Nginx.html
https://gist.github.com/vjt/804654

// -----------------------------------
// Configuration
// -----------------------------------

// -----------------------------------
* Nginx, [nginx-boilerplate]:https://github.com/Umkus/nginx-boilerplate.git
* src/nginx-bp/os.conf
** user nginx nginx;
* src/nginx.conf
** pid        /var/run/nginx.pid;
**     # include     nginx-bp/redirects/nowww.conf;
**     # include     nginx-bp/redirects/www.conf;
**     # server          unix:/var/run/php5-fpm.sock max_fails=3 fail_timeout=3s;