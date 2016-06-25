module Anyquestion
  class Registry
    @rooms = {} of String => Room
    getter :rooms

    JSON.mapping({
      rooms: Hash(String, Room),
    })

    def initialize
    end

    def add(room : Room)
      # TODO check if rooms already exists
      unless @rooms[room.id]?
        @rooms[room.id.to_s] = room
      end
    end

    def remove(room : Room)
      @rooms.delete room.id
    end
  end
end
