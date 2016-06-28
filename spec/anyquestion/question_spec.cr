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
  describe ".votes" do
    q = Anyquestion::Question.new "name", 42
    it "should have one vote at creation, from its author" do
      q.votes.should eq 1
    end
  end
  describe ".vote" do
    q = Anyquestion::Question.new "name", 42
    it "should have one more vote when a vote is added" do
      q.vote 43
      q.votes.should eq 2
      q.vote 44
      q.votes.should eq 3
    end
  end
  describe ".close" do
    q = Anyquestion::Question.new "name", 42
    it "should become answered when closed" do
      q.close
      q.answered.should be_truthy
    end
  end
end
