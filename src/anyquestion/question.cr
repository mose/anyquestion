module Anyquestion
  class Question
    @id : Int32
    @name : String

    getter :name, :id

    def initialize(name, author : Int32)
      @name = name
      @id = Time.now.to_s("%s").to_i
      @voters = [] of Int32
      @voters << author
    end

    def votes
      @voters.size
    end

    def vote(voter)
      @voters.push voter unless @voters.includes? voter
    end
  end
end
