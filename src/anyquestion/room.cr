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

    def handle(socket)
      @sockets.push socket unless @sockets.includes? socket

      socket.send questions_in_order

      socket.on_message do |message|
        # puts message
        parts = message.split(/----/)
        if parts.size > 1
          questionId, voter = parts
          @questions[questionId.to_i].vote(voter.to_i)
        else
          author, text = message.split(/::::/)
          question = Question.new text, author.to_i
          @questions[question.id] = question
        end
        @sockets.each do |s|
          begin
            s.send questions_in_order
          rescue ex
            @sockets.delete s
          end
        end
      end

      socket.on_close do |socket|
        @sockets.delete socket
      end
    end

    def questions_in_order
      @questions.values.sort_by { |k| -k.votes }.to_json
    end
  end
end
