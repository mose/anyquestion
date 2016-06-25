module Anyquestion
  class Registry
    getter :talks

    JSON.mapping({
      talks: Hash(String, Talk),
    })

    def initialize
      @talks = {} of String => Talk
    end

    def add(talk : Talk)
      # TODO check if talks already exists
      unless @talks[talk.id]?
        @talks[talk.id.to_s] = talk
      end
    end

    def remove(talk : Talk)
      @talks.delete talk.id
    end
  end
end
