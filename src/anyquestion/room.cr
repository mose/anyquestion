module Anyquestion
  class Room
    @id : Int32
    @name : String
    @time_start : Time

    getter :id

    def initialize(name)
      @name = name
      @time_start = Time.now
      @id = @time_start.to_s("%s").to_i
      @messages = [] of String
      @sockets = [] of HTTP::WebSocket
    end
  end
end
