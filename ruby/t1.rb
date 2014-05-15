require 'benchmark/ips'

def slow(&block)
	block
end

def fast
	yield	
end

Benchmark.ips do |x|
	x.report('slow')	{ slow { 1 + 1} }
	x.report('fast')	{ fast { 1 + 1} }
end