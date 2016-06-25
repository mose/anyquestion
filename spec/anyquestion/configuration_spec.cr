require "../spec_helper"
require "../../src/anyquestion/configuration"

describe Anyquestion::Configuration do
  describe ".config_path" do
    it "by default gives config dist file" do
      path = Anyquestion::Configuration.config_path
      expected = File.expand_path "config/config.yml"
      path.should eq expected
    end
  end
end
