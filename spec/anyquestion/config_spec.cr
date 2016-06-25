require "../spec_helper"
require "../../src/anyquestion/config"

describe Anyquestion::Config do
  it "creates a config object" do
    configfile = File.expand_path("#{__DIR__}/../files/config.yml")
    config = Anyquestion::Config.from_yaml File.read(configfile)
    config.public_folder.should eq("spec_public")
  end
  it "applies default values when invalid config file is provided" do
    config = Anyquestion::Config.from_yaml "x: a"
    config.public_folder.should eq("public")
  end
  it "overrides value with env if present" do
    ENV["AQ_PUBLIC_FOLDER"] = "env_public"
    config = Anyquestion::Config.from_yaml("public_folder: from_conf").override_with_env
    config.public_folder.should eq("env_public")
    ENV.delete "AQ_PUBLIC_FOLDER"
  end
  it "not overrides value with env if absent" do
    config = Anyquestion::Config.from_yaml("public_folder: from_conf").override_with_env
    config.public_folder.should eq("from_conf")
  end
end
