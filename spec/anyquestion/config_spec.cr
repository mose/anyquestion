require "../spec_helper"
require "../../src/anyquestion/config"

describe Anyquestion::Config do
  it "creates a config object" do
    configfile = File.expand_path("#{__DIR__}/../files/config.yml")
    config = Anyquestion::Config.from_yaml File.read(configfile)
    config.public_folder.should eq("public")
  end
end
