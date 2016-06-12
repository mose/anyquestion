module Anyquestion
  class Question
    @name : String

    getter :name

    def initialize(name)
      @name = name
      @voters = [] of Int32
    end

    def votes
      @voters.size
    end

    def vote(voter)
      @voters.push voter unless @voters.includes? voter
    end
  end
end
