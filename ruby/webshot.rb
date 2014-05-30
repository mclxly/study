#!/usr/bin/env ruby
#
# Webshot program.
# Based on: PhantomJS + webshot
# Pre install: 
# Init: 2014-05-29 16:44
# History: 


# Setup in CENTOS 6.5
# yum install fontconfig freetype libfreetype.so.6 libfontconfig.so.1 libstdc++.so.6
# wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
# tar xvf phantomjs-1.9.7-linux-x86_64.tar.bz2
# cp phantomjs-1.9.7-linux-x86_64/bin/phantomjs /usr/local/bin
# 
# Chinese Font Problem: 
# 在centos中执行：yum install bitmap-fonts bitmap-fonts-cjk
# 在ubuntu中执行：sudo apt-get install xfonts-wqy

require "webshot"

# Setup Capybara
ws = Webshot::Screenshot.instance

# Capture Google's home page
ws.capture "http://www.jd.com/", "google.png"
exit 0

# Customize thumbnail
ws.capture "http://www.jd.com/", "google.png", width: 100, height: 90, quality: 85

exit 0

# Customize thumbnail generation (MiniMagick)
# see: https://github.com/minimagick/minimagick
ws.capture("http://www.jd.com/", "google.png") do |magick|
  magick.combine_options do |c|
    c.thumbnail "100x"
    c.background "white"
    c.extent "100x90"
    c.gravity "north"
    c.quality 85
  end
end
