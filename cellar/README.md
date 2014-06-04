Cellar Web App
=====

Inspired by [backbone-cellar](https://github.com/ccoenraets/backbone-cellar).
Use Sinatra to Implement a REST API.

New Solution
=====

## Client (Backbone.js & Angular.js)
* Yeoman, Compass, generator-backbone, Bootstrap

## Server (Capistrano + Nginx + Unicorn + Sinatra + Grape)
* Ruby, [sinatra](https://github.com/sinatra/sinatra)
* Ruby, [grape](https://github.com/intridea/grape)
* Nginx, [nginx-boilerplate](https://github.com/Umkus/nginx-boilerplate.git)

## RoR on Nginx
http://wiki.nginx.org/SimpleRubyFCGI
http://www.modrails.com/documentation/Users%20guide%20Nginx.html
https://gist.github.com/vjt/804654

## Configuration

### nginx-boilerplate
* Nginx, [nginx-boilerplate](https://github.com/Umkus/nginx-boilerplate.git)
* src/nginx-bp/os.conf

```
user nginx nginx;
```

* src/nginx.conf

```
pid        /var/run/nginx.pid;
# include     nginx-bp/redirects/nowww.conf;
# include     nginx-bp/redirects/www.conf;
# server          unix:/var/run/php5-fpm.sock max_fails=3 fail_timeout=3s;
```

### Unicorn

``` sh
gem install unicorn
```

### Sinatra
``` sh
gem install sinatra
```

## Refer
* [Nginx Proxied to Unicorn](http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn)
* [Capistrano + Nginx + Unicorn + Sinatra on Ubuntu](https://gist.github.com/wlangstroth/3740923)
* [*AWESOME* nginx configuration for Ruby/Rack web applications](https://gist.github.com/vjt/804654)

