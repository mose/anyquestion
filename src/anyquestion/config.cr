require "file_utils"
require "ambience"

module Anyquestion
  module Config
    def self.load(environmement : String)
      if ENV.has_key? "ANYQUESTION_CONFIG"
        @@config_file = ENV["ANYQUESTION_CONFIG"]
      else
        FileUtils.cp("config/config.dist.yml", "config/config.yml") unless File.exists? "config/config.yml"
        @@config_file = "config/config.yml"
      end
      puts @@config_file
      if File.exists? @@config_file
        Ambience.application(@@config_file, environmement)
        Ambience.load
      else
        raise "config file '#{@@config_file}' not found."
      end
    end
  end
end
