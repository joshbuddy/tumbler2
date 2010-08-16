require File.join(File.dirname(__FILE__),'teststrap')

context 'Version' do
  setup { FileUtils.rm_rf '/tmp/test' }
  setup { capture(:stdout) { Tumbler::Cli.start(['my_gem',"-r=/tmp/test"]) } }
  setup { File.open('/tmp/test/my_gem/lib/my_gem/version.rb', 'w') { |f| f << "module MyGem\n  VERSION='0.1.2'\nend"} }
  setup { Tumbler::Manager.new("/tmp/test/my_gem").version }
  asserts(:current_version).equals '0.1.2'
  asserts("should bump the current version by minor") { topic.bump_version(:minor) }.equals '0.2.0'
  asserts("should bump the current version by tiny")  { topic.bump_version(:patch) }.equals '0.1.3'
  asserts("should bump the current version by major") { topic.bump_version(:major) }.equals '1.0.0'
end
