module Anyquestion
  class Room
    @id : Int32
    @name : String
    @time_start : Time

    getter :id
    getter :name
    getter :time_start

    def initialize(name)
      @name = name
      @time_start = Time.now
      @id = @time_start.to_s("%s").to_i
      @questions = {} of Int32 => Question
      @sockets = [] of HTTP::WebSocket
    end

    def nb_questions
      @questions.size
    end

    def nb_users
      @sockets.size
    end
  end
end
