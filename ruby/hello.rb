#!/usr/bin/env ruby
#
# Hello world ruby program

# loip = `ipvsadm -G |awk 'NR>1{if($3!="") print $1,$2}'`
localip = {}
loiptmp = {}

loip = ['10.79.244.34 0',
'10.79.244.34 65',
'10.79.244.35 152']

loip.each do |i|
  t = i.chomp.split(' ')
  localip[t[0]] = localip[t[0]].to_i + t[1].to_i
  # print localip[t[0]].to_i
end

print localip['10.79.244.34']

file = File.open('old.txt',"a+")
# file = IO.readlines('old.txt')
file.each do |old_line|
  d = old_line.chomp.split(':')
  loiptmp[d[0]] = d[1].to_i
  puts  d[0]
end

print loiptmp['10.79.244.34']
exit 0                       

num = 112_222_000_000
puts num

t1 = Array({:a => 'a', :b => 'b'})
puts t1.inspect

exit 0

__END__

class HelloWorld
  def initialize(name)
    @name = name.capitalize
  end

  def sayHi
    puts "Hello #{@name}!"
  end
end

hello = HelloWorld.new("World")
hello.sayHi

def returnArray( a, b, c)
  a = "Hello, " + a
  b = "Hi, " + b
  c = "Bye, " + c
  return a, b, c
end

x, y, z = returnArray( 'colin' ,'ccc', 'ddd')

puts "#{z} #{y} #{z}"
