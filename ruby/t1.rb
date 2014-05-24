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

require 'abbrev'
require 'pp'

p Abbrev.abbrev(['ruby', 'rules'])