$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec/core'
#require 'autotest/rspec2'



RSpec.configure do |c|
  c.color_enabled = true
#  c.filter_run :focused => true
#  c.run_all_when_everything_filtered = true
#  c.filter_run_excluding :ruby => lambda {|version|
#    case version.to_s
#    when "!jruby"
#      RUBY_ENGINE != "jruby"
#    when /^> (.*)/
#      !(RUBY_VERSION.to_s > $1)
#    else
#      !(RUBY_VERSION.to_s =~ /^#{version.to_s}/)
#    end
#  }
#  c.around do |example|
#    sandboxed { example.run }
#  end
end

