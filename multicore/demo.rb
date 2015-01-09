#!/usr/bin/ruby
require 'digest/md5'

def fexe(value="")
    digest = Digest::MD5.hexdigest(value)

    for i in 1..10000
        digest = Digest::MD5.hexdigest(value)
    end
end

count = 0

msg = "http://php.net/manual/en/function.printf.php";

for i in 1..10000
    fexe(msg)
end

puts "done!"