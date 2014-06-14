Ruby Language
* 局部变量，函数参数，函数名均应以小写字母后者下划线开头。全局变量用'$'做前缀，实例变量用'@'做前缀，类变量用'@@'做前缀。
* 数据容器
``` sh
# Array
a = [ 'ant', 'bee', 'cat', 'dog', 'elk' ]
a = %w{ ant bee cat dog elk }
# Hash
inst_section = {
  'cello' => 'string',
  'clarinet' => 'woodwind',
  'drum' => 'percussion',
  'oboe' => 'woodwind',
  'trumpet' => 'brass',
  'violin' => 'string'
}
``` 

参考：
* 代码基于[DesignPatternsPHP](https://github.com/domnikl/DesignPatternsPHP)，重写加深理解。
* [Ruby on Rails 3 & 4 Style Guide](https://github.com/bbatsov/rails-style-guide).