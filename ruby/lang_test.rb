##
# RUBY基础语法学习实践.
# History: 
# 2014-05-28 15:31
# 2014-05-29 16:09
# 2014-11-08 14:02

http://www.tutorialspoint.com/ruby/ruby_arrays.htm

for i in 0..5
   if i < 2 then
      puts "Value of local variable is #{i}"
      redo
   end
end
exit 0

#####################
# Blocks:＆ and yield
def meth_captures(arg, &block)
  block.call(arg, 0) + block.call(arg.reverse, 1)  
end

meth_captures('pony') do |word, num|
  puts "in callback! word = #{word.inspect}, num = #{num.inspect}"
  word + num.to_s
end

class Array
  def to_proc
    proc { |receiver| receiver.send *self }
  end
end
p ['Hello', 'Goodbye'].map &[ :+, ' world!' ]
exit 0

#####################
def say(word)
  require 'debug'
  puts word
end
say('abc')
exit 0

#####################
fiber = Fiber.new do
  Fiber.yield 1
  2
end

puts fiber.resume
puts fiber.resume
puts fiber.resume

exit 0

#####################
"abcd".succ        #=> "abce"
"THX1138".succ     #=> "THX1139"
"<<koala>>".succ   #=> "<<koalb>>"
p "a1999zzz".succ     #=> "2000aaa"
p "aZZZ9999".succ     #=> "AAAA0000"
p "***".succ         #=> "**+"
exit 0

#####################
a = "hello there"
p a[/[aeiou](.)\1/]      #=> "ell"
p a[/[aeiou](.)\1/, 0]   #=> "ell"
p a[/[aeiou](.)\1/, 1]   #=> "l"
p a[/[aeiou](.)\1/, 2]   #=> nil

p a[/(?<vowel>[aeiou])(?<non_vowel>[^aeiou])/, "non_vowel"] #=> "l"
p a[/(?<vowel>[aeiou])(?<non_vowel>[^aeiou])/, "vowel"]     #=> "e"

p "hello".center(4)         #=> "hello"
p "hello".center(20)        #=> "       hello        "
p "hello".center(20, '*') #=> "1231231hello12312312"

p "x".chop       #=> ""
p "hello".count "aeiou", "^e" 

p "hello".gsub(/(?<foo>[aeiou])/, '{\k<foo>}')  #=> "h{e}ll{o}"
p "中文字典好啊字典好".gsub(/(?<foo>{字典})/, '{\k<foo>}')  #=> "h{e}ll{o}"
exit 0

#####################

p "%05d" % 123                              #=> "00123"
p "%-5s: %08x" % [ "ID", self.object_id ]   #=> "ID   : 200e14d6"
p "foo = %{foo}" % { :foo => 'bar' }        #=> "foo = bar"
exit 0

#####################
class Class
   alias oldNew  new
   def new(*args)
     print "Creating a new ", self.name, "\n"
     oldNew(*args)
   end
 end

 class Name
 end

 n = Name.new
exit 0

#####################
module Foo
  def self.included(base)
    base.extend ClassMethods  
  end

  module ClassMethods
    def guitar
      "gently weeps"
    end
  end
end

class Bar
  include Foo
end

puts Bar.guitar

#####################
module Mod
  def one
    "This is one"
  end
  module_function :one
end
class Cls
  include Mod
  def call_one
    one
  end
end
Mod.one     #=> "This is one"
c = Cls.new
c.call_one  #=> "This is one"

module Mod
  def one
    "This is the new one"
  end
end
Mod.one     #=> "This is one"
c.call_one  #=> "This is the new one"
exit 0

#####################
module A
  def self.extended(mod)
    puts "#{self} extended in #{mod}"
  end
end
module Enumerable
  extend A
end
exit 0

#####################
module Picky
  def Picky.extend_object(o)
    if String === o
      puts "Can't add Picky to a String"
    else
      puts "Picky added to #{o.class}"
      super
    end
  end
end
(s = Array.new).extend Picky  # Call Object.extend
(s = "quick brown fox").extend Picky
exit 0

#####################
class Thing
end
a = %q{def hello() "Hello there!" end}
Thing.module_eval(a)
puts Thing.new.hello()
Thing.module_eval("invalid code", "dummy", 123)
exit 0

#####################
class Interpreter
  def do_a() print "there, "; end
  def do_d() print "Hello ";  end
  def do_e() print "!\n";     end
  def do_v() print "Dave";    end
  Dispatcher = {
    "a" => instance_method(:do_a),
    "d" => instance_method(:do_d),
    "e" => instance_method(:do_e),
    "v" => instance_method(:do_v)
  }
  def interpret(string)
    string.each_char {|b| Dispatcher[b].bind(self).call }
  end
end

interpreter = Interpreter.new
interpreter.interpret('dave')
exit 0

#####################
current_user ||= false && true
p current_user
current_user ||= nil && true
p current_user
exit 0

#####################
module Foo
  class Bar
    VAL = 10
  end

  class Baz < Bar; end
end

def Object.const_missing(name)
  @looked_for ||= {}  
  p @looked_for
  str_name = name.to_s
  raise "Class not found: #{name}" if @looked_for[str_name]
  @looked_for[str_name] = 1
  file = str_name.downcase
  require file
  klass = const_get(name)
  return klass if klass
  raise "Class not found: #{name}"
end

p Foo::Bar::UNDEFINED_CONST 

exit 0

#####################
#
class Fred
  @@foo = 99
end
p Fred.class_variable_get(:@@foo)     #=> 99

class Thing
  # attr_accessor :sides
  @@sides = 'foo'
end
Thing.class_exec{
  p "Hello there!" + Thing.class_variable_get(:@@sides)
  def hello() "Hello there!" + @@sides end
}
# puts Thing.new.hello()
a = Thing.new
puts Thing.sides

exit 0
#####################
require 'benchmark'
include Benchmark          # we need the CAPTION and FORMAT constants

n = 50000000
Benchmark.benchmark(CAPTION, 7, FORMAT, ">total:", ">avg:") do |x|
  tf = x.report("for:")   { for i in 1..n; a = "1"; end }
  tt = x.report("times:") { n.times do   ; a = "1"; end }
  tu = x.report("upto:")  { 1.upto(n) do ; a = "1"; end }
  [tf+tt+tu, (tf+tt+tu)/3]
end

exit 0
#####################
module Enumerable
  def repeat(n)
    raise ArgumentError, "#{n} is negative!" if n < 0
    unless block_given?
      return to_enum(__method__, n) do
        sz = size
        sz * n if sz
      end
    end
    each do |*val|
      n.times { yield *val }
    end
  end
end

class Mystr < String
  # extend Enumerable1
  include Enumerable
end

# String.extend(Enumerable1)
p Mystr.ancestors
# p String.included_modules()
bc = Mystr.new('hello world')
bc.repeat(2) { |w| puts w }
enum = (1..14).repeat(3)
