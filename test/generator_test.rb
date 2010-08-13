require File.join(File.dirname(__FILE__),'teststrap')

context "Generator" do
  setup { FileUtils.rm_rf '/tmp/test' }

  context "defaults" do
    setup { capture(:stdout) { Tumbler::Cli.start(['my_gem',"-r=/tmp/test"]) } }
    asserts("dir exists") { File.exist? '/tmp/test/my_gem'           }
    asserts("CHANGELOG")  { File.exist? '/tmp/test/my_gem/CHANGELOG' }
    asserts_topic.matches %r{Performing initial commit}
    
    context "my_gem.rb" do
      setup { '/tmp/test/my_gem/lib/my_gem.rb' }
      asserts("my_gem.rb")    { File.exist?  topic  }
      asserts("has module")   { File.read(topic)    }.matches %r{module MyGem #:nodoc}
      asserts("has require")  { File.read(topic)    }.matches %r{require 'my_gem/version'\n}
    end

    context "version.rb" do
      setup { '/tmp/test/my_gem/lib/my_gem/version.rb' }
      asserts("exists")       { File.exists? topic  }
      asserts("has class")    { File.read topic     }.matches %r{module MyGem}
      asserts("has version")  { File.read topic     }.matches %r{0.0.0}
    end

    context "my_gem.gemspec" do
      setup { '/tmp/test/my_gem/my_gem.gemspec' }
      asserts("has name")   { File.read topic }.matches %r{s.name = "my_gem"}
      asserts("has files")  { File.read topic }.matches %r{require_paths = \["lib"\]}
    end

    context "Rakefile" do
      setup { '/tmp/test/my_gem/Rakefile' }
      asserts("has require")    { File.read topic }.matches %r{require 'tumbler'}
      asserts("has rake tasks") { File.read topic }.matches %r{Tumbler.use_rake_tasks}
    end

    context "Gemfile" do
      setup { '/tmp/test/my_gem/Gemfile' }
      asserts("has require")    { File.read topic }.matches %r{source :rubygems}
      asserts("has rake tasks") { File.read topic }.matches %r{gem "tumbler"}
    end

    context "initial commit" do
      setup { ::Git.open '/tmp/test/my_gem' }
      asserts("has tags")       { topic.tags.first.name       }.equals "0.0.0"
      asserts("has commits")    { topic.log(1).first.message  }.equals "initial commit"
    end

  end

  context "suppress changelog creation if disabled" do
    setup { capture(:stdout) { Tumbler::Cli.start(['new_gem','-c=none', "-r=/tmp/test"]) } }
    asserts("has changelog") { File.exist? '/tmp/test/new_gem/CHANGELOG' }.not!
  end

  context "generate changelog with specified name" do
    setup { capture(:stdout) { Tumbler::Cli.start(['new_gem','-c=CHANGES', "-r=/tmp/test"]) } }
    asserts("has changes") { File.exists? '/tmp/test/new_gem/CHANGES' }
  end

  context "surpress version.rb creation if disabled" do
    setup do
      capture(:stdout) { Tumbler::Cli.start(['my_gem','-v=none',"-r=/tmp/test"]) }
      '/tmp/test/my_gem/lib/my_gem.rb'
    end
    asserts("exists")         { File.exists? topic  }
    asserts("has module")     { File.read topic     }.matches %r{module MyGem #:nodoc}
    asserts("has version.rb") { File.exists? '/tmp/test/my_gem/lib/my_gem/version.rb'  }.not!
    asserts("has require")    { File.read(topic) =~ %r{require 'my_gem/version'\n}     }.not!
  end

  context "generate the version.rb if specified" do
    setup do
      capture(:stdout) { Tumbler::Cli.start(['my_gem','-v=1.0.0',"-r=/tmp/test"]) }
      '/tmp/test/my_gem/lib/my_gem/version.rb'
    end
    asserts("exists")       { File.exists? topic  }
    asserts("has module")   { File.read topic     }.matches %r{module MyGem}
    asserts("has version")  { File.read topic     }.matches %r{1.0.0}
  end

  context "generate the gem constant correctly with -" do
    setup { capture(:stdout) { Tumbler::Cli.start(['my-gem','-v=1.0.0',"-r=/tmp/test"]) } }
    setup { '/tmp/test/my-gem/lib/my-gem/version.rb' }
    asserts("My::Gem") { File.read topic }.matches %r{My::Gem}
  end

  context "generate the gem constant correctly with _" do
    setup { capture(:stdout) { Tumbler::Cli.start(['my_gem','-v=1.0.0',"-r=/tmp/test"]) } }
    setup { '/tmp/test/my_gem/lib/my_gem/version.rb' }
    asserts("My::Gem") { File.read topic }.matches %r{MyGem}
  end

end
