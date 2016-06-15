require "json"

module Anyquestion
  class Question
    @id : Int64
    @name : String

    getter :name, :id

    JSON.mapping({
      name:   String,
      id:     Int64,
      voters: Array(Int32),
    })

    def initialize(name, author : Int32)
      @name = name
      @id = Time.new.epoch + Random.new.rand(1000)
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
