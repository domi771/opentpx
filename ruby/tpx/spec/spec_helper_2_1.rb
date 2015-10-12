require 'rspec'
require 'timecop'
require 'simplecov'

Dir.glob(File.join(__dir__, '2_1', 'shared', '**', '*.rb')).each do |f|
  require f
end

SimpleCov.start

$:<< File.join(__dir__, '..', 'lib')
require 'tpx'

# http://stackoverflow.com/questions/2603617/ruby-print-the-variable-name-and-then-its-value
# debug_print
# use:  dp(:my_var_name) {}
def dp(s, &b)
  puts "#{s}: #{eval(s.to_s, b.binding)} (#{s.class.to_s})"
end
def di(s, &b)
  puts "#{s}: #{eval(s.inspect, b.binding)} (#{s.class.to_s})"
end
