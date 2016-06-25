require "../spec_helper"
require "../../src/anyquestion/configuration"

describe Anyquestion::Configuration do
  describe ".config_path" do
    it "by default gives config dist file" do
      expected = File.expand_path "config/config.dist.yml"
      config = File.expand_path "config/config.yml"
      moved = File.expand_path "config/config.bak.yml"
      if File.exists? config
        File.rename config, moved
      end
      path = Anyquestion::Configuration.config_path
      path.should eq expected
      if File.exists? moved
        File.rename moved, config
      end
    end
  end
end
