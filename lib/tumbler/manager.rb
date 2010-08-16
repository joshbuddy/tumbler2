module Tumbler
  class Manager
    attr_reader :version, :changelog
    def initialize(root, opts = nil)
      name = opts && opts[:name]
      use_changelog = opts && opts.key?(:use_changelog) ? opts[:use_changelog] : true
      changelog_file = opts && opts[:changelog_file]
      changelog_format = opts && opts[:changelog_format]
      @gem_helper = Bundler::GemHelper.new(root, name)
      @changelog = Changelog.new(@gem_helper, changelog_file, changelog_format) if use_changelog
      @version = Version.new(@gem_helper)
    end
  end
end