#!/usr/bin/env ruby
#
# Hello world ruby program

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
