module Tumbler
  class Changelog
    def initialize(manager, file, format)
      @manager, @file, @format = manager, file, format
    end

    def file_path
      File.join(@manager.base, @file)
    end

    def contents
      File.read(file_path)
    end

    def update
      
    end
  end
end