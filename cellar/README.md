Cellar Web App
=====

Inspired by [backbone-cellar](https://github.com/ccoenraets/backbone-cellar).
Use Sinatra to Implement a REST API.

New Solution
=====

## Client (Backbone.js & Angular.js)
* Yeoman, Compass, generator-backbone, Bootstrap

### Yeoman, generator-backbone
**related commands**

```
npm install --global yo
npm install --global generator-backbone

yo backbone [app-name]
yo backbone:router <router>
yo backbone:collection <collection>
yo backbone:model <model>
yo backbone:view <view>
```

**example**

1. **mkdir test_app && cd $_** - Make a app folder and cd into it
2. **yo backbone test_app** - Generate a functional boilerplate Backbone app
3. **npm install** - Using the dependencies listed in the current directory's package.json
4. **bower install** - Using the dependencies listed in the current directory's bower.json
5. **grunt build** - Build web stuff

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
* [Capistrano 3.1 + Rails 4 + RVM Simple Single-Stage Configuration](]http://www.bobnisco.com/blog/view/capistrano-31-rails-4-rvm-simple-single-stage-configuration)

