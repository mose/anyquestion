require "./config"

module Anyquestion
  class Configuration
    def self.load
      Anyquestion::Config.from_yaml(self.config_content self.config_path).override_with_env
    end

    def self.config_content(configfile)
      if File.exists? configfile
        File.read configfile
      else
        "nothing: here"
      end
    end

    def self.config_path
      if ENV["AQ_CONFIG"]? && File.exists? ENV["AQ_CONFIG"]
        ENV["AQ_CONFIG"]
      else
        configfile = File.expand_path("#{__DIR__}/../../config/config.yml")
        distfile = File.expand_path("#{__DIR__}/../../config/config.dist.yml")
        if !File.exists?(configfile) && File.exists?(distfile)
          configfile = File.expand_path("#{__DIR__}/../../config/config.dist.yml")
        end
        configfile
      end
    end
  end
end
