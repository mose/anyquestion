require "json"

module Anyquestion
  class Question
    @id : Int64
    @name : String
    @answered : Bool

    getter :name, :id

    JSON.mapping({
      name:     String,
      id:       Int64,
      voters:   Array(Int32),
      answered: Bool,
    })

    def initialize(name, author : Int32)
      @name = name
      @id = Time.new.epoch + Random.new.rand(1000)
      @answered = false
      @voters = [] of Int32
      @voters << author
    end

    def votes
      @voters.size
    end

    def vote(voter)
      if @voters.includes? voter
        @voters.delete voter
      else
        @voters.push voter
      end
    end

    def close
      @answered = true
    end
  end
end
