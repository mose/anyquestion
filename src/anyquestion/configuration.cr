require "yaml"

module Anyquestion
  class Configuration
    def self.config_path
      if ENV["AQ_CONFIG"]? && File.exists? ENV["AQ_CONFIG"]
        ENV["AQ_CONFIG"]
      else
        File.expand_path("#{__DIR__}/../../config/config.yml")
      end
    end

    def self.get_config
      if File.exists? config_path
        File.read config_path
      else
        ""
      end
    end
  end
end
