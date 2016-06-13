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
      @messages = [] of String
      @sockets = [] of HTTP::WebSocket
    end

    def nb_questions
      @questions.size
    end

    def nb_users
      @sockets.size
    end

    def handle(socket)
      @sockets.push socket unless @sockets.includes? socket

      socket.send @messages.to_json

      socket.on_message do |message|
        parts = message.split(/----/)
        if parts.size > 1
          question, voter = parts
        else
          author, text = message.split(/::::/)
          question = Question.new text, author.to_i
          @questions[question.id] = question
          @messages.push message
          @sockets.each do |s|
            begin
              s.send @messages.to_json
            rescue ex
              @sockets.delete s
            end
          end
        end
      end

      socket.on_close do |socket|
        @sockets.delete socket
      end
    end
  end
end
