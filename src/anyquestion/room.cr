module Anyquestion
  class Room
    @id : Int64
    @name : String
    @time_start : Time

    getter :id
    getter :name
    getter :time_start
    getter :questions

    def initialize(name)
      @name = name
      @time_start = Time.now
      @id = Time.new.epoch + Random.new.rand(1000)
      @questions = {} of Int64 => Question
      @sockets = [] of HTTP::WebSocket
    end

    def nb_questions
      @questions.size
    end

    def nb_users
      @sockets.size
    end

    def handle(socket)
      @sockets.push socket

      socket.send questions_in_order

      socket.on_message do |message|
        if message == "bye"
        elsif message == "hi"
        else
          parts = message.split(/----/)
          if parts.size > 1
            questionId, voter = parts
            @questions[questionId.to_i].vote(voter.to_i)
            @questions.delete questionId.to_i if @questions[questionId.to_i].votes < 1
          else
            author, text = message.split(/::::/)
            question = Question.new text, author.to_i
            @questions[question.id] = question
          end
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
