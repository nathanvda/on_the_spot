$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec/core'
#require 'autotest/rspec2'

require 'simplecov'
SimpleCov.start 'rails'

RSpec.configure do |c|
  c.color_enabled = true
end

