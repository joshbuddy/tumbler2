require 'thor/group'
require File.expand_path('../generators/actions',__FILE__)
require File.expand_path('../generators/components/actions',__FILE__)

module Tumbler
  class Cli < Thor::Group
    include Thor::Actions
    include Tumbler::Generators::Components::Actions
    include Tumbler::Generators::Actions

    def self.banner; "tumbler name [options]"; end
    def self.source_root; File.dirname(__FILE__); end

    desc "Generates a new gem project"

    argument :name, :desc => "name of your awesome gem"

    class_option :changelog,    :desc => 'Set the CHANGELOG file',  :aliases => '-c', :default => 'CHANGELOG', :type => :string
    class_option :version,      :desc => 'Set the version number',  :aliases => '-v', :default => '0.0.0',     :type => :string
    class_option :root,         :desc => 'set root path',           :aliases => '-r', :default => '.',         :type => :string
    class_option :dependencies, :desc => 'set gem dependencies',    :aliases => '-d', :default => nil,         :type => :string
    class_option :bundle,       :desc => "Run bundle install",      :aliases => '-b', :default => false,       :type => :boolean

    component_option :test, "Testing Framework", :aliases => '-t', :choices => [:rspec, :shoulda, :cucumber, :bacon, :testspec, :riot], :default => :none

    def setup_project
      directory('templates/project/', generate_path)
      template('templates/generic.rb.erb',generate_path("lib/#{name}.rb"))
      generate_version unless options[:version] =~ /none/
      generate_changelog unless options[:changelog] =~ /none/
      generate_gemfile
      generate_gemspec
    end

    def setup_components
      self.class.component_types.each do |comp|
        execute_component_setup comp, resolve_valid_choice(comp)
      end
    end

    def setup_bundler
      run_bundler if options[:bundler]
    end

    def wrap_it_up
      initial_commit
      say "Gem #{name} successfully generated!", :green
    end

  end
end
