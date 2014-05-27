# require 'benchmark/ips'

# def slow(&block)
# 	block
# end

# def fast
# 	yield	
# end

# Benchmark.ips do |x|
# 	x.report('slow')	{ slow { 1 + 1} }
# 	x.report('fast')	{ fast { 1 + 1} }
# end

# names = ['xiaoming', 'xiaohong', 'dage']

# tt = names.select{ |name| name.start_with?('x') }.map { |name| name.upcase  }

# p(tt)

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
