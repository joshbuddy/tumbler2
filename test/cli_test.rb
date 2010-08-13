require File.join(File.dirname(__FILE__),'teststrap')

context "Cli" do

  context "shows the help" do
    setup { capture(:stdout) { Tumbler::Cli.start(['-h']) } }
    asserts_topic.matches  %r{tumbler name \[options\]}
    # asserts_topic.matches  %r{Update existing application}
    asserts_topic.matches  %r{Set the version number}
    asserts_topic.matches  %r{Set the CHANGELOG file}
    asserts_topic.matches  %r{set root path}
  end

end
