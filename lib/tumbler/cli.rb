require 'thor/group'

module Tumbler
  class Cli < Thor::Group
    include Thor::Actions
    
    def self.banner; "tumbler name [options]"; end
    def self.source_root; File.join(File.dirname(__FILE__),'..'); end
      
    desc "Generates a new gem project"

    argument :name, :desc => "name of your awesome gem"

    class_option :changelog,    :desc => 'Set the CHANGELOG file',       :aliases => '-c', :default => 'CHANGELOG', :type => :string
    class_option :update,       :desc => 'Update existing application',  :aliases => '-u', :default => false,       :type => :boolean
    class_option :version,      :desc => 'Set the version number',       :aliases => '-v', :default => '0.0.0',     :type => :string
    class_option :test,         :desc => 'Generate tests',               :aliases => '-t', :default => nil,         :type => :string
    class_option :root,         :desc => 'set root path',                :aliases => '-r', :default => '.',         :type => :string
    class_option :dependencies, :desc => 'set gem dependencies',         :aliases => '-d', :default => nil,         :type => :string
    def setup_gem
    end
  end
end
