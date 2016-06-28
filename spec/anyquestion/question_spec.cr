require "../spec_helper"
require "../../src/anyquestion/question"

describe Anyquestion::Question do
  describe ".new" do
    q = Anyquestion::Question.new "name", 42
    it "creates a new question from a name and an author" do
      q.should be_a Anyquestion::Question
    end
    it "new question exposes a name" do
      q.name.should eq "name"
    end
    it "new question exposes a numeric id" do
      q.id.should be_a Int64
    end
  end
  describe ".from_json" do
    json = <<-JSON
      {
        "name": "some name",
        "id": 1,
        "author": 42,
        "voters": [],
        "answered": false
      }
    JSON
    q = Anyquestion::Question.from_json json
    it "creates a new question from a name and an author" do
      q.should be_a Anyquestion::Question
    end
    it "new question exposes a name" do
      q.name.should eq "some name"
    end
    it "new question exposes a numeric id" do
      q.id.should be_a Int64
    end
  end
end
