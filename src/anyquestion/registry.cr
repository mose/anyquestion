module Anyquestion
  class Registry
    @rooms = [] of Room

    def add(room : Room)
      # TODO check if rooms already exists
      unless @rooms.includes? room
        @rooms << room
      end
    end

    def remove(room : Room)
      @rooms.delete room
    end
  end
end
