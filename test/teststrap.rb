require 'rubygems'
require 'tempfile'
require 'fileutils'
require 'riot'
require 'mocha'

$LOAD_PATH << File.basename(__FILE__)
$LOAD_PATH << File.join(File.basename(__FILE__), '..', 'lib')
require 'tumbler'

Riot.reporter = Riot::DotMatrixReporter
class Riot::Situation
end

class Riot::Context

end

class Object
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end

end
