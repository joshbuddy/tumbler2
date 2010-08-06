require File.join(File.dirname(__FILE__),'teststrap')

context 'Version' do
  setup { File.open("/tmp/version.rb", 'w') {|f| f << "class Something\nVERSION='0.1.2'\nend\n"}; @version = Tumbler::Version.new("/tmp/version.rb") }
  teardown { FileUtils.rm_rf "/tmp/version.rb" }
  asserts("right version") { @version.current_version }.equals '0.1.2'
  asserts("should bump the current version by minor") { @version.bump_version(:minor) }.equals '0.2.0'
  asserts("should bump the current version by tiny") { @version.bump_version(:patch) }.equals '0.1.3'
  asserts("should bump the current version by major") { @version.bump_version(:major) }.equals '1.0.0'
end
