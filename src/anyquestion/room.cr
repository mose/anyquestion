module Anyquestion
  class Room
    @time_start = Time.now

    def initialize(name : String)
      @name = name
    end
  end
end
