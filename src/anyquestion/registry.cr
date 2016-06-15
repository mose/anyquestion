module Anyquestion
  class Registry
    @rooms = {} of Int64 => Room
    getter :rooms

    def add(room : Room)
      # TODO check if rooms already exists
      unless @rooms[room.id]?
        @rooms[room.id] = room
      end
    end

    def remove(room : Room)
      @rooms.delete room.id
    end
  end
end
