module Anyquestion
  class Registry
    def initialize
      @date_start = ""
      @rooms = [] of Room
    end

    def add(room : Room)
      # TODO check if rooms already exists
      @rooms << room
    end

    def drop(room : Room)
      # TODO remove room from list of rooms
    end
  end
end
