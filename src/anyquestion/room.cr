module Anyquestion
  class Room
    @id : String
    @name : String
    @time_start : Time

    def initialize(name)
      @name = name
      @time_start = Time.now
      @id = @time_start.to_s
    end
  end
end
