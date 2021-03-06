HELPER=<<-TEST
require 'riot'
require File.expand_path("/../lib/#{name}.rb",File.dirname(__FILE__))

class Riot::Situation
end

class Riot::Context
end
TEST

FLUNK=<<-FAIL
require File.expand_path('test_helper.rb',File.dirname(__FILE__))

context "#{constant_name}" do
  asserts("i flunked") { false }
end
FAIL

def setup_test
  create_file generate_path('test/test_helper.rb'), HELPER
  create_file generate_path("test/#{name}_test.rb"), FLUNK
end