require File.join(File.dirname(__FILE__),'teststrap')

context 'Changelog' do
  setup { FileUtils.rm_rf '/tmp/test' }
  setup { capture(:stdout) { Tumbler::Cli.start(['my_gem',"-r=/tmp/test"]) } }
  setup { Tumbler::Manager.new("/tmp/test/my_gem") }
  asserts("should bump the current version by minor") { topic.version.bump_version(:minor); topic.changelog.update; topic.changelog.contents }.equals '0.2.0'
end
