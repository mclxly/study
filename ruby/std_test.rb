##
# RUBY标准库学习实践.
# Init: 
# History: 
# 2014-05-28 15:31
# 2014-05-29 13:20
# Todo: class Containers::Queue
# 
# http://kanwei.github.io/algorithms/
# class Containers::MinHeap

require 'rubygems'
require 'algorithms'
include Containers

# class JupilerLeague extends SplHeap 
# {
#     /**
#      * We modify the abstract method compare so we can sort our
#      * rankings using the values of a given array
#      */
#     public function compare($array1, $array2)
#     {
#         $values1 = array_values($array1);
#         $values2 = array_values($array2);
#         if ($values1[0] === $values2[0]) return 0;
#         return $values1[0] < $values2[0] ? -1 : 1;
#     }
# }

inst_section = {
  cello: 'string',
  clarinet: 'woodwind',
  drum: 'percussion',
  oboe: 'woodwind',
  trumpet: 'brass',
  violin: 'string'
}

puts inst_section[:cello]

exit 0

#####################
heap = MinHeap.new
heap.push(15, "AA Gent")
heap.push(20, 'Anderlecht')
heap.push(11, "Cercle Brugge")
heap.push(12, 'Charleroi')
heap.push(21, "Club Brugge")
heap.push(15, 'G. Beerschot')

print MinHeap::superclass()
p MinHeap.ancestors

until heap.empty?
  a = heap.pop  
  p a
  # a.each {|key, value| puts "#{key} is #{value}" }
end

exit 0

#####################
p Algorithms::Search.binary_search([1, 2, 3], 1) #=> 1
p Algorithms::Search.binary_search([1, 2, 3], 4) #=> nil

p Algorithms::Search.kmp_search("ABC ABCDAB ABCDABCDABDE", "ABCDABD") #=> 15
p Algorithms::Search.kmp_search("ABC ABCDAB ABCDABCDABDE", "ABCDEF") #=> nil

p Algorithms::Sort.comb_sort [5, 4, 3, 1, 2]
p Algorithms::Sort.comb_sort ['AA Gent' => 15, 'Anderlecht' => 20, 'Cercle Brugge' => 11]
exit 0

#####################

# $heap->insert(array ('AA Gent' => 15));

# minheap = Heap.new { |x, y| puts x.values[0]; puts y.values[0]; (x.values[0] <=> y.values[0]) == -1 }
# minheap = Heap.new { |x, y| (x.values[0] <=> y.values[0]) }
minheap = Heap.new { |x, y| (x.values[0] <=> y.values[0]) == -1 }
minheap = Heap.new

minheap.push( {'AA Gent' => 15} )
minheap.push( {'Anderlecht' => 20} )
minheap.push( {'Cercle Brugge' => 11} )
# minheap.push( {'Charleroi' => 12} )
# minheap.push( {'Club Brugge' => 21} )
# minheap.push( {'G. Beerschot' => 15} )

# minheap.pop #=> 6
# p minheap

until minheap.empty?
  a = minheap.pop
  a.each {|key, value| puts "#{key} is #{value}" }
end
puts minheap
p minheap
exit 0

#####################
people = {
  :fred => { :name => "Fred", :age => 23 },
  :joan => { :name => "Joan", :age => 18 },
  :pete => { :name => "Pete", :age => 54 }
}
p people.sort_by { |k, v| v[:age] }
p people

# require 'benchmark/ips'

# def slow(&block)
#   block
# end

# def fast
#   yield 
# end

# Benchmark.ips do |x|
#   x.report('slow')  { slow { 1 + 1} }
#   x.report('fast')  { fast { 1 + 1} }
# end

# names = ['xiaoming', 'xiaohong', 'dage']

# tt = names.select{ |name| name.start_with?('x') }.map { |name| name.upcase  }

# p(tt)