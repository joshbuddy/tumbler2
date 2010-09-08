require 'bundler'

module Tumbler
  VERSION = "0.1.0"
  
  class Version
    VersionParts = {:major => 0, :minor => 1, :patch => 2}

    attr_reader :manager
    def initialize(manager)
      @manager = manager
    end

    def current_version
      manager.send(:version).to_s
    end

    def update_version(version)
      version_data = File.read(manager.send(:version_file_path))
      version_data.sub!(/V(?i:ersion)(\s*=\s*)(["'])(.*?)\3/, 'V\1\2\3' + version + '\3')
      File.open(version_file_path, 'w') {|f| version_data }
    end

    def bump_version(idx = :patch)
      new_version = []
      version_idx = VersionParts[idx] or raise
      current_version.split('.').each_with_index do |v, idx|
        new_version << case idx <=> version_idx
        when -1 then v
        when 0  then v.succ
        when 1  then '0'
        end
      end
      new_version.join('.')
    end
  end
end