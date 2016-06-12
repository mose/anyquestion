module Anyquestion
  class Question
    @name : String

    getter :name

    def initialize(name)
      @name = name
      @voters = [] of Int32
    end
  end
end
