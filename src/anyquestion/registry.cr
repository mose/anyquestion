module Anyquestion
  class Registry
    @talks = {} of String => Talk
    getter :talks

    JSON.mapping({
      talks: Hash(String, Talk),
    })

    def initialize
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
